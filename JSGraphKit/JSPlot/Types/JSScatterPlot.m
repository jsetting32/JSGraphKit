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
    self.showPointLabels = YES;
    self.pointLabelFont = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:12.0f];
    self.pointLabelTextColor = [UIColor blackColor];
    self.pointLabelAngle = 0.0f;
    self.pointLabelOffset = CGPointMake(10, -10);
    self.pointRadius = 5.0f;
    self.outerPointColor = [UIColor blackColor];
    self.innerPointColor = [UIColor whiteColor];
    self.showGradientUnderLinePlot = NO;
    
    self.lineColor = [UIColor blackColor];
    self.lineWidth = 1.0f;
    self.showLineCurvature = NO;
    self.lineAnimationDuration = 0.0f;

    [self setTheme:self.graphTheme];
}

- (void)setTheme:(JSGraphTheme)theme
{
    [super setTheme:theme];
    
    switch (theme) {
        case JSGraphThemeForest:
            self.outerPointColor = [UIColor blackColor];
            self.innerPointColor = [UIColor colorWithRed:30.0f/255.0f green:200.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
            self.pointLabelTextColor = [UIColor whiteColor];
            self.lineColor = [UIColor colorWithRed:30.0f/255.0f green:255.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
            break;
        case JSGraphThemeDark:
            self.outerPointColor = [UIColor lightGrayColor];
            self.innerPointColor = [UIColor darkGrayColor];
            self.pointLabelTextColor = [UIColor whiteColor];
            self.lineColor = [UIColor blackColor];
            break;
        case JSGraphThemeLight:
            self.outerPointColor = [UIColor blackColor];
            self.innerPointColor = self.outerPointColor;
            self.pointLabelTextColor = [UIColor blackColor];
            self.lineColor = [UIColor blackColor];
            break;
        case JSGraphThemeSky:
            self.outerPointColor = [UIColor whiteColor];
            self.innerPointColor = [UIColor colorWithRed:30.0f/255.0f green:140.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            self.pointLabelTextColor = [UIColor whiteColor];
            self.lineColor = [UIColor colorWithRed:0.0f/255.0f green:110.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            break;
        default:
            self.outerPointColor = [UIColor blackColor];
            self.innerPointColor = [UIColor whiteColor];
            self.pointLabelTextColor = [UIColor blackColor];
            self.lineColor = [UIColor blackColor];
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
    
    for (int i = 0; i < [self.dataSource numberOfDataSets]; i++) {
        if ([self.dataSource numberOfDataPointsForSet:i] == 0) {
            return;
        }
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    self.layer.sublayers = nil;
    [self drawDataPointsWithRect:[self generateInnerGraphBoundingRect] context:ctx];
    [self drawDataPointLabelsWithRect:[self generateInnerGraphBoundingRect] context:ctx];
    [self addButtonsOnDataPointsWithRect:[self generateInnerGraphBoundingRect]];
    
    //[self drawDateLabelsWithRect:theRect context:ctx];
    //[self drawDataPointLabelsWithRect:theRect withFont:[UIFont fontWithName:@"Helvetica" size:2] withTextColor:[UIColor blackColor] withPointRadius:kCircleRadius  context:ctx];
    
    
    //[self drawBarPlotWithRect:theRect context:ctx];
}

- (void)createPathWithRect:(CGRect)theRect withIndex:(int)j
{
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.pointRadius, self.pointRadius) cornerRadius:(self.pointRadius / 2.0f)] CGPath];
    circle.position = CGPointMake(theRect.origin.x, theRect.origin.y);
    
    if ([self.dataSource respondsToSelector:@selector(colorForLineGraphDataPointSet:)]) {
        circle.fillColor = [[[self.dataSource colorForLineGraphDataPointSet:j] lastObject] CGColor];
        circle.strokeColor = [[[self.dataSource colorForLineGraphDataPointSet:j] firstObject] CGColor];
    } else {
        circle.fillColor = [self.innerPointColor CGColor];
        circle.strokeColor = [self.outerPointColor CGColor];
    }
    
    circle.lineWidth = self.lineWidth;
    
    // Add to parent layer
    [self.layer addSublayer:circle];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue   = [NSNumber numberWithFloat:1.0f];
    animation.duration = self.lineAnimationDuration;
    [animation setDelegate:self];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // Important: change the actual layer property before installing the animation.
    [circle setValue:animation.toValue forKeyPath:animation.keyPath];
    
    // Now install the explicit animation, overriding the implicit animation.
    [circle addAnimation:animation forKey:animation.keyPath];

}

#pragma mark - Draw points
- (void)drawDataPointsWithRect:(CGRect)rect context:(CGContextRef)ctx
{
    if (self.pointRadius <= 0.0f) return;
    
    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    
    for (int j = 0; j < [self.dataSource numberOfDataSets]; j++) {

        if ([self.dataSource numberOfDataPointsForSet:j] == 1) {
            float divider = CGRectGetWidth(rect) / 2;
            CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:0 forSetNumber:j] floatValue];
            float y = (rect.size.height - rect.size.height * (dataPoint / maxPoint));
            CGRect theRect = CGRectMake(rect.origin.x + (divider - self.pointRadius / 2), rect.origin.y + (y - self.pointRadius / 2), 2 * self.pointRadius, 2 * self.pointRadius);
            [self createPathWithRect:theRect withIndex:j];
        
        } else {
            float divider = CGRectGetWidth(rect) / (CGFloat)([self.dataSource numberOfDataPointsForSet:j] - 1);
            for (int i = 0; i < [self.dataSource numberOfDataPointsForSet:j]; i++) {
                CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
                float y = (rect.size.height - rect.size.height * (dataPoint / maxPoint));
                CGRect theRect = CGRectMake(rect.origin.x + (i * divider - self.pointRadius / 2), rect.origin.y + (y - self.pointRadius / 2), 2 * self.pointRadius, 2 * self.pointRadius);
                [self createPathWithRect:theRect withIndex:j];

            }
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (flag) {
        [self drawGradientUnderDataWithRect:[self generateInnerGraphBoundingRect] context:ctx];
        [self drawConnectingLinesWithRect:[self generateInnerGraphBoundingRect] context:ctx];
    }
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
    if (self.lineWidth <= 0.0f) return;
    
    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    int maxGraphHeight = rect.size.height;
    
    if (self.showLineCurvature) {
        
        for (int j = 0; j < [self.dataSource numberOfDataSets]; j++) {
            CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:0 forSetNumber:j] floatValue];
            CGFloat x = rect.origin.x;
            CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
            CGPoint p1 = CGPointMake(x, y);

            NSInteger numberOfDataPoints = [self.dataSource numberOfDataPointsForSet:j];
            
            CGMutablePathRef path = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, NULL, x, y);
            float divider = CGRectGetWidth(rect) / (CGFloat)(numberOfDataPoints - 1);
            if (numberOfDataPoints == 2) {
                CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:1 forSetNumber:j] floatValue];

                CGFloat x = rect.origin.x + divider;
                CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
                CGPathAddLineToPoint(path, NULL, x, y);
                
                UIColor *stroke;
                if ([self.dataSource respondsToSelector:@selector(colorForPlotSet:)]) {
                    stroke = [self.dataSource colorForPlotSet:j];
                } else {
                    stroke = self.lineColor;
                }
                
                CAShapeLayer *layer = [JSPlot layerWithPath:path withFillColor:[UIColor clearColor] withStrokeColor:stroke withLineWidth:self.lineWidth];
                [self.layer addSublayer:layer];
                
                if ([self.dataSource respondsToSelector:@selector(animateDurationForDataPointsInSet:)]) {
                    [JSPlot animateWithLayer:layer animationDuration:[self.dataSource animateDurationForDataPointsInSet:j]];
                } else {
                    if (!self.lineAnimationDuration <= 0.0f) [JSPlot animateWithLayer:layer animationDuration:self.lineAnimationDuration];
                }
                
                CGPathRelease(path);
                return;
            }
            /*
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
            */
            
            for (int i = 1; i < numberOfDataPoints; i++) {
                CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
                CGFloat x = rect.origin.x + i * divider;
                CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
                
                CGPoint p2 = CGPointMake(x, y);
                CGPoint midPoint = [JSScatterPlot midPointFromP1:p1 toP2:p2];
                
                CGPathAddQuadCurveToPoint(path, NULL, [JSScatterPlot controlPointForPoints:midPoint p2:p1].x,
                                          [JSScatterPlot controlPointForPoints:midPoint p2:p1].y,
                                          midPoint.x, midPoint.y);
                CGPathAddQuadCurveToPoint(path, NULL, [JSScatterPlot controlPointForPoints:midPoint p2:p2].x,
                                          [JSScatterPlot controlPointForPoints:midPoint p2:p2].y,
                                          p2.x, p2.y);                
                p1 = p2;
            }
            UIColor *stroke;
            if ([self.dataSource respondsToSelector:@selector(colorForPlotSet:)]) {
                stroke = [self.dataSource colorForPlotSet:j];
            } else {
                stroke = self.lineColor;
            }
            
            CAShapeLayer *layer = [JSPlot layerWithPath:path withFillColor:[UIColor clearColor] withStrokeColor:stroke withLineWidth:self.lineWidth];
            [self.layer addSublayer:layer];
            
            if ([self.dataSource respondsToSelector:@selector(animateDurationForDataPointsInSet:)]) {
                [JSPlot animateWithLayer:layer animationDuration:[self.dataSource animateDurationForDataPointsInSet:j]];
            } else {
                if (!self.lineAnimationDuration <= 0.0f) [JSPlot animateWithLayer:layer animationDuration:self.lineAnimationDuration];
            }
            
            CGPathRelease(path);
        }

    } else {
        for (int j = 0; j < [self.dataSource numberOfDataSets]; j++) {
            
            CGMutablePathRef path = CGPathCreateMutable();
            float divider = CGRectGetWidth(rect) / (CGFloat)([self.dataSource numberOfDataPointsForSet:j] - 1);
            for (int i = 0; i < [self.dataSource numberOfDataPointsForSet:j]; i++) {
                CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
                CGFloat x = rect.origin.x + i * divider;
                CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
                if (i == 0) {
                    CGPathMoveToPoint(path, NULL, x, y);
                } else {
                    CGPathAddLineToPoint(path, NULL, x, y);
                }
            }
            
            UIColor *stroke;
            if ([self.dataSource respondsToSelector:@selector(colorForPlotSet:)]) {
                stroke = [self.dataSource colorForPlotSet:j];
            } else {
                stroke = self.lineColor;
            }
            
            
            CAShapeLayer *layer = [JSPlot layerWithPath:path withFillColor:[UIColor clearColor] withStrokeColor:stroke withLineWidth:self.lineWidth];
            [self.layer addSublayer:layer];
            
            if ([self.dataSource respondsToSelector:@selector(animateDurationForDataPointsInSet:)]) {
                [JSPlot animateWithLayer:layer animationDuration:[self.dataSource animateDurationForDataPointsInSet:j]];
            } else {
                if (!self.lineAnimationDuration <= 0.0f) [JSPlot animateWithLayer:layer animationDuration:self.lineAnimationDuration];
            }

            CGPathRelease(path);
        }
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
    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    int maxGraphHeight = rect.size.height;
    
    for (int j = 0; j < [self.dataSource numberOfDataSets]; j++) {
        NSInteger numberOfDataPoints = [self.dataSource numberOfDataPointsForSet:j];
        if (numberOfDataPoints == 1) {
            float divider = CGRectGetWidth(rect) / (CGFloat)(numberOfDataPoints + 1);
            int i = 0;
            CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
            float y = (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
            CGRect theRect = CGRectMake(rect.origin.x + (divider - self.pointRadius * 2), rect.origin.y + (y - self.pointRadius * 2), 4 * self.pointRadius, 4 * self.pointRadius);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = ((i*10000)+30000)+(j*10);
            [button setFrame:theRect];
            [button addTarget:self action:@selector(didTapDataPoint:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
        } else {
            float divider = CGRectGetWidth(rect) / (CGFloat)(numberOfDataPoints - 1);
            for (int i = 0; i < numberOfDataPoints; i++) {
                CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
                float y = (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
                CGRect theRect = CGRectMake(rect.origin.x + (i * divider - self.pointRadius * 2), rect.origin.y + (y - self.pointRadius * 2), 4 * self.pointRadius, 4 * self.pointRadius);
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = ((i*10000)+30000)+(j*10);
                [button setFrame:theRect];
                [button addTarget:self action:@selector(didTapDataPoint:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }

        }
        
    };
    
}

#pragma mark - Draw gradient under line plot
- (void)drawGradientUnderDataWithRect:(CGRect)rect context:(CGContextRef)ctx
{
    if (!self.showGradientUnderLinePlot) return;
    
    if (![self.dataSource respondsToSelector:@selector(gradientColorsForPlotSet:)]) {
        NSAssert(NO, @"It is required to implement the data source 'gradientColorsForPlotSet:' selector with your colors");
    }
        
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


#pragma mark - Data Point Pressed Delegate
- (void)didTapDataPoint:(UIButton *)button
{
    NSInteger intTag2 = (NSInteger)((button.tag-30000)%10000)/10;
    NSInteger intTag1 = (NSInteger)((button.tag-(intTag2*10))-30000)/10000;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JSGraphView:didTapDataPointAtIndex:inSet:)]) {
        [self.delegate JSGraphView:self didTapDataPointAtIndex:intTag1 inSet:intTag2];
    }
}

@end
