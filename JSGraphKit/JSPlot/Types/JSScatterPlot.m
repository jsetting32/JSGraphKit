//
//  JSScatterPlot.m
//
//  Created by John Setting on 11/19/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "JSScatterPlot.h"
#import "JSGraphView+Protected.h"


@implementation JSScatterPlot

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
    self.dataPointAnimationDuration = 0.0f;

    [self setTheme:self->graphTheme];
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
    
    if (![self.dataSource respondsToSelector:@selector(numberOfDatasets)]) {
        NSAssert(NO, @"It is required to implement the data source 'numberOfDataSets' selector");
    }
    
    if (![self.dataSource respondsToSelector:@selector(datasetAtIndex:)]) {
        NSAssert(NO, @"It is required to implement the data source 'graphViewDataPointsForSetNumber:' selector");
    }
    
    for (int i = 0; i < [self.dataSource numberOfDatasets]; i++) {
        if ([[self.dataSource datasetAtIndex:i] count] == 0) {
            return;
        }
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    self.layer.sublayers = nil;
    [self drawGradientUnderDataWithRect:[self generateInnerGraphBoundingRect] context:ctx];
    [self drawDataPointsWithRect:[self generateInnerGraphBoundingRect] context:ctx];
    [self drawDataPointLabelsWithRect:[self generateInnerGraphBoundingRect] context:ctx];
    if (self.dataPointAnimationDuration <= 0.0f)
        [self drawConnectingLinesWithRect:[self generateInnerGraphBoundingRect] context:ctx];

    //[self drawDateLabelsWithRect:theRect context:ctx];
    //[self drawDataPointLabelsWithRect:theRect withFont:[UIFont fontWithName:@"Helvetica" size:2] withTextColor:[UIColor blackColor] withPointRadius:kCircleRadius  context:ctx];
    
    
    //[self drawBarPlotWithRect:theRect context:ctx];
}

- (void)createPathWithRect:(CGRect)theRect withIndex:(int)j
{
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    circle.path = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.pointRadius, self.pointRadius)
                                              cornerRadius:(self.pointRadius / 2.0f)] CGPath];
    circle.position = CGPointMake(theRect.origin.x, theRect.origin.y);
    
    if ([self.dataSource respondsToSelector:@selector(colorForLineGraphDataPointSet:)]) {
        circle.fillColor = [[[self.dataSource colorForLineGraphDataPointSet:j] lastObject] CGColor];
        circle.strokeColor = [[[self.dataSource colorForLineGraphDataPointSet:j] firstObject] CGColor];
    } else {
        circle.fillColor = [self.innerPointColor CGColor];
        circle.strokeColor = [self.outerPointColor CGColor];
    }
    
    circle.lineWidth = self.lineWidth;
    [self.layer addSublayer:circle];
    if (self.dataPointAnimationDuration > 0.0f) {
        CABasicAnimation *animation = [self animateDataPointWithLayer:circle animationDuration:self.dataPointAnimationDuration];
        [circle addAnimation:animation forKey:animation.keyPath];
    }
}

#pragma mark - Draw points
- (void)drawDataPointsWithRect:(CGRect)rect context:(CGContextRef)ctx
{
    if (self.pointRadius <= 0.0f) return;
    
    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    
    for (int j = 0; j < [self.dataSource numberOfDatasets]; j++) {

        NSInteger numberOfDataPoints = [[self.dataSource datasetAtIndex:j] count];

        if (numberOfDataPoints == 1) {
            float divider = CGRectGetWidth(rect) / 2;
            CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] firstObject] floatValue];
            float y = (rect.size.height - rect.size.height * (dataPoint / maxPoint));
            CGRect theRect = CGRectMake(rect.origin.x + (divider - self.pointRadius / 2),
                                        rect.origin.y + (y - self.pointRadius / 2),
                                        2 * self.pointRadius,
                                        2 * self.pointRadius);
            [self createPathWithRect:theRect withIndex:j];
            [self createButtonWithFrame:theRect dataPointIndex:0 setIndex:j];
        } else {
            float divider = CGRectGetWidth(rect) / (CGFloat)(numberOfDataPoints - 1);
            for (int i = 0; i < numberOfDataPoints; i++) {
                CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] objectAtIndex:i] floatValue];
                float y = (rect.size.height - rect.size.height * (dataPoint / maxPoint));
                CGRect theRect = CGRectMake(rect.origin.x + (i * divider - self.pointRadius / 2),
                                            rect.origin.y + (y - self.pointRadius / 2),
                                            2 * self.pointRadius,
                                            2 * self.pointRadius);
                [self createPathWithRect:theRect withIndex:j];
                [self createButtonWithFrame:theRect dataPointIndex:i setIndex:j];
            }
        }
    }
}

