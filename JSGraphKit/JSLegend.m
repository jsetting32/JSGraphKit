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
    [self.layer setMasksToBounds:YES];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (([self.legendStrings count] == 0) || ([self.colors count] == 0)) {
        NSAssert(NO, @"You need to specify your colors and strings for the legend, where both need to have the array size");
    }
    
    for (int i = 0; i < [self.legendStrings count]; i++) {
        
        UIColor *color = [self.colors objectAtIndex:i];
        NSString *text = [self.legendStrings objectAtIndex:i];
        
        CGRect colorViewRect = CGRectMake(self.legendColorOffset.x,
                                          i * ((float)self.frame.size.width / [self.legendStrings count]) + self.legendColorOffset.y,
                                          (float)self.frame.size.width / [self.legendStrings count],
                                          (float)self.frame.size.width / [self.legendStrings count]);
        CGFloat colorRectEnd = colorViewRect.origin.x + colorViewRect.size.width;
        CGContextBeginPath(ctx);
        CGContextSetStrokeColorWithColor(ctx, [self.legendColorBorderColor CGColor]);
        CGContextSetFillColorWithColor(ctx, [color CGColor]);
        CGContextStrokeRect(ctx, colorViewRect);
        CGContextFillRect(ctx, colorViewRect);
        
        CGRect textRect = CGRectMake(self.legendLabelOffset.x + colorRectEnd,
                                     self.legendLabelOffset.y + i * ((float)self.frame.size.width / [self.legendStrings count]), self.frame.size.width - colorRectEnd, ((float)self.frame.size.width / [self.legendStrings count]));
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:textRect];
        [textLabel setText:text];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setTextColor:self.legendLabelTextColor];
        [textLabel setAdjustsFontSizeToFitWidth:YES];
        [textLabel setFont:self.legendLabelFont];
        [textLabel setTransform:CGAffineTransformMakeRotation(self.legendLabelAngle)];
        [self addSubview:textLabel];
    }
}

@end
