//
//  JSLegend.m
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import "JSLegend.h"
#import "JSPlot.h"

@interface JSLegend()
@property (nonatomic, strong) NSArray *legendStrings;
@property (nonatomic, strong) NSArray *colors;
@end

@implementation JSLegend

- (instancetype)initWithLegendStrings:(NSArray *)legendStrings withColors:(NSArray *)colors
{
    if (!(self = [super init])) return nil;
    self.legendStrings = legendStrings;
    self.colors = colors;
    self.legendLabelFont = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:8.0f];
    self.legendLabelTextColor = [UIColor blackColor];
    self.legendLabelAngle = 0.0f;
    self.legendLabelOffset = CGPointMake(0, 0);
    self.legendColorOffset = CGPointMake(0, 0);
    self.legendColorBorderColor = [UIColor blackColor];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < [self.legendStrings count]; i++) {
        
        UIColor *color = [self.colors objectAtIndex:i];
        NSString *text = [self.legendStrings objectAtIndex:i];
        
        CGRect colorViewRect = CGRectMake(self.legendColorOffset.x, i * 20 + self.legendColorOffset.y, 20, 20);
        CGContextBeginPath(ctx);
        CGContextSetStrokeColorWithColor(ctx, [self.legendColorBorderColor CGColor]);
        CGContextSetFillColorWithColor(ctx, [color CGColor]);
        CGContextStrokeRect(ctx, colorViewRect);
        CGContextFillRect(ctx, colorViewRect);
        
        CGRect textRect = CGRectMake(20, i * 20, self.frame.size.width - 20, 20);
        CGPoint p = CGPointMake(textRect.origin.x + self.legendLabelOffset.x, textRect.origin.y + self.legendLabelOffset.y);
        [JSPlot drawWithBasePoint:p andAngle:self.legendLabelAngle andFont:self.legendLabelFont andColor:self.legendLabelTextColor theText:text];
    }
}


@end