#pragma mark - Draw point labels
- (void)drawDataPointLabelsWithRect:(CGRect)rect context:(CGContextRef)ctx
{
    if (!self.showPointLabels) return;
    
    CGContextSaveGState(ctx);

    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    
    int maxGraphHeight = rect.size.height;
    
    for (int j = 0; j < [self.dataSource numberOfDatasets]; j++) {
        NSInteger numberOfDataPoints = [[self.dataSource datasetAtIndex:j] count];
        float divider = CGRectGetWidth(rect) / (CGFloat)(numberOfDataPoints - 1);
        for (int i = 0; i < numberOfDataPoints; i++) {
            CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] objectAtIndex:i] floatValue];
            CGFloat y = rect.origin.y + (maxGraphHeight - maxGraphHeight * (dataPoint / maxPoint));
            NSString *theText = [NSString stringWithFormat:@"%i", (int)dataPoint];
            CGRect textRect = CGRectMake(rect.origin.x + i * divider, y, 2, 2);
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
    
    NSLog(@"%@", ctx);
    
    if (self.showLineCurvature) {
        
        for (int j = 0; j < [self.dataSource numberOfDatasets]; j++) {
            CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] firstObject] floatValue];
            CGFloat x = rect.origin.x;
            CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
            CGPoint p1 = CGPointMake(x, y);

            NSInteger numberOfDataPoints = [[self.dataSource datasetAtIndex:j] count];
            
            CGMutablePathRef path = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, NULL, x, y);
            float divider = CGRectGetWidth(rect) / (CGFloat)(numberOfDataPoints - 1);
            for (int i = 0; i < numberOfDataPoints; i++) {
                CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] objectAtIndex:i] floatValue];
                CGFloat x = rect.origin.x + i * divider;
                CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
                
                CGPoint p2 = CGPointMake(x, y);
                CGPoint midPoint = [JSGraphView midPointFromP1:p1 toP2:p2];
                                    
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
            
            CAShapeLayer *layer = [self layerWithPath:path withFillColor:[UIColor clearColor] withStrokeColor:stroke withLineWidth:self.lineWidth];
            [self.layer addSublayer:layer];
            
            if ([self.dataSource respondsToSelector:@selector(animateDurationForDataPointsInSet:)]) {
                CABasicAnimation *animation = [self animateLineWithLayer:layer animationDuration:[self.dataSource animateDurationForDataPointsInSet:j]];
                [layer addAnimation:animation forKey:animation.keyPath];
            } else {
                if (self.lineAnimationDuration > 0.0f) {
                    CABasicAnimation *animation = [self animateLineWithLayer:layer animationDuration:self.lineAnimationDuration];
                    [layer addAnimation:animation forKey:animation.keyPath];
                }
            }
            
            CGPathRelease(path);
        }

    } else {
        for (int j = 0; j < [self.dataSource numberOfDatasets]; j++) {
            
            CGMutablePathRef path = CGPathCreateMutable();
            NSInteger numberOfDataPoints = [[self.dataSource datasetAtIndex:j] count];

            float divider = CGRectGetWidth(rect) / (CGFloat)(numberOfDataPoints - 1);
            for (int i = 0; i < numberOfDataPoints; i++) {
                CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] objectAtIndex:i] floatValue];
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
            
            
            CAShapeLayer *layer = [self layerWithPath:path withFillColor:[UIColor clearColor] withStrokeColor:stroke withLineWidth:self.lineWidth];
            [self.layer addSublayer:layer];
            
            if ([self.dataSource respondsToSelector:@selector(animateDurationForDataPointsInSet:)]) {
                CABasicAnimation *animation = [self animateLineWithLayer:layer animationDuration:[self.dataSource animateDurationForDataPointsInSet:j]];
                [layer addAnimation:animation forKey:animation.keyPath];
            } else {
                if (self.lineAnimationDuration > 0.0f) {
                    CABasicAnimation *animation = [self animateLineWithLayer:layer animationDuration:self.lineAnimationDuration];
                    [layer addAnimation:animation forKey:animation.keyPath];
                }
            }
            
            CGPathRelease(path);
        }
    }
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
    
    if (self.showLineCurvature) {

        for (int j = 0; j < [self.dataSource numberOfDatasets]; j++) {
            
            CGGradientRef gradient = [JSScatterPlot generateGradientWithColors:[self.dataSource gradientColorsForPlotSet:j]];
            
            CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] objectAtIndex:0] floatValue];
            CGFloat x = rect.origin.x;
            CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
            CGContextBeginPath(ctx);
            NSInteger numberOfPoints = [[self.dataSource datasetAtIndex:j] count];
            
            CGPoint p1 = CGPointMake(x, y);

            CGContextMoveToPoint(ctx, rect.origin.x, startPoint.y);
            CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y + y);
            
            
            float divider = CGRectGetWidth(rect) / (CGFloat)(numberOfPoints - 1);
            
            for (int i = 0; i < numberOfPoints; i++) {
                CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] objectAtIndex:i] floatValue];
                CGFloat x = rect.origin.x + i * divider;
                CGFloat y = rect.origin.y + (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
                
                CGPoint p2 = CGPointMake(x, y);
                CGPoint midPoint = [JSScatterPlot midPointFromP1:p1 toP2:p2];
                CGContextAddQuadCurveToPoint(ctx,
                                             [JSScatterPlot controlPointForPoints:midPoint p2:p1].x,
                                             [JSScatterPlot controlPointForPoints:midPoint p2:p1].y,
                                             midPoint.x, midPoint.y);
                CGContextAddQuadCurveToPoint(ctx,
                                             [JSScatterPlot controlPointForPoints:midPoint p2:p2].x,
                                             [JSScatterPlot controlPointForPoints:midPoint p2:p2].y,
                                             p2.x, p2.y);
                p1 = p2;
            }
            
            CGContextAddLineToPoint(ctx, rect.origin.x + (divider * (numberOfPoints - 1)), startPoint.y);
            CGContextClosePath(ctx);
            CGContextSaveGState(ctx);
            CGContextClip(ctx);
            
            CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
            CGContextRestoreGState(ctx);
            CGGradientRelease(gradient);
        }
        
        return;
    }
    
    for (int j = 0; j < [self.dataSource numberOfDatasets]; j++) {
    
        CGGradientRef gradient = [JSScatterPlot generateGradientWithColors:[self.dataSource gradientColorsForPlotSet:j]];
        
        CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] objectAtIndex:0] floatValue];
        float y = (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
        CGContextBeginPath(ctx);
        
        CGContextMoveToPoint(ctx, rect.origin.x, startPoint.y);
        CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y + y);
        
        NSInteger numberOfPoints = [[self.dataSource datasetAtIndex:j] count];
        
        float divider = CGRectGetWidth(rect) / (CGFloat)(numberOfPoints - 1);

        for (int i = 0; i < numberOfPoints; i++) {
            CGFloat dataPoint = [[[self.dataSource datasetAtIndex:j] objectAtIndex:i] floatValue];
            float y = (rect.size.height - maxGraphHeight * (dataPoint / maxPoint));
            CGContextAddLineToPoint(ctx, rect.origin.x + (divider * (i)), rect.origin.y + y);
        }
        
        CGContextAddLineToPoint(ctx, rect.origin.x + (divider * (numberOfPoints - 1)), startPoint.y);
        CGContextClosePath(ctx);
        CGContextSaveGState(ctx);
        CGContextClip(ctx);
        
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(ctx);
        CGGradientRelease(gradient);
    }
}

