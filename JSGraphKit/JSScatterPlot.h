//
//  JSGraphView.h
//
//  Created by John Setting on 11/19/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JSPlot.h"

@interface JSScatterPlot : JSPlot

/*!
 @abstract Set the theme
 */
- (void)setTheme:(JSGraphTheme)theme;

///--------------------------------------
/// @name Data Point Attributes
///--------------------------------------

/*!
 @abstract Shows the lines graph's data point labels (defaults to YES)
 */
@property (nonatomic, assign) BOOL showPointLabels;

/*!
 @abstract Sets the line graph's data point label font (defaults to AppleSDGothicNeo-Light - 12.0f)
 */
@property (nonatomic, strong) UIFont * pointLabelFont;

/*!
 @abstract Sets the line graph's data point label text color (defaults to black)
 */
@property (nonatomic, retain) UIColor * pointLabelTextColor;

/*!
 @abstract Sets the line graph's data point label angle (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat pointLabelAngle;

/*!
 @abstract Sets the line graph's data point label offset from the data point (defaults to (10,0) )
 */
@property (nonatomic, assign) CGPoint pointLabelOffset;

/*!
 @abstract Sets the line graph's data point circle radius (defaults to 0.0f - no data point)
 */
@property (nonatomic, assign) CGFloat pointRadius;

/*!
 @abstract Sets the line graph's data points outer circle color (defaults to black)
 */
@property (nonatomic, retain) UIColor * outerPointColor;

/*!
 @abstract Sets the line graph's data point inner circle color (defaults to black)
 */
@property (nonatomic, retain) UIColor * innerPointColor;


///--------------------------------------
/// @name Line Plot Attributes
///--------------------------------------

/*!
 @abstract Sets the line graph's line width/height (defaults to black)
 */
@property (nonatomic, assign) CGFloat lineWidth;

/*!
 @abstract Sets the line graph's line width/height (defaults to black)
 */
@property (nonatomic, retain) UIColor * lineColor;

/*!
 @abstract Sets the line graph's line curvature (defaults to 5.0f)
 NOTE: Need to implement
 */
@property (nonatomic, assign) CGFloat lineCurveMagnitude;



///--------------------------------------
/// @name View Attributes
///--------------------------------------
/*!
 @abstract Sets the graph view to show a gradient under the line plot (defaults to NO)
 */
@property (nonatomic, assign) BOOL showGradientUnderLinePlot;

/*!
 @abstract Sets the gradient's layer color under the graph (defaults to blue then red)
 */
@property (nonatomic, strong) NSArray * gradientColors;
@end
