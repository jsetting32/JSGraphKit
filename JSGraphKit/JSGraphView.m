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
    [self setTheme:self.graphTheme];
    [self addSubview:self.legend];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTheme:(JSGraphTheme)theme
{
    self.graphTheme = theme;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame withTheme:(JSGraphTheme)theme withLegendStrings:(NSArray *)legendStrings withColors:(NSArray *)colors
{
    self.legend = [[JSLegend alloc] initWithLegendStrings:legendStrings withColors:colors];
    [self.legend setBackgroundColor:[UIColor whiteColor]];
    [self.legend setFrame:CGRectMake(0, 0, 30, 30)];
    self.graphTheme = theme;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame withLegendStrings:(NSArray *)legendStrings withColors:(NSArray *)colors
{
    self.legend = [[JSLegend alloc] initWithLegendStrings:legendStrings withColors:colors];
    [self.legend setBackgroundColor:[UIColor whiteColor]];
    [self.legend setFrame:CGRectMake(0, 0, 30, 30)];
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
}

@end
