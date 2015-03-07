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
 * @abstract Creates the horizontal axis for the graph view
 */
- (NSArray *)graphViewWithHorizontalAxisPoints:(JSGraphView *)graphView;

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
- (CFTimeInterval)animateDurationForDataPoints;

@required

/*!
 * @abstract The number of data sets
 */
- (NSInteger)numberOfDataSets;

/*!
 * @abstract The number of data points for a specified data set
 */
- (NSInteger)numberOfDataPointsForSet:(NSInteger)setNumber;
/*!
 * @abstract The data points of the graph
 * Must pass in NSNumber object to be inputted into the graph
 */
- (NSNumber *)graphViewDataPointsAtIndex:(NSInteger)index forSetNumber:(NSInteger)setNumber;
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
- (instancetype)initWithFrame:(CGRect)frame withTheme:(JSGraphTheme)theme withLegendStrings:(NSArray *)legendStrings withColors:(NSArray *)colors;
- (instancetype)initWithFrame:(CGRect)frame withLegendStrings:(NSArray *)legendStrings withColors:(NSArray *)colors;

/*!
 @abstract Set the theme
 */
- (void)setTheme:(JSGraphTheme)theme;

///--------------------------------------
/// @name View Methods
///--------------------------------------

/*!
 @abstract Shows the legend of the data input (defaults to YES)
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

@end
