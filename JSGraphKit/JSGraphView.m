//
//  JSGraphView.m
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import "JSGraphView.h"
#import "JSPlot.h"

/*
@interface JSGraphView()
@property (nonatomic, assign) JSGraphType graphType;
@property (nonatomic, assign) JSGraphTheme graphTheme;
@property (nonatomic, strong) JSPlot *plotView;
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
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame theme:(JSGraphTheme)theme
{
    self.graphTheme = theme;
    self.graphType = JSGraphTypeScatterPlot;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame type:(JSGraphType)type
{
    self.graphTheme = JSGraphThemeDefault;
    self.graphType = type;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame type:(JSGraphType)type theme:(JSGraphTheme)theme
{
    self.graphType = type;
    self.graphTheme = theme;
    return [self initWithFrame:frame];
}

- (void)setTheme:(JSGraphTheme)theme { [self.plotView setTheme:theme]; }

- (void)layoutSubviews
{
    [self layoutSubviews];
    
    
    self.plotView = [[JSPlot alloc] initWithFrame:self.frame type:self.graphType theme:self.graphTheme];
    [self addSubview:self.plotView];
}

@end
*/
