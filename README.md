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

![Alt text](Example0.png "Optional Title")

Eww... Not the best layout. Maybe I should change the default theme :P. But first, the graph seems to not show the min/max x points as well as min/max y points, or at least there cut off. So lets fix that. Here we set the padding of the graph view.

```Objective-C
    [self.scatterPlot setOverallPadding:40.0f];
```
Simple huh? Now lets see what we got.

![Alt text](Example1.png "Optional Title")

Nice! Now we can actually see all the data.

Okay now lets set some themes, lets go with the Sky theme (my favorite)

```Objective-C
    [self.scatterPlot setTheme:JSGraphThemeSky];
```
Heres what we get...
![Alt text](Example2.png "Optional Title")

Oh nice! Im likin it so far. But theres still some stuff missing :/. Lets add some horizontal lines! There is a datasource protocol you can implement to do this. Just set the number of lines you want and the library does the rest. By default, the horizontal and vertical axis aren't drawn. To show them, set the properties to yes. But when you set these to show, you need to implement the data source! Otherwise you will crash and receive an Assert message I implemented.

```Objective-C
    [self.scatterPlot setShowHorizontalAxis:YES];
    //[self.scatterPlot setShowVerticalAxis:YES];

- (NSInteger)numberOfHorizontalAxes
{
    return 10;
}
```

Lets see what this does...

![Alt text](Example3.png "Optional Title")
Nice! We have lines! The Vertical Axis is in development now. You can use them but I advise you to wait or contribute!



![Alt text](Showcase.png "Optional Title")
