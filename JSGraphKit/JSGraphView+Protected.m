//
//  JSGraphView+Protected.m
//  Example
//
//  Created by John Setting on 3/9/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import "JSGraphView+Protected.h"

@implementation JSGraphView(Protected)

+ (void)drawWithBasePoint:(CGPoint)basePoint andAngle:(CGFloat)angle andFont:(UIFont *)font andColor:(UIColor *)color theText:(NSString *)theText
{
    CGSize textSize = [theText sizeWithAttributes:@{NSFontAttributeName:font}];
    
    CGContextRef context    = UIGraphicsGetCurrentContext();
    CGAffineTransform t     = CGAffineTransformMakeTranslation(basePoint.x, basePoint.y);
    CGAffineTransform r     = CGAffineTransformMakeRotation(-angle * M_PI/180.0);
    
    CGContextConcatCTM(context, t);
    CGContextConcatCTM(context, r);
    
    [theText drawAtPoint:CGPointMake(-textSize.width / 2, -textSize.height / 2)
          withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    
    CGContextConcatCTM(context, CGAffineTransformInvert(r));
    CGContextConcatCTM(context, CGAffineTransformInvert(t));
}

+ (CGGradientRef)generateGradientWithColors:(NSArray *)colors
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
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
    CGColorSpaceRelease(colorspace);
    return gradient;
}

+ (CGPoint)midPointFromP1:(CGPoint)p1 toP2:(CGPoint)p2
{
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

+ (CGPoint)controlPointForPoints:(CGPoint)p1 p2:(CGPoint)p2 {
    CGPoint controlPoint = [JSGraphView midPointFromP1:p1 toP2:p2];
    CGFloat diffY = abs(p2.y - controlPoint.y);
    if (p1.y < p2.y)
        controlPoint.y += diffY;
    else if (p1.y > p2.y)
        controlPoint.y -= diffY;
    return controlPoint;
}

@end
