//
//  JSScatterPlot.m
//
//  Created by John Setting on 11/19/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "JSScatterPlot.h"

@interface JSScatterPlot()
@property (nonatomic, assign) CGRect innerGraphBoundingRect;
@property (nonatomic, assign) JSGraphTheme graphTheme;
@end

@implementation JSScatterPlot

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
    [self setTheme:self.graphTheme];
    
    self.lineColor = [UIColor blackColor];
    self.lineWidth = 1.0f;

    self.pointLabelFont = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:12.0f];
    self.pointLabelOffset = CGPointMake(0, 0);
    self.pointLabelAngle = 0.0f;
    self.pointLabelTextColor = [UIColor blackColor];
    self.showPointLabels = YES;

    self.showGradientUnderLinePlot = NO;
    
    self.lineCurveMagnitude = 0.0f;
}

- (void)setTheme:(JSGraphTheme)theme
{
    [super setTheme:theme];
    
    switch (theme) {
        case JSGraphThemeDefault:
            self.outerPointColor = [UIColor blackColor];
            self.innerPointColor = self.outerPointColor;
            self.gradientColors = @[[UIColor lightGrayColor], [UIColor darkGrayColor]];
            self.pointLabelTextColor = [UIColor blackColor];
            self.lineColor = [UIColor blackColor];
            break;
        case JSGraphThemeForest:
            self.outerPointColor = [UIColor blackColor];
            self.innerPointColor = [UIColor colorWithRed:30.0f/255.0f green:200.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
            self.gradientColors = @[[UIColor colorWithRed:30.0f/255.0f green:200.0f/255.0f blue:30.0f/255.0f alpha:0.2f],
                                    [UIColor colorWithRed:30.0f/255.0f green:200.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];
            self.pointLabelTextColor = [UIColor whiteColor];
            self.lineColor = [UIColor colorWithRed:30.0f/255.0f green:255.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
            break;
        case JSGraphThemeDark:
            self.outerPointColor = [UIColor lightGrayColor];
            self.innerPointColor = [UIColor darkGrayColor];
            self.gradientColors = @[[UIColor blackColor], [UIColor lightGrayColor]];
            self.pointLabelTextColor = [UIColor whiteColor];
            self.lineColor = [UIColor blackColor];
            break;
        case JSGraphThemeLight:
            self.outerPointColor = [UIColor blackColor];
            self.innerPointColor = self.outerPointColor;
            self.gradientColors = @[[UIColor blueColor], [UIColor redColor]];
            self.pointLabelTextColor = [UIColor blackColor];
            self.lineColor = [UIColor blackColor];
            break;
        case JSGraphThemeSky:
            self.outerPointColor = [UIColor whiteColor];
            self.innerPointColor = [UIColor colorWithRed:30.0f/255.0f green:140.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            self.gradientColors = @[[UIColor colorWithRed:30.0f/255.0f green:140.0f/255.0f blue:255.0f/255.0f alpha:0.2f],
                                    [UIColor colorWithRed:30.0f/255.0f green:140.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
            self.pointLabelTextColor = [UIColor whiteColor];
            self.lineColor = [UIColor colorWithRed:0.0f/255.0f green:110.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect
{    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self generateInnerGraphBoundingRect];
    [self drawGradientUnderDataWithRect:self.innerGraphBoundingRect context:ctx];
    [self drawConnectingLinesWithRect:self.innerGraphBoundingRect context:ctx];
    [self drawDataPointsWithRect:self.innerGraphBoundingRect context:ctx];
    [self drawDataPointLabelsWithRect:self.innerGraphBoundingRect context:ctx];
    [self addButtonsOnDataPointsWithRect:self.innerGraphBoundingRect];
    
    //[self drawDateLabelsWithRect:theRect context:ctx];
    //[self drawDataPointLabelsWithRect:theRect withFont:[UIFont fontWithName:@"Helvetica" size:2] withTextColor:[UIColor blackColor] withPointRadius:kCircleRadius  context:ctx];
    
    
    //[self drawBarPlotWithRect:theRect context:ctx];
}


#pragma mark - Draw points
- (void)drawDataPointsWithRect:(CGRect)rect context:(CGContextRef)ctx
{
    CGContextSetFillColorWithColor(ctx, [self.outerPointColor CGColor]);
    CGContextSaveGState(ctx);

    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    int maxGraphHeight = rect.size.height;

    for (int j = 0; j < [self.dataSource numberOfDataSets]; j++) {
        float divider = CGRectGetWidth(rect) / (CGFloat)([self.dataSource numberOfDataPointsForSet:j] - 1);
        for (int i = 0; i < [self.dataSource numberOfDataPointsForSet:j]; i++) {
            CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
            float y = (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
            CGRect theRect = CGRectMake(rect.origin.x + (i * divider - self.pointRadius), rect.origin.y + (y - self.pointRadius), 2 * self.pointRadius, 2 * self.pointRadius);
            CGContextAddEllipseInRect(ctx, theRect);
        }
    }
    
    
    CGContextRestoreGState(ctx);
    CGContextDrawPath(ctx, kCGPathFill);
    
    CGContextSetFillColorWithColor(ctx, [self.innerPointColor CGColor]);
    CGContextSaveGState(ctx);
    
    for (int j = 0; j < [self.dataSource numberOfDataSets]; j++) {
        float divider = CGRectGetWidth(rect) / (CGFloat)([self.dataSource numberOfDataPointsForSet:j] - 1);
        for (int i = 0; i < [self.dataSource numberOfDataPointsForSet:j]; i++) {
            CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
            float y = (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
            CGRect theRect = CGRectMake(rect.origin.x + (i * divider - (self.pointRadius / 2.0f)), rect.origin.y + (y - (self.pointRadius / 2.0f)), self.pointRadius, self.pointRadius);
            CGContextAddEllipseInRect(ctx, theRect);
        }
    }
    
    CGContextRestoreGState(ctx);
    CGContextDrawPath(ctx, kCGPathFill);
}

#pragma mark - Draw point labels
- (void)drawDataPointLabelsWithRect:(CGRect)rect context:(CGContextRef)ctx
{
    if (!self.showPointLabels) return;
    
    CGContextSaveGState(ctx);

    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    
    int maxGraphHeight = rect.size.height;
    
    for (int j = 0; j < [self.dataSource numberOfDataSets]; j++) {
        float divider = CGRectGetWidth(rect) / (CGFloat)([self.dataSource numberOfDataPointsForSet:j] - 1);
        for (int i = 0; i < [self.dataSource numberOfDataPointsForSet:j]; i++) {
            CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
            float y = (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
            NSString *theText = [NSString stringWithFormat:@"%i", (int)dataPoint];
            CGRect textRect = CGRectMake(rect.origin.x + i * divider, rect.origin.y + y, 2, 2);
            CGPoint p = CGPointMake(textRect.origin.x + self.pointLabelOffset.x, textRect.origin.y + self.pointLabelOffset.y);
            [JSPlot drawWithBasePoint:p andAngle:self.pointLabelAngle andFont:self.pointLabelFont andColor:self.pointLabelTextColor theText:theText];
        }
    }
    
    CGContextRestoreGState(ctx);
}

#pragma mark - Draw line plot
- (void)drawConnectingLinesWithRect:(CGRect)rect context:(CGContextRef)ctx
{
    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    int maxGraphHeight = rect.size.height;

    CGContextSetLineWidth(ctx, self.lineWidth);
    
    /*
    if (self.lineCurveMagnitude > 0.0f) {
        CGFloat dataPoint = [[dataPoints objectAtIndex:0] floatValue];
        CGFloat x = rect.origin.x;
        CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
        CGPoint p1 = CGPointMake(x, y);
        CGContextMoveToPoint(ctx, x, y);
        
        if ([dataPoints count] == 2) {
            CGFloat x = rect.origin.x + divider;
            CGContextAddLineToPoint(ctx, x, y);
            CGContextDrawPath(ctx, kCGPathStroke);
            return;
        }
        
        NSMutableArray *minimaIndexes = [NSMutableArray array];
        NSMutableArray *maximaIndexes = [NSMutableArray array];
        NSMutableArray *stack = [NSMutableArray array];
        

        
        [stack addObject:[dataPoints objectAtIndex:0]];
        for (int i = 1; i < [dataPoints count]; i++) {
            NSNumber * d2 = [dataPoints objectAtIndex:i];

            if ([[stack lastObject] floatValue] > [d2 floatValue]) {
                [stack addObject:d2];
            } else {
                [maximaIndexes addObject:[NSNumber numberWithInt:i]];
                stack = [NSMutableArray array];
                [stack addObject:d2];
            }
        }
 
        for (NSNumber *number in maximaIndexes) {
            NSLog(@"%@", [dataPoints objectAtIndex:[number integerValue] -1 ]);
        }

        NSLog(@"%@", maximaIndexes);

        
        for (int i = 1; i < [dataPoints count]; i++) {
            CGFloat dataPoint = [[dataPoints objectAtIndex:i] floatValue];
            CGFloat x = rect.origin.x + i * divider;
            CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));

            CGPoint p2 = CGPointMake(x, y);
            CGPoint midPoint = [JSScatterPlot midPointFromP1:p1 toP2:p2];
            if (p1.y > p2.y) {
                CGContextAddQuadCurveToPoint(ctx, [JSScatterPlot controlPointForPoints:midPoint p2:p1].x,
                                             [JSScatterPlot controlPointForPoints:midPoint p2:p1].y,
                                             midPoint.x, midPoint.y);
                
                CGContextAddQuadCurveToPoint(ctx, [JSScatterPlot controlPointForPoints:midPoint p2:p2].x,
                                             [JSScatterPlot controlPointForPoints:midPoint p2:p2].y,
                                             p2.x, p2.y);
            } else {
                CGContextAddQuadCurveToPoint(ctx, [JSScatterPlot controlPointForPoints:midPoint p2:p1].x,
                                             [JSScatterPlot controlPointForPoints:midPoint p2:p1].y,
                                             midPoint.x, midPoint.y);
                
                CGContextAddQuadCurveToPoint(ctx, [JSScatterPlot controlPointForPoints:midPoint p2:p2].x,
                                             [JSScatterPlot controlPointForPoints:midPoint p2:p2].y,
                                             p2.x, p2.y);
                //CGContextAddLineToPoint(ctx, x, y);
            }
            
            p1 = p2;
        }
        CGContextDrawPath(ctx, kCGPathStroke);
    } else {
    */
    
    
    for (int j = 0; j < [self.dataSource numberOfDataSets]; j++) {
        
        if ([self.dataSource respondsToSelector:@selector(colorForPlotSet:)]) {
            CGContextSetStrokeColorWithColor(ctx, [[self.dataSource colorForPlotSet:j] CGColor]);
        } else {
            CGContextSetStrokeColorWithColor(ctx, [self.lineColor CGColor]);
        }

        CGContextBeginPath(ctx);

        float divider = CGRectGetWidth(rect) / (CGFloat)([self.dataSource numberOfDataPointsForSet:j] - 1);
        for (int i = 0; i < [self.dataSource numberOfDataPointsForSet:j]; i++) {
            CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
            CGFloat x = rect.origin.x + i * divider;
            CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
            if (i == 0) {
                CGContextMoveToPoint(ctx, x, y);
            } else {
                CGContextAddLineToPoint(ctx, x, y);
            }
        }
        CGContextDrawPath(ctx, kCGPathStroke);
    }
}

+ (CGPoint)midPointFromP1:(CGPoint)p1 toP2:(CGPoint)p2
{
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

+ (CGPoint)controlPointForPoints:(CGPoint)p1 p2:(CGPoint)p2 {
    CGPoint controlPoint = [JSScatterPlot midPointFromP1:p1 toP2:p2];
    CGFloat diffY = abs(p2.y - controlPoint.y);

    if (p1.y < p2.y)
        controlPoint.y += diffY;
    else if (p1.y > p2.y)
        controlPoint.y -= diffY;
    return controlPoint;
}

#pragma mark - Add UIButtons to points
- (void)addButtonsOnDataPointsWithRect:(CGRect)rect
{
    [self iteratorForDataPointsWithRect:rect block:^(int maxGraphHeight, CGFloat maxPoint, float divider, CGFloat dataPoint, int i) {
        float y = (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
        CGRect theRect = CGRectMake(rect.origin.x + (i * divider - self.pointRadius * 2), rect.origin.y + (y - self.pointRadius * 2), 4 * self.pointRadius, 4 * self.pointRadius);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:i];
        [button setFrame:theRect];
        [button addTarget:self action:@selector(didTapDataPoint:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }];
}

#pragma mark - Draw gradient under line plot
- (void)drawGradientUnderDataWithRect:(CGRect)rect context:(CGContextRef)ctx
{
    if (!self.showGradientUnderLinePlot) return;
    
    //NSAssert(colors, @"You are passing an empty array of colors into 'gradientColors'. There must at least be one!");

    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    
    int maxGraphHeight = rect.size.height;


    CGPoint startPoint, endPoint;
    startPoint.x = 0;
    startPoint.y = rect.origin.y + rect.size.height - self.boxLineWidth;
    endPoint.x = 0;
    endPoint.y = 0;
    
    for (int j = 0; j < [self.dataSource numberOfDataSets]; j++) {
        
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        
        NSArray *colors = [self.dataSource gradientColorsForPlotSet:j];
        
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
        
        
        CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:0 forSetNumber:j] floatValue];
        float y = (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, rect.origin.x, startPoint.y);
        CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y + y);
        float divider = CGRectGetWidth(rect) / (CGFloat)([self.dataSource numberOfDataPointsForSet:j] - 1);

        for (int i = 0; i < [self.dataSource numberOfDataPointsForSet:j]; i++) {
            CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
            float y = (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
            CGContextAddLineToPoint(ctx, rect.origin.x + (divider * (i)), rect.origin.y + y);
        }
        
        CGContextAddLineToPoint(ctx, rect.origin.x + (divider * ([self.dataSource numberOfDataPointsForSet:j] - 1)), startPoint.y);
        CGContextClosePath(ctx);
        CGContextSaveGState(ctx);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(ctx);
        CGColorSpaceRelease(colorspace);
        CGGradientRelease(gradient);
    }
    
    
}

- (void)generateInnerGraphBoundingRect
{
    CGFloat top = (self.overallGraphPadding != 0.0f) ? self.overallGraphPadding : self.topGraphPadding;
    CGFloat bottom = [self bounds].size.height - ((self.overallGraphPadding != 0.0f) ? self.overallGraphPadding * 2 : self.bottomGraphPadding * 2);
    bottom -= (self.overallGraphPadding != 0.0f) ? self.overallGraphPadding : self.topGraphPadding;
    CGFloat left = (self.overallGraphPadding != 0.0f) ? self.overallGraphPadding : self.leftGraphPadding;
    CGFloat right = (self.overallGraphPadding != 0.0f) ? (CGRectGetWidth(self.bounds) - self.overallGraphPadding * 2) : (CGRectGetWidth(self.bounds) - self.rightGraphPadding * 2);
    
    CGRect rect = CGRectMake(left, top, right, bottom);
    
    rect.origin.y += self.boundingRect.origin.y;
    rect.origin.x += self.boundingRect.origin.x;
    rect.size.width = right - (self.boundingRect.origin.x * 2);
    rect.size.height = bottom - (self.boundingRect.origin.y * 2);

    self.innerGraphBoundingRect = rect;
}

#pragma mark - Data Point Pressed Delegate
- (void)didTapDataPoint:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JSPlot:didTapBarPlotAtIndex:inSet:)]) {
        //[self.delegate JSPlot:self didTapDataPointAtIndex:[button tag] inSet:];
    }
}

@end