- (void)animationDidStart:(CAAnimation *)anim
{
    self->animationInProgress = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self->animationInProgress = NO;
    if ([[anim valueForKey:@"id"] isEqualToString:@"pointAnimation"]) {
        [self drawConnectingLinesWithRect:[self generateInnerGraphBoundingRect] context:UIGraphicsGetCurrentContext()];
    }
}

- (CAShapeLayer *)layerWithPath:(CGPathRef)path withFillColor:(UIColor *)fill withStrokeColor:(UIColor *)stroke withLineWidth:(CGFloat)width
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setPath:path];
    [layer setFillColor:[fill CGColor]];
    [layer setStrokeColor:[stroke CGColor]];
    [layer setLineCap:kCALineCapRound];
    [layer setLineJoin:kCALineJoinRound];
    [layer setLineWidth:width];
    return layer;
}

- (CABasicAnimation *)animateDataPointWithLayer:(CAShapeLayer *)layer animationDuration:(CFTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setDelegate:self];
    [animation setDuration:duration];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue   = [NSNumber numberWithFloat:1.0f];
    animation.repeatCount = 0;
    animation.autoreverses = NO;
    [animation setValue:@"pointAnimation" forKey:@"id"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CABasicAnimation *)animateLineWithLayer:(CAShapeLayer *)layer animationDuration:(CFTimeInterval)duration
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [pathAnimation setDelegate:self];
    pathAnimation.duration = duration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.repeatCount = 0;
    pathAnimation.autoreverses = NO;
    [pathAnimation setValue:@"pathAnimation" forKey:@"id"];
    return pathAnimation;
}

@end
