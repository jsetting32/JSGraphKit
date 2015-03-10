//
//  JSPlot.h
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSGraphView.h"

@interface JSPlot : JSGraphView

///--------------------------------------
/// @name View Attributes
///--------------------------------------

/*!
 @abstract Shows the horizontal axis labels within the inner view (defaults to NO)
 */
@property (nonatomic, assign) BOOL showHorizontalAxisLabels;

/*!
 @abstract Shows the vertical axis labels within the inner view (defaults to NO)
 */
@property (nonatomic, assign) BOOL showVerticalAxisLabels;

/*!
 @abstract Sets the graph's axes label font (defaults to AppleSDGothicNeo-Light - 8.0f)
 */
@property (nonatomic, retain) UIFont * axisLabelFont;

/*!
 @abstract Sets the graph's axes label text color (defaults to black)
 */
@property (nonatomic, retain) UIColor * axisLabelTextColor;

/*!
 @abstract Sets the graph's horizontal axes label angle (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat axisHorizontalLabelAngle;

/*!
 @abstract Sets the graph's vertical axes label angle (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat axisVerticalLabelAngle;

/*!
 @abstract Sets the graph's horizontal axes offset from the data point (defaults to (10,0) )
 */
@property (nonatomic, assign) CGPoint axisHorizontalLabelOffset;

/*!
 @abstract Sets the graph's vertical axes offset from the data point (defaults to (0,10) )
 */
@property (nonatomic, assign) CGPoint axisVerticalLabelOffset;

/*!
 @abstract Shows the horizontal axes within the inner view (defaults to NO)
 */
@property (nonatomic, assign) BOOL showHorizontalAxis;

/*!
 @abstract Shows the vertical axes within the inner view (defaults to NO)
 */
@property (nonatomic, assign) BOOL showVerticalAxis;

/*!
 @abstract Sets the vertical and horizontal axes that lie within the graph (defaults to black)
 */
@property (nonatomic, retain) UIColor *axisLineColor;

/*!
 @abstract Sets the vertical and horizontal axes widths that lie within the graph (defaults to .25f)
 */
@property (nonatomic, assign) CGFloat axisLineWidth;

/*!
 @abstract Sets the bounding box line width of the inner graph view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat boxLineWidth;

/*!
 @abstract Sets the bounding box line color of the inner graph view (defaults to black)
 */
@property (nonatomic, retain) UIColor * boxLineColor;

/*!
 @abstract Sets the bounding box line color of the inner graph view (defaults to black)
 */
@property (nonatomic, retain) UIColor * boxFillColor;

/*!
 @abstract Sets the overall (top, left, right, bottom) paddings of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat overallGraphPadding;

/*!
 @abstract Sets the top padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat topGraphPadding;

/*!
 @abstract Sets the bottom padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat bottomGraphPadding;

/*!
 @abstract Sets the left padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat leftGraphPadding;

/*!
 @abstract Sets the right padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat rightGraphPadding;

/*!
 @abstract Sets the corner radius of the inner graphs bounding box (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat graphCornerRadius;

/*!
 @abstract Gets the max value from all data passed
 */
- (CGFloat)getMaxValueFromDataPoints;

- (CGRect)generateInnerGraphBoundingRect;
- (void)didTapDataPoint:(UIButton *)button;
- (void)createButtonWithFrame:(CGRect)frame dataPointIndex:(int)dataPointIndex setIndex:(int)setIndex;
@end
