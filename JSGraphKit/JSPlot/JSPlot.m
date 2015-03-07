//
//  JSPlot.m
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import "JSPlot.h"

@interface JSPlot()
@end

@implementation JSPlot

- (instancetype)initWithFrame:(CGRect)frame withTheme:(JSGraphTheme)theme
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0f]];
    
    self.showHorizontalAxisLabels = NO;
    self.showVerticalAxisLabels = NO;
    self.axisLabelFont = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:8.0f];
    self.axisLabelTextColor = [UIColor blackColor];
    self.axisVerticalLabelAngle = 0.0f;
    self.axisVerticalLabelOffset = CGPointMake(0, 10);
    self.axisHorizontalLabelAngle = 0.0f;
    self.axisHorizontalLabelOffset = CGPointMake(10, 0);
    self.showHorizontalAxis = NO;
    self.showVerticalAxis = NO;
    self.axisLineColor = [UIColor blackColor];
    self.axisLineWidth = 0.25;
    self.boxLineWidth = 1.0f;
    self.boxLineColor = [UIColor blackColor];
    self.boxFillColor = [UIColor whiteColor];
    
    self.overallGraphPadding = 0.0f;
    self.topGraphPadding = 0.0f;
    self.bottomGraphPadding = 0.0f;
    self.leftGraphPadding = 0.0f;
    self.rightGraphPadding = 0.0f;
    
    return self;
}

- (void)setTheme:(JSGraphTheme)theme
{
    [super setTheme:theme];
    
    switch (theme) {
        case JSGraphThemeForest:
            self.boxLineColor = [UIColor colorWithRed:30.0f/255.0f green:255.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
            self.boxFillColor = [UIColor colorWithRed:139.0f/255.0f green:200.0f/255.0f blue:173.0f/255.0f alpha:1.0f];
            self.axisLabelTextColor = [UIColor blackColor];
            self.axisLineColor = [UIColor blackColor];
            break;
        case JSGraphThemeDark:
            self.boxLineColor = [UIColor blackColor];
            self.boxFillColor = [UIColor lightGrayColor];
            self.axisLabelTextColor = [UIColor blackColor];
            self.axisLineColor = [UIColor blackColor];
            break;
        case JSGraphThemeLight:
            self.boxLineColor = [UIColor whiteColor];
            self.boxFillColor = [UIColor lightGrayColor];
            self.axisLabelTextColor = [UIColor blackColor];
            self.axisLineColor = [UIColor blackColor];
            break;
        case JSGraphThemeSky:
            self.boxLineColor = [UIColor colorWithRed:30.0f/255.0f green:140.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            self.boxFillColor = [UIColor colorWithRed:194.0f/255.0f green:223.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            self.axisLabelTextColor = [UIColor blackColor];
            self.axisLineColor = [UIColor blackColor];
            break;
        default:
            self.boxLineColor = [UIColor blackColor];
            self.boxFillColor = [UIColor lightGrayColor];
            self.axisLabelTextColor = [UIColor blackColor];
            self.axisLineColor = [UIColor blackColor];
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
 
    [self drawGraphBoundingBoxWithContext:ctx];
    [self drawVerticalAxis:self.boundingRect context:ctx];
    [self drawHorizontalAxis:self.boundingRect context:ctx];
}

- (void)drawHorizontalAxis:(CGRect)rect context:(CGContextRef)ctx
{
    if (!self.showHorizontalAxis) return;
        
    CGContextSetLineWidth(ctx, self.axisLineWidth);
    
    CGFloat max = [self getMaxValueFromDataPoints];
    
    NSInteger numberOfLines = [self.dataSource numberOfHorizontalAxes];
    
    CGFloat point = rect.size.height / numberOfLines;
    for (int i = 0; i < numberOfLines + 1; i++) {
        CGContextBeginPath(ctx);
        CGContextSetStrokeColorWithColor(ctx, [self.axisLineColor CGColor]);
        CGContextMoveToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + point * i);
        CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y + point * i);
        CGContextStrokePath(ctx);
        
        NSString *theText = [NSString stringWithFormat:@"%i", (int)((max / numberOfLines) * (numberOfLines - i))];
        CGRect textRect = CGRectMake(rect.origin.x - 10, rect.origin.y + point * i, 15, 5);
        CGPoint p = CGPointMake(textRect.origin.x + -self.axisHorizontalLabelOffset.x, textRect.origin.y + self.axisHorizontalLabelOffset.y);
        [JSPlot drawWithBasePoint:p andAngle:self.axisHorizontalLabelAngle andFont:self.axisLabelFont andColor:self.axisLabelTextColor theText:theText];
    }
}

- (void)drawVerticalAxis:(CGRect)rect context:(CGContextRef)ctx
{
    if (!self.showVerticalAxis) return;
    
    if (![self.dataSource respondsToSelector:@selector(graphViewWithVerticalAxisPoints:)])
        NSAssert(NO, @"You need to pass in some values into the vertical axes datasource");
    
    NSAssert([self.dataSource graphViewWithVerticalAxisPoints:self], @"You need to pass in some values into the vertical axes datasource");
    
    CGContextSetLineWidth(ctx, self.axisLineWidth);
    
    NSArray * verticalLabels = [self.dataSource graphViewWithVerticalAxisPoints:self];
    CGFloat point = rect.size.width / ([verticalLabels count] + 1);
    for (int i = 1; i < [verticalLabels count] + 1; i++) {
        CGContextBeginPath(ctx);
        CGContextSetStrokeColorWithColor(ctx, [self.axisLineColor CGColor]);
        CGContextMoveToPoint(ctx, rect.origin.x + point * i, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(ctx, rect.origin.x + point * i, rect.origin.y);
        CGContextStrokePath(ctx);
        
        NSString *theText = [NSString stringWithFormat:@"%@", (id)[verticalLabels objectAtIndex:i - 1]];
        CGRect textRect = CGRectMake(rect.origin.x + point * i, rect.origin.y + rect.size.height + 10, 15, 5);
        CGPoint p = CGPointMake(textRect.origin.x + self.axisVerticalLabelOffset.x, textRect.origin.y + self.axisVerticalLabelOffset.y);
        [JSPlot drawWithBasePoint:p andAngle:self.axisVerticalLabelAngle andFont:self.axisLabelFont andColor:self.axisLabelTextColor theText:theText];
    }
}

- (void)drawGraphBoundingBoxWithContext:(CGContextRef)ctx
{
    CGContextBeginPath(ctx);
    
    CGFloat top = (self.overallPadding != 0.0f) ? self.overallPadding : self.topPadding;
    CGFloat bottom = [self bounds].size.height - ((self.overallPadding != 0.0f) ? self.overallPadding * 2 : self.bottomPadding * 2);
    CGFloat left = (self.overallPadding != 0.0f) ? self.overallPadding : self.leftPadding;
    CGFloat right = (self.overallPadding != 0.0f) ? (CGRectGetWidth(self.bounds) - self.overallPadding * 2) : (CGRectGetWidth(self.bounds) - self.rightPadding * 2);
    
    self.boundingRect = CGRectMake(left, top, right, bottom);
    CGContextSetLineWidth(ctx, self.boxLineWidth);
    CGContextSetFillColorWithColor(ctx, [self.boxFillColor CGColor]);
    
    if (self.graphCornerRadius > 0.0f) {
        CGFloat minx = CGRectGetMinX(self.boundingRect), midx = CGRectGetMidX(self.boundingRect), maxx = CGRectGetMaxX(self.boundingRect);
        CGFloat miny = CGRectGetMinY(self.boundingRect), midy = CGRectGetMidY(self.boundingRect), maxy = CGRectGetMaxY(self.boundingRect);
        
        CGContextMoveToPoint(ctx, minx, midy);
        CGContextAddArcToPoint(ctx, minx, miny, midx, miny, self.graphCornerRadius);
        CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, self.graphCornerRadius);
        CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, self.graphCornerRadius);
        CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, self.graphCornerRadius);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        return;
    }
    
    CGContextFillRect(ctx, self.boundingRect);
    CGContextSetStrokeColorWithColor(ctx, [self.boxLineColor CGColor]);
    CGContextStrokeRect(ctx, self.boundingRect);
}

