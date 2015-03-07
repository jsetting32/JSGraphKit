//
//  JSBarPlot.h
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSGraphView.h"
#import "JSPlot.h"

@interface JSBarPlot : JSPlot

///--------------------------------------
/// @name Bar Plot Attributes
///--------------------------------------

/*!
 @abstract Sets the line graph's bar width (defaults to 20.0f)
 */
@property (nonatomic, assign) CGFloat barWidth;

/*!
 @abstract Sets the bar graph's bar color (defaults to white)
 */
@property (nonatomic, retain) UIColor * barColor;

/*!
 @abstract Sets the bar graph's bar outline color (defaults to black)
 */
@property (nonatomic, retain) UIColor * barOutlineColor;

/*!
 @abstract Automatically adjusts bar's widths according to the width of the graph (defaults to YES)
 (e.g if the graph is 300px wide, and 3 data points are passed in, the bars will be (300/3) px wide)
 */
@property (nonatomic, assign) BOOL automaticallyAdjustBars;

/*!
 @abstract Sets the graph view to show a gradient for the bar plots (defaults to NO)
 */
@property (nonatomic, assign) BOOL showBarGradientColors;

/*!
 @abstract Sets the gradient's layer color under the bar plots (defaults to blue then red)
 */
@property (nonatomic, strong) NSArray *barGradientColors;
@end
