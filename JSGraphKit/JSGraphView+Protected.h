//
//  JSGraphView+Protected.h
//  Example
//
//  Created by John Setting on 3/9/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import "JSGraphView.h"

@interface JSGraphView (Protected)
+ (void)drawWithBasePoint:(CGPoint)basePoint andAngle:(CGFloat)angle andFont:(UIFont *)font andColor:(UIColor *)color theText:(NSString *)theText;
+ (CGGradientRef)generateGradientWithColors:(NSArray *)colors;
+ (CGPoint)midPointFromP1:(CGPoint)p1 toP2:(CGPoint)p2;
+ (CGPoint)controlPointForPoints:(CGPoint)p1 p2:(CGPoint)p2;
@end
