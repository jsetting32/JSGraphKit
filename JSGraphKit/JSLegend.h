//
//  JSLegend.h
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSLegend : UIView

- (instancetype)initWithLegendStrings:(NSArray *)legendStrings withColors:(NSArray *)colors;

///--------------------------------------
/// @name View Methods
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

@end
