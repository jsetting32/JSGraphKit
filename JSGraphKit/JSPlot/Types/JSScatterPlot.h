//
//  JSGraphView.h
//
//  Created by John Setting on 11/19/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JSPlot.h"

@interface JSScatterPlot : JSPlot

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
 @abstract Sets the line graph's data point label offset from the data point (defaults to (10,-10) )
 */
@property (nonatomic, assign) CGPoint pointLabelOffset;

/*!
 @abstract Sets the line graph's data point circle radius (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat pointRadius;

/*!
 @abstract Sets the line graph's data points outer circle color (defaults to black)
 */
@property (nonatomic, retain) UIColor * outerPointColor;

/*!
 @abstract Sets the line graph's data point inner circle color (defaults to white)
 */
@property (nonatomic, retain) UIColor * innerPointColor;

/*!
 @abstract Sets the data point graph animation duration (defaults to 0.0f - no animation)
 This will animate all data points within the graph simultaneously
 */
@property (nonatomic, assign) CGFloat dataPointAnimationDuration;

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
 @abstract Sets the line graph to show curves rather than straight lines (defaults to NO)
 NOTE: Not ready yet... Some bugs
 */
@property (nonatomic, assign) BOOL showLineCurvature;

/*!
 @abstract Sets the line graph animation duration (defaults to 0.0f - no animation)
 This will animate all graphs from the first point (far left) to the last point (far right)
 */
@property (nonatomic, assign) CGFloat lineAnimationDuration;


///--------------------------------------
/// @name View Attributes
///--------------------------------------
/*!
 @abstract Sets the graph view to show a gradient under the line plot (defaults to NO)
 */
@property (nonatomic, assign) BOOL showGradientUnderLinePlot;
@end
