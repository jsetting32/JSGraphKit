//
//  JSBarPlot.m
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import "JSBarPlot.h"
#import "JSGraphView+Protected.h"

@implementation JSBarPlot

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    [self commonInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame withTheme:self->graphTheme])) return nil;
    [self commonInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTheme:(JSGraphTheme)theme
{
    self->graphTheme = theme;
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
    [self setTheme:self->graphTheme];
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
    
    if (![self.dataSource respondsToSelector:@selector(numberOfDatasets)]) {
        NSAssert(NO, @"It is required to implement the data source 'numberOfDataSets' selector");
    }
    
    if (![self.dataSource respondsToSelector:@selector(datasetAtIndex:)]) {
        NSAssert(NO, @"It is required to implement the data source 'graphViewDataPointsForSetNumber:' selector");
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawBarPlotWithRect:[self generateInnerGraphBoundingRect] context:ctx];
}

- (void)drawBarPlotWithRect:(CGRect)rect context:(CGContextRef)ctx
{    
    int maxGraphHeight = rect.size.height;
    
    CGFloat maxPoint;
    if ([self.dataSource respondsToSelector:@selector(setMaximumValueForGraph)]) {
        maxPoint = [[self.dataSource setMaximumValueForGraph] floatValue];
        if (maxPoint == 0) maxPoint = [self getMaxValueFromDataPoints];
    } else {
        maxPoint = [self getMaxValueFromDataPoints];
    }
    
    NSInteger numberOfSets = [self.dataSource numberOfDatasets];
    
    for (int j = 0; j < numberOfSets; j++) {
        
        NSInteger numberOfPoints = [[self.dataSource datasetAtIndex:j] count];
        
        for (int i = 0; i < numberOfPoints; i++)
        {
            float divider = CGRectGetWidth(rect) / (numberOfPoints * numberOfSets);
            CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] objectAtIndex:i] floatValue];
            
            CGFloat barWidth = self->boundingRect.size.width / numberOfPoints / numberOfSets - (self.barPadding / numberOfSets);
            CGFloat barHeight = maxGraphHeight * (dataPoint / maxPoint);
            CGFloat barXOrigin = rect.origin.x + (i * divider * numberOfSets) + j * divider;
            CGFloat barYOrigin = rect.origin.y + (maxGraphHeight - barHeight);
            
            CGRect barRect = CGRectMake(barXOrigin, barYOrigin, barWidth, barHeight);
            [self drawBar:barRect context:ctx withSet:j];
            [self createButtonWithFrame:barRect dataPointIndex:i setIndex:j];
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
    
    CGGradientRef gradient = [JSGraphView generateGradientWithColors:[self.dataSource gradientColorsForPlotSet:set]];
    
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
    CGGradientRelease(gradient);
}

@end
