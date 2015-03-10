//
//  JSMainGraphView.h
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSGraphView;

typedef enum {
    JSGraphThemeDefault = 0,
    JSGraphThemeForest = 1,
    JSGraphThemeDark,
    JSGraphThemeLight,
    JSGraphThemeSky
} JSGraphTheme;

@protocol JSGraphViewDelegate <NSObject>

@optional
/*!
 * @abstract Informs the delegate that the current data point was tapped.
 * It then returns the index of the passed in datasource array to the delegate.
 * Makes it easy to access the objects passed in case the data points were parsed from some object
 */
- (void)JSGraphView:(JSGraphView *)graphView didTapDataPointAtIndex:(NSInteger)index inSet:(NSInteger)setNumber;
@end

@protocol JSGraphViewDataSource <NSObject>

@optional

/*!
 * @abstract Creates x number of axes evenly spread through the graph whose values are based on the data set
 */
- (NSInteger)numberOfHorizontalAxes;

/*!
 * @abstract Creates the vertical axis for the graph view
 */
- (NSArray *)graphViewWithVerticalAxisPoints:(JSGraphView *)graphView;

/*!
 * @abstract Creates the gradient within the bar views or line graphs for the specified set number
 */
- (NSArray *)gradientColorsForPlotSet:(NSInteger)setNumber;

/*!
 * @abstract Creates the color within the bar views or the line graph's line for the specified set number
 */
- (UIColor *)colorForPlotSet:(NSInteger)setNumber;

/*!
 * @abstract Creates the color of the data points in the scatter plot graphs for the specified set number
 * Should consist of two UIColor objects, the first will be the inner point color and the second will be the outer point color
 */
- (NSArray *)colorForLineGraphDataPointSet:(NSInteger)setNumber;

/*!
 * @abstract Creates the legend of the graph
 */
- (NSArray *)graphViewWithLegendDataTypes;

/*!
 * @abstract Creates the animation timer of the data points
 */
- (CFTimeInterval)animateDurationForDataPointsInSet:(NSInteger)setNumber;

@required

/*!
 * @abstract The number of data sets
 */
- (NSInteger)numberOfDataSets;

/*!
 * @abstract The data points of the graph
 * Must pass in NSNumber object to be inputted into the graph
 */
- (NSArray *)graphViewDataPointsForSetNumber:(NSInteger)setNumber;
@end


@interface JSGraphView : UIView

@property (nonatomic, weak)     id<JSGraphViewDelegate>     delegate;
@property (nonatomic, assign)   id<JSGraphViewDataSource>   dataSource;

@property (nonatomic, assign) CGRect boundingRect;

/*!
 * @abstract Initializes the graph view with the passed frame.
 * @params theme: The theme the graph will draw (defaults to JSGraphThemeDefault)
 */
- (instancetype)initWithFrame:(CGRect)frame withTheme:(JSGraphTheme)theme;

/*!
 @abstract Set the theme
 */
- (void)setTheme:(JSGraphTheme)theme;

///--------------------------------------
/// @name View Attributes
///--------------------------------------

/*!
 @abstract Sets the title of the vertical axes (defaults to nil)
 */
@property (nonatomic, strong) NSString *verticalAxesTitle;

/*!
 @abstract Sets the title of the horizontal axes (defaults to nil)
 */
@property (nonatomic, strong) NSString *horizontalAxesTitle;

/*!
 @abstract Sets the text color of the axes (defaults to black)
 */
@property (nonatomic, retain) UIColor *axesTextColor;

/*!
 @abstract Sets the axes title label font (defaults to AppleSDGothicNeo-Light - 8.0f)
 */
@property (nonatomic, assign) UIFont *axesTitleFont;

/*!
 @abstract Sets the horizontal axes padding/offset (defaults to (0,0))
 */
@property (nonatomic, assign) CGPoint horizontalAxesOffset;

/*!
 @abstract Sets the horizontal axes angle transform (defaults to 90.0f)
 */
@property (nonatomic, assign) CGFloat horizontalAxesAngle;

/*!
 @abstract Sets the vertical axes padding/offset (defaults to (0,0))
 */
@property (nonatomic, assign) CGPoint verticalAxesOffset;

/*!
 @abstract Sets the vertical axes angle transform (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat verticalAxesAngle;

/*!
 @abstract Shows the legend of the data input (defaults to NO)
 */
@property (nonatomic, assign) BOOL showLegendView;

/*!
 @abstract Sets the overall (top, left, right, bottom) paddings of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat overallPadding;

/*!
 @abstract Sets the top padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat topPadding;

/*!
 @abstract Sets the bottom padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat bottomPadding;

/*!
 @abstract Sets the left padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat leftPadding;

/*!
 @abstract Sets the right padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat rightPadding;

///--------------------------------------
/// @name Legend View Properties
///--------------------------------------

/*!
 @abstract Sets the graph's legend label font (defaults to AppleSDGothicNeo-Light - 8.0f)
 */
@property (nonatomic, retain) UIFont * legendLabelFont;

/*!
 @abstract Sets the graph's legend label text color (defaults to black)
 */
@property (nonatomic, retain) UIColor * legendLabelTextColor;

/*!
 @abstract Sets the graph's legend label angle (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat legendLabelAngle;

/*!
 @abstract Sets the graph's legend label offset (defaults to (0,0) )
 */
@property (nonatomic, assign) CGPoint legendLabelOffset;

/*!
 @abstract Sets the graph's legend color view offset (defaults to (0,0) )
 */
@property (nonatomic, assign) CGPoint legendColorOffset;

/*!
 @abstract Sets the graph's legend color view border color (defaults to black)
 */
@property (nonatomic, retain) UIColor * legendColorBorderColor;

/*!
 @abstract Sets the width and height of the legend view (defaults to {50,50})
 */
@property (nonatomic, assign) CGSize legendDimension;

/*!
 @abstract Sets the offset of the legend view (defaults to {0,0})
 */
@property (nonatomic, assign) CGPoint legendOffset;

/*!
 @abstract Sets the background color of the legend view (defaults to white)
 */
@property (nonatomic, retain) UIColor *legendBackgroundColor;

/*!
 @abstract Sets the legend corner radius (defaults to 0.0f - no rounding)
 */
@property (nonatomic, assign) CGFloat legendCornerRadius;

/*!
 @abstract Sets the legend border color (defaults to black)
 */
@property (nonatomic, retain) UIColor *legendBorderColor;

/*!
 @abstract Sets the legend border width (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat legendBorderWidth;

+ (void)drawWithBasePoint:(CGPoint)basePoint andAngle:(CGFloat)angle andFont:(UIFont *)font andColor:(UIColor *)color theText:(NSString *)theText;

@end
