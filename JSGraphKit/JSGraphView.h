//
//  JSMainGraphView.h
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSGraphView;
/*
typedef enum {
    JSGraphTypeScatterPlot = 0,
    JSGraphTypeBarPlot = 1
} JSGraphType;


typedef enum {
    JSGraphThemeDefault = 0,
    JSGraphThemeForest = 1,
    JSGraphThemeDark,
    JSGraphThemeLight,
    JSGraphThemeSky
} JSGraphTheme;

*/
@protocol JSGraphDelegate <NSObject>

@optional
/*!
 * @abstract Informs the delegate that the current data point was tapped.
 * It then returns the index of the passed in datasource array for the delegate.
 * Makes it easy to access the objects passed in case the data points were parsed from some object
 */
- (void)JSGraphView:(JSGraphView *)graphView didTapDataPointAtIndex:(NSInteger)index;
@end


@protocol JSGraphDataSource <NSObject>

@optional
/*!
 * @abstract Creates the horizontal axis for the graph view
 */
- (NSArray *)graphViewWithHorizontalAxisPoints:(JSGraphView *)graphView;

/*!
 * @abstract Creates the vertical axis for the graph view
 */
- (NSArray *)graphViewWithVerticalAxisPoints:(JSGraphView *)graphView;

@required
/*!
 * @abstract The data points of the graph
 * Must pass in NSNumber objects within the array of data points you supply the graph
 */
- (NSArray *)graphViewDataPoints:(JSGraphView *)graphView;
@end

@interface JSGraphView : UIView

@property (nonatomic, weak)     id<JSGraphDelegate>     delegate;
@property (nonatomic, assign)   id<JSGraphDataSource>   dataSource;

///--------------------------------------
/// @name View Methods
///--------------------------------------

/*!
 @abstract Set the theme
 */
//- (void)setTheme:(JSGraphTheme)theme;


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