+ (void)drawWithBasePoint:(CGPoint)basePoint andAngle:(CGFloat)angle andFont:(UIFont *)font andColor:(UIColor *)color theText:(NSString *)theText
{
    CGSize textSize = [theText sizeWithAttributes:@{NSFontAttributeName:font}];
    
    CGContextRef context    = UIGraphicsGetCurrentContext();
    CGAffineTransform t     = CGAffineTransformMakeTranslation(basePoint.x, basePoint.y);
    CGAffineTransform r     = CGAffineTransformMakeRotation(angle);
    
    CGContextConcatCTM(context, t);
    CGContextConcatCTM(context, r);
    
    [theText drawAtPoint:CGPointMake(-textSize.width / 2, -textSize.height / 2)
          withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    
    CGContextConcatCTM(context, CGAffineTransformInvert(r));
    CGContextConcatCTM(context, CGAffineTransformInvert(t));
}

- (void)iteratorForDataPointsWithRect:(CGRect)rect
                                block:(void (^)(int maxGraphHeight, CGFloat maxPoint, float divider, CGFloat dataPoint, int i))completionBlock {
    CGFloat maxPoint = [self getMaxValueFromDataPoints];
    for (int j = 0; j < [self.dataSource numberOfDataSets]; j++) {
        for (int i = 0; i < [self.dataSource numberOfDataPointsForSet:j]; i++) {
            float divider = CGRectGetWidth(rect) / [self.dataSource numberOfDataPointsForSet:i];
            CGFloat dataPoint = [[self.dataSource graphViewDataPointsAtIndex:i forSetNumber:j] floatValue];
            completionBlock(rect.size.height, maxPoint, divider, dataPoint, i);
        }
    }
}

- (CGFloat)getMaxValueFromDataPoints
{
    NSNumber *max;
    for (int i = 0; i < [self.dataSource numberOfDataSets]; i++) {
        for (int j = 0; j < [self.dataSource numberOfDataPointsForSet:i]; j++) {
            if ([max floatValue] == NSNotFound) {
                max = [self.dataSource graphViewDataPointsAtIndex:j forSetNumber:i];
            } else if(max < [self.dataSource graphViewDataPointsAtIndex:j forSetNumber:i]) {
                max = [self.dataSource graphViewDataPointsAtIndex:j forSetNumber:i];
            }
        }
    }
    
    return [max floatValue];
}

+ (CAShapeLayer *)layerWithPath:(CGPathRef)path withFillColor:(UIColor *)fill withStrokeColor:(UIColor *)stroke withLineWidth:(CGFloat)width
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

+ (void)animateWithLayer:(CAShapeLayer *)layer animationDuration:(CFTimeInterval)duration
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = duration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.repeatCount = 0;
    pathAnimation.autoreverses = NO;
    [layer addAnimation:pathAnimation forKey:@"strokeEnd"];
}


@end
