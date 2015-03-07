//
//  JSLegend.h
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSLegend : UIView
- (instancetype)initWithFrame:(CGRect)frame withLegendStrings:(NSArray *)legendStrings withColors:(NSArray *)colors;
@end
