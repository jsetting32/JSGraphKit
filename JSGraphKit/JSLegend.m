//
//  JSLegend.m
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import "JSLegend.h"

@interface JSLegend()
@property (nonatomic, strong) UIView *typeColor;
@property (nonatomic, strong) UILabel *typeString;
@end

@implementation JSLegend

- (instancetype)initWithFrame:(CGRect)frame withLegendStrings:(NSArray *)legendStrings withColors:(NSArray *)colors
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    for (int i = 0; i < [legendStrings count]; i++) {
        UIColor *color = [colors objectAtIndex:i];
        NSString *text = [legendStrings objectAtIndex:i];
        
        UIView *type = [[UIView alloc] initWithFrame:CGRectMake(0, i * 20, 20, 20)];
        [type setBackgroundColor:color];
        [self addSubview:type];
        
        UILabel *string = [[UILabel alloc] initWithFrame:CGRectMake(20, i * 20, self.frame.size.width - 20, 20)];
        [string setText:text];
        [self addSubview:string];
    }
    
    return self;
}

@end
