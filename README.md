# JSGraphKit
Lightweight Graphing Library using CoreGraphics.

<h2>How it works</h2>
The library currently consists of two views, JSScatterPlot and JSBarPlot, both of which are subclasses of JSPlot. It's up to the developer to set the paddings of the graphs and data. The API makes it simple and there are default themes to use. Also, the graphs adjust according to its bounds, making porting the library to your project easy and simply by just setting the frame and feeding it data.

<h3>Example</h3>

Lets start making the graph! So, just to basically setup the graph, we need data! We'll use some generic points, doesnt really matter if there floats or ints, they just need to be casted as NSNumbers in the end :).

```Objective-C
- (void)viewDidLoad {
    self.dataset1 = @[@100, @200, @400, @500, @100, @60, @40, @200, @50, @20, @60, @100, @200];
    self.dataset2 = @[@21, @30, @440, @550, @110, @60, @400, @20, @450, @120, @20, @120, @20];
    self.dataset3 = @[@400, @500, @10, @210, @520, @400, @300, @120, @230, @500, @210, @240, @50];

    self.scatterPlot = [[JSScatterPlot alloc] initWithFrame:self.view.frame];
    [self.scatterPlot setDataSource:self];
    [self.scatterPlot setDelegate:self];
    [self.view addSubview:self.scatterPlot];
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
- (NSInteger)numberOfDataSets
{
    return 3;
}
```
So here, we specify how many 'lines' we want to create. We then specify the amount of data points for each 'line' as well as supply the data point. 

Heres the result...



Eww... Not the best layout. Maybe I should change the default theme :P. But here, lets spice it up!




![Alt text](Example1.png "Optional Title")
