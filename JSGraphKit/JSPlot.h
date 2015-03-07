//
//  JSPlot.h
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JSPlotDataSource;
@protocol JSPlotDelegate;

typedef enum {
    JSGraphThemeDefault = 0,
    JSGraphThemeForest = 1,
    JSGraphThemeDark,
    JSGraphThemeLight,
    JSGraphThemeSky
} JSGraphTheme;

@interface JSPlot : UIView

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

@property (nonatomic, weak)   id <JSPlotDelegate>   delegate;
@property (nonatomic, assign) id <JSPlotDataSource> dataSource;

///--------------------------------------
/// @name View Methods
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
 @abstract Sets the overall (top, left, right, bottom) paddings of the inner graph view (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat overallPadding;

/*!
 @abstract Sets the overall (top, left, right, bottom) paddings of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat overallGraphPadding;

/*!
 @abstract Sets the top padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat topGraphPadding;

/*!
 @abstract Sets the top padding of the inner graph view (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat topPadding;

/*!
 @abstract Sets the bottom padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat bottomGraphPadding;

/*!
 @abstract Sets the bottom padding of the inner graph view (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat bottomPadding;

/*!
 @abstract Sets the left padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat leftGraphPadding;

/*!
 @abstract Sets the left padding of the inner graph view (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat leftPadding;

/*!
 @abstract Sets the right padding of the view (defaults to 1.0f)
 */
@property (nonatomic, assign) CGFloat rightGraphPadding;

/*!
 @abstract Sets the right padding of the inner graph view (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat rightPadding;

/*!
 @abstract Sets the corner radius of the inner graphs bounding box (defaults to 0.0f)
 */
@property (nonatomic, assign) CGFloat graphCornerRadius;

+ (void)drawWithBasePoint:(CGPoint)basePoint andAngle:(CGFloat)angle andFont:(UIFont *)font andColor:(UIColor *)color theText:(NSString *)theText;
- (void)iteratorForDataPointsWithRect:(CGRect)rect
                                block:(void (^)(int maxGraphHeight, CGFloat maxPoint, float divider, CGFloat dataPoint, int i))completionBlock;
- (CGFloat)getMaxValueFromDataPoints;
@end

@protocol JSPlotDelegate <NSObject>

@optional
/*!
 * @abstract Informs the delegate that the current data point was tapped.
 * It then returns the index of the passed in datasource array for the delegate.
 * Makes it easy to access the objects passed in case the data points were parsed from some object
 */
- (void)JSPlot:(JSPlot *)graphView didTapDataPointAtIndex:(NSInteger)index inSet:(NSInteger)setNumber;

/*!
 * @abstract Informs the delegate that the current data point was tapped.
 * It then returns the index of the passed in datasource array for the delegate.
 * Makes it easy to access the objects passed in case the data points were parsed from some object
 */
- (void)JSPlot:(JSPlot *)graphView didTapBarPlotAtIndex:(NSInteger)index inSet:(NSInteger)setNumber;
@end

@protocol JSPlotDataSource <NSObject>

@optional

/*!
 * @abstract Creates x number of axes evenly spread through the graph whose values are based on the data set
 */
- (NSInteger)numberOfHorizontalAxes;

/*!
 * @abstract Creates the horizontal axis for the graph view
 */
- (NSArray *)graphViewWithHorizontalAxisPoints:(JSPlot *)graphView;

/*!
 * @abstract Creates the vertical axis for the graph view
 */
- (NSArray *)graphViewWithVerticalAxisPoints:(JSPlot *)graphView;

- (NSArray *)gradientColorsForPlotSet:(NSInteger)setNumber;
- (UIColor *)colorForPlotSet:(NSInteger)setNumber;

- (NSArray *)graphViewWithLegendDataTypes;

- (CFTimeInterval)animateDurationForDataPoints;

@required

- (NSInteger)numberOfDataSets;

- (NSInteger)numberOfDataPointsForSet:(NSInteger)setNumber;
/*!
 * @abstract The data points of the graph
 * Must pass in NSNumber object to be inputted into the graph
 */
- (NSNumber *)graphViewDataPointsAtIndex:(NSInteger)index forSetNumber:(NSInteger)setNumber;
@end
