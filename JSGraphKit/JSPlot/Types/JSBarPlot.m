//
//  JSBarPlot.m
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import "JSBarPlot.h"

@interface JSBarPlot()
@property (nonatomic, assign) CGRect innerGraphBoundingRect;
@property (nonatomic, assign) JSGraphTheme graphTheme;
@end

@implementation JSBarPlot

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    [self commonInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame withTheme:self.graphTheme])) return nil;
    [self commonInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTheme:(JSGraphTheme)theme
{
    self.graphTheme = theme;
    return [self initWithFrame:frame];
}

- (void)commonInit
{
    self.barWidth = 20.0f;
    self.barColor = [UIColor whiteColor];
    self.barOutlineColor = [UIColor blackColor];
    self.barPadding = 10.0f;
    self.automaticallyAdjustBars = YES;
    self.showBarGradientColors = YES;
    self.barGradientColorDirection = JSBarGradientDirectionHorizontal;
    self.barGradientColors = @[[UIColor lightGrayColor], [UIColor darkGrayColor]];
    self.barAnimationDuration = 0.0f;
    [self setTheme:self.graphTheme];
}


- (void)setTheme:(JSGraphTheme)theme
{
    [super setTheme:theme];
    
    switch (theme) {
        case JSGraphThemeForest:
            self.barGradientColors = @[[UIColor colorWithRed:30.0f/255.0f green:200.0f/255.0f blue:30.0f/255.0f alpha:0.2f],
                                       [UIColor colorWithRed:30.0f/255.0f green:200.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];
            break;
        case JSGraphThemeDark:
            self.barGradientColors = @[[UIColor blackColor], [UIColor lightGrayColor]];
            break;
        case JSGraphThemeLight:
            self.barGradientColors = @[[UIColor blueColor], [UIColor redColor]];
            break;
        case JSGraphThemeSky:
            self.barGradientColors = @[[UIColor colorWithRed:30.0f/255.0f green:140.0f/255.0f blue:255.0f/255.0f alpha:0.2f],
                                       [UIColor colorWithRed:30.0f/255.0f green:140.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
            break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (![self.dataSource respondsToSelector:@selector(numberOfDataSets)]) {
        NSAssert(NO, @"It is required to implement the data source 'numberOfDataSets' selector");
    }
    
    if (![self.dataSource respondsToSelector:@selector(numberOfDataPointsForSet:)]) {
        NSAssert(NO, @"It is required to implement the data source 'numberOfDataPointsForSet:' selector");
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawBarPlotWithRect:[self generateInnerGraphBoundingRect] context:ctx];
}

- (void)drawBarPlotWithRect:(CGRect)rect context:(CGContextRef)ctx
{

    
    int maxGraphHeight = rect.size.height;
    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    
    NSInteger numberOfSets = [self.dataSource numberOfDataSets];
    
    for (int j = 0; j < numberOfSets; j++) {
        
        NSInteger numberOfPoints = [self.dataSource numberOfDataPointsForSet:j];
        
        for (int i = 0; i < numberOfPoints; i++)
        {
            float divider = CGRectGetWidth(rect) / (numberOfPoints * numberOfSets);
            CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
            
            CGFloat barWidth = self.boundingRect.size.width / numberOfPoints / numberOfSets - (self.barPadding / numberOfSets);
            CGFloat barHeight = maxGraphHeight * (dataPoint / maxPoint);
            CGFloat barXOrigin = rect.origin.x + (i * divider * numberOfSets) + j * divider;
            CGFloat barYOrigin = rect.origin.y + (maxGraphHeight - barHeight);
            
            CGRect barRect = CGRectMake(barXOrigin, barYOrigin, barWidth, barHeight);
            [self drawBar:barRect context:ctx withSet:j];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = ((i*10000)+30000)+(j*10);
            [button setFrame:barRect];
            [button addTarget:self action:@selector(didTapBarPlot:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
    }
}


- (void)drawBar:(CGRect)rect context:(CGContextRef)ctx withSet:(NSInteger)set
{
    NSAssert(!(self.showBarGradientColors && [[self.dataSource gradientColorsForPlotSet:set] count] < 2),
             @"You need to add at least two colors to your bar gradient colors");
    
    if (!self.showBarGradientColors) {
        CGContextBeginPath(ctx);
        CGContextSetStrokeColorWithColor(ctx, [self.barOutlineColor CGColor]);
        CGContextSetFillColorWithColor(ctx, [[self.dataSource colorForPlotSet:set] CGColor]);
        CGContextStrokeRect(ctx, rect);
        CGContextFillRect(ctx, rect);
        return;
    }
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();

    NSArray *colors = [self.dataSource gradientColorsForPlotSet:set];
    
    CGFloat locations[[colors count]];
    NSMutableArray *colorsRefs = [NSMutableArray array];
    for (int i = 0; i < [colors count]; i++ ) {
        UIColor *color = [colors objectAtIndex:i];
        if (i == 0) {
            locations[i] = 0.0f;
        } else if (i == [colors count] - 1) {
            locations[i] = 1.0f;
        } else {
            locations[i] = i / [colors count];
        }
        
        [colorsRefs addObject:(__bridge id)[color CGColor]];
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef) colorsRefs, locations);
    
    CGPoint startPoint = rect.origin;
    
    
    CGPoint endPoint = (self.barGradientColorDirection == JSBarGradientDirectionHorizontal) ?
    CGPointMake(rect.origin.x + rect.size.width, rect.origin.y) : CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    
    // Create and apply the clipping path
    CGContextBeginPath(ctx);
        
    CGContextSetStrokeColorWithColor(ctx, [self.barOutlineColor CGColor]);

    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));

    CGContextClosePath(ctx);
    
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    
    // Draw the gradient
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    
    // Release the resources
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
}

#pragma mark - Data Point Pressed Delegate
- (void)didTapBarPlot:(UIButton *)button
{
    NSInteger intTag2 = (NSInteger)((button.tag-30000)%10000)/10;
    NSInteger intTag1 = (NSInteger)((button.tag-(intTag2*10))-30000)/10000;

    if (self.delegate && [self.delegate respondsToSelector:@selector(JSGraphView:didTapDataPointAtIndex:inSet:)]) {
        [self.delegate JSGraphView:self didTapDataPointAtIndex:intTag1 inSet:intTag2];
    }
}

@end
