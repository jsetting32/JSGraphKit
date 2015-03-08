//
//  ViewController.m
//  Example
//
//  Created by John Setting on 3/5/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//

#import "ViewController.h"
#import "JSScatterPlot.h"
#import "JSBarPlot.h"

@interface ViewController () <JSGraphViewDataSource, JSGraphViewDelegate>
@property (nonatomic, strong) JSScatterPlot *scatterPlot;
@property (nonatomic, strong) JSBarPlot *barPlot;
@property (nonatomic, strong) UISegmentedControl *barPlotSegment;
@property (nonatomic, strong) UISegmentedControl *scatterPlotSegment;
@property (nonatomic, strong) NSArray *dataset1;
@property (nonatomic, strong) NSArray *dataset2;
@property (nonatomic, strong) NSArray *dataset3;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataset1 = @[@100, @200, @400, @500, @100, @60, @40, @200, @50, @20, @60, @100, @200];
    self.dataset2 = @[@21, @30, @440, @550, @110, @60, @400, @20, @450, @120, @20, @120, @20];
    self.dataset3 = @[@400, @500, @10, @210, @520, @400, @300, @120, @230, @500, @210, @240, @50];
    
    self.barPlotSegment = [[UISegmentedControl alloc] initWithItems:@[@"Default", @"Forest", @"Dark", @"Light", @"Sky"]];
    [self.barPlotSegment setFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, 20)];
    [self.barPlotSegment setSelectedSegmentIndex:0];
    [self.barPlotSegment addTarget:self action:@selector(didSelectSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.barPlotSegment];

    self.scatterPlotSegment = [[UISegmentedControl alloc] initWithItems:@[@"Default", @"Forest", @"Dark", @"Light", @"Sky"]];
    [self.scatterPlotSegment setFrame:CGRectMake(10, 350, self.view.frame.size.width - 20, 20)];
    [self.scatterPlotSegment setSelectedSegmentIndex:0];
    [self.scatterPlotSegment addTarget:self action:@selector(didSelectSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.scatterPlotSegment];

    /*
    self.scatterPlot = [[JSScatterPlot alloc] initWithFrame:self.view.frame];
    [self.scatterPlot setDataSource:self];
    [self.scatterPlot setDelegate:self];
    
    [self.scatterPlot setOverallPadding:40.0f];
    [self.scatterPlot setTheme:JSGraphThemeSky];
    
    [self.scatterPlot setShowHorizontalAxis:YES];
    */
    [self.view addSubview:self.barPlot];
    [self.view addSubview:self.scatterPlot];

    /*
    [self.scatterPlot setOverallPadding:40.0f];
    [self.scatterPlot setLeftGraphPadding:10.0f];
    [self.scatterPlot setRightGraphPadding:10.0f];
    [self.scatterPlot setPointRadius:5.0f];
    [self.scatterPlot setLineWidth:2.0f];
    [self.scatterPlot setBoxLineWidth:1.0f];
    [self.scatterPlot setShowPointLabels:YES];
    [self.scatterPlot setPointLabelAngle:0.0f];
    [self.scatterPlot setPointLabelOffset:CGPointMake(10, -10)];
    [self.scatterPlot setLineCurveMagnitude:0.0f];
    [self.scatterPlot setGraphCornerRadius:5.0f];
    [self.scatterPlot setShowGradientUnderLinePlot:YES];
    */
}

- (void)didSelectSegment:(UISegmentedControl *)control
{
    if (control == self.barPlotSegment) {
        switch ([control selectedSegmentIndex]) {
            case 0:
                [self.barPlot setTheme:JSGraphThemeDefault];
                [self.barPlot setNeedsDisplay];
                break;
            case 1:
                [self.barPlot setTheme:JSGraphThemeForest];
                [self.barPlot setNeedsDisplay];
                break;
            case 2:
                [self.barPlot setTheme:JSGraphThemeDark];
                [self.barPlot setNeedsDisplay];
                break;
            case 3:
                [self.barPlot setTheme:JSGraphThemeLight];
                [self.barPlot setNeedsDisplay];
                break;
            case 4:
                [self.barPlot setTheme:JSGraphThemeSky];
                [self.barPlot setNeedsDisplay];
                break;
            default:
                break;
        }
    } else {
        switch ([control selectedSegmentIndex]) {
            case 0:
                [self.scatterPlot setTheme:JSGraphThemeDefault];
                [self.scatterPlot setNeedsDisplay];
                break;
            case 1:
                [self.scatterPlot setTheme:JSGraphThemeForest];
                [self.scatterPlot setNeedsDisplay];
                break;
            case 2:
                [self.scatterPlot setTheme:JSGraphThemeDark];
                [self.scatterPlot setNeedsDisplay];
                break;
            case 3:
                [self.scatterPlot setTheme:JSGraphThemeLight];
                [self.scatterPlot setNeedsDisplay];
                break;
            case 4:
                [self.scatterPlot setTheme:JSGraphThemeSky];
                [self.scatterPlot setNeedsDisplay];
                break;
            default:
                break;
        }
    }
}

- (NSNumber *)graphViewDataPointsAtIndex:(NSInteger)index forSetNumber:(NSInteger)setNumber
{
    switch (setNumber) {
        case 0:
            return [self.dataset1 objectAtIndex:index];
            break;
        case 1:
            return [self.dataset2 objectAtIndex:index];
            break;
        case 2:
            return [self.dataset3 objectAtIndex:index];
            break;
        default:
            break;
    }
    return nil;
}

- (UIColor *)colorForPlotSet:(NSInteger)setNumber
{
    switch (setNumber) {
        case 0:
            return [UIColor redColor];
            break;
        case 1:
            return [UIColor blueColor];
            break;
        case 2:
            return [UIColor greenColor];
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfDataPointsForSet:(NSInteger)setNumber
{
    switch (setNumber) {
        case 0:
            return [self.dataset1 count];
            break;
        case 1:
            return [self.dataset2 count];
            break;
        case 2:
            return [self.dataset3 count];
            break;
        default:
            break;
    }
    return 0;
}

- (NSArray *)gradientColorsForPlotSet:(NSInteger)setNumber
{
    switch (setNumber) {
        case 0:
            return @[[UIColor redColor], [UIColor blackColor]];
            break;
        case 1:
            return @[[UIColor blueColor], [UIColor brownColor]];
            break;
        case 2:
            return @[[UIColor greenColor], [UIColor yellowColor]];
            break;
        default:
            break;
    }
    return nil;
}


- (NSArray *)colorForLineGraphDataPointSet:(NSInteger)setNumber
{
    switch (setNumber) {
        case 0:
            return @[[UIColor redColor], [UIColor blackColor]];
            break;
        case 1:
            return @[[UIColor blueColor], [UIColor brownColor]];
            break;
        case 2:
            return @[[UIColor greenColor], [UIColor yellowColor]];
            break;
        default:
            break;
    }
    return nil;
}

- (NSArray *)graphViewWithLegendDataTypes
{
    return @[@"AAPL", @"GOOG", @"YHOO"];
}

- (NSInteger)numberOfDataSets
{
    return 3;
}

/*
- (NSArray *)graphViewWithVerticalAxisPoints:(JSPlot *)graphView
{
    return @[@"Mon", @"Tue", @"Wed"];
}
*/

- (NSInteger)numberOfHorizontalAxes
{
    return 10;
}

- (CFTimeInterval)animateDurationForDataPoints
{
    return 1.0f;
}

- (void)JSGraphView:(JSGraphView *)graphView didTapDataPointAtIndex:(NSInteger)index inSet:(NSInteger)setNumber
{
    NSString *message;
    switch (setNumber) {
        case 0:
            message = [NSString stringWithFormat:@"Did tap data point: '%@' in dataset '0'", [self.dataset1 objectAtIndex:index]];
            break;
        case 1:
            message = [NSString stringWithFormat:@"Did tap data point: '%@' in dataset '1'", [self.dataset2 objectAtIndex:index]];
            break;
        case 2:
            message = [NSString stringWithFormat:@"Did tap data point: '%@' in dataset '2'", [self.dataset3 objectAtIndex:index]];
            break;
        default:
            break;
    }
    
    [[[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
}

- (JSBarPlot *)barPlot
{
    if (!_barPlot) {
        _barPlot = [[JSBarPlot alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width - 20, 250)];
        [_barPlot setDataSource:self];
        [_barPlot setDelegate:self];
        [_barPlot setOverallPadding:40.0f];
        [_barPlot setLeftGraphPadding:10.0f];
        [_barPlot setRightGraphPadding:10.0f];
        [_barPlot setShowHorizontalAxis:YES];
        [_barPlot setShowLegendView:YES];
    }
    return _barPlot;
}

- (JSScatterPlot *)scatterPlot
{
    if (!_scatterPlot) {
        _scatterPlot = [[JSScatterPlot alloc] initWithFrame:CGRectMake(10, 400, self.view.frame.size.width - 20, 250)];
        [_scatterPlot setDataSource:self];
        [_scatterPlot setDelegate:self];
        [_scatterPlot setTopPadding:40.0f];
        [_scatterPlot setLeftPadding:40.0f];
        [_scatterPlot setRightPadding:60.0f];
        [_scatterPlot setBottomPadding:40.0f];
        
        [_scatterPlot setLeftGraphPadding:10.0f];
        [_scatterPlot setRightGraphPadding:10.0f];
        
        [_scatterPlot setPointRadius:5.0f];
        [_scatterPlot setLineWidth:5.0f];
        [_scatterPlot setShowHorizontalAxis:YES];
        [_scatterPlot setBoxLineWidth:1.0f];
        [_scatterPlot setShowPointLabels:NO];
        [_scatterPlot setPointLabelAngle:0.0f];
        [_scatterPlot setPointLabelOffset:CGPointMake(10, -10)];
        [_scatterPlot setShowLineCurvature:YES];
        [_scatterPlot setLineAnimationDuration:5.0f];
        [_scatterPlot setGraphCornerRadius:5.0f];
        [_scatterPlot setShowLegendView:YES];
        [_scatterPlot setLegendOffset:CGPointMake(_scatterPlot.frame.size.width - 55, _scatterPlot.frame.size.height / 2.0f - 55/2.0f)];
    }
    return _scatterPlot;
}


@end
