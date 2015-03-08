//
//  JSGraphView.m
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import "JSGraphView.h"
#import "JSLegend.h"

@interface JSGraphView()
@property (nonatomic, assign) JSGraphTheme graphTheme;
@property (nonatomic, strong) JSLegend * legend;
@end

@implementation JSGraphView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    self.overallPadding = 0.0f;
    self.topPadding = 0.0f;
    self.bottomPadding = 0.0f;
    self.leftPadding = 0.0f;
    self.rightPadding = 0.0f;
    
    self.legendLabelFont = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:8.0f];
    self.legendLabelTextColor = [UIColor blackColor];
    self.legendLabelAngle = 0.0f;
    self.legendLabelOffset = CGPointMake(0, 0);
    self.legendColorOffset = CGPointMake(0, 0);
    self.legendColorBorderColor = [UIColor blackColor];
    self.legendDimension = CGSizeMake(50, 50);
    self.legendOffset = CGPointMake(0, 0);
    self.legendBackgroundColor = [UIColor whiteColor];
    self.legendCornerRadius = 0.0f;
    self.legendBorderColor = [UIColor blackColor];
    self.legendBorderWidth = 1.0f;
    
    [self setTheme:self.graphTheme];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTheme:(JSGraphTheme)theme
{
    self.graphTheme = theme;
    return [self initWithFrame:frame];
}

- (void)setTheme:(JSGraphTheme)theme
{
    switch (theme) {
        case JSGraphThemeDefault:
            self.backgroundColor = [UIColor lightGrayColor];
            break;
        case JSGraphThemeForest:
            self.backgroundColor = [UIColor greenColor];
            break;
        case JSGraphThemeDark:
            self.backgroundColor = [UIColor darkGrayColor];
            break;
        case JSGraphThemeLight:
            self.backgroundColor = [UIColor lightGrayColor];
            break;
        case JSGraphThemeSky:
            self.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.showLegendView) {
        NSMutableArray *colors = [NSMutableArray array];
        for (int i = 0; i < [self.dataSource numberOfDataSets]; i++) {
            NSAssert([self.dataSource colorForPlotSet:i], ([NSString stringWithFormat:@"You havent specified a color for dataset at index %i", i]));
            NSAssert([[self.dataSource graphViewWithLegendDataTypes] objectAtIndex:i], ([NSString stringWithFormat:@"You havent specified a type name for dataset at index %i", i]));
            [colors addObject:[self.dataSource colorForPlotSet:i]];
        }
        
        self.legend = [[JSLegend alloc] initWithLegendStrings:[self.dataSource graphViewWithLegendDataTypes] withColors:colors];
        [self.legend setBackgroundColor:self.legendBackgroundColor];
        
        self.legend.legendLabelFont = self.legendLabelFont;
        self.legend.legendLabelAngle = self.legendLabelAngle;
        self.legend.legendLabelOffset = self.legendLabelOffset;
        self.legend.legendLabelTextColor = self.legendLabelTextColor;
        self.legend.legendColorOffset = self.legendColorOffset;
        self.legend.legendColorBorderColor = self.legendColorBorderColor;
        
        [self.legend.layer setCornerRadius:self.legendCornerRadius];
        [self.legend.layer setMasksToBounds:YES];
        [self.legend.layer setBorderWidth:self.legendBorderWidth];
        [self.legend.layer setBorderColor:[self.legendBorderColor CGColor]];
        [self.legend setFrame:CGRectMake(self.legendOffset.x, self.legendOffset.y, self.legendDimension.width, self.legendDimension.height)];
        [self addSubview:self.legend];
    }
}

@end
