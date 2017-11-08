//
//  marketGraphTableViewController.m
//  Nodius
//
//  Created by Benjamin de Bos on 13-10-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "marketGraphTableViewController.h"

@implementation marketGraphTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //clear the seperators
    //self.tableView.separatorColor = [UIColor clearColor];
    
    //setup the request network manager
    networkManager = [AFHTTPSessionManager manager];

    
    if (_type == nil)
        _type = @"NEO";
    
    
    if ([_type isEqualToString:@"NEO"]) {
        intervals = @[@{@"label" :@"1m",
                        @"url" : @"https://bittrex.com/Api/v2.0/pub/market/GetTicks?marketName=BTC-NEO&tickInterval=oneMin"},
                      @{@"label" :@"5m",
                        @"url" : @"https://bittrex.com/Api/v2.0/pub/market/GetTicks?marketName=BTC-NEO&tickInterval=fiveMin"},
                      @{@"label" :@"30m",
                        @"url" : @"https://bittrex.com/Api/v2.0/pub/market/GetTicks?marketName=BTC-NEO&tickInterval=thirtyMin"},
                      @{@"label" :@"1h",
                        @"url" : @"https://bittrex.com/Api/v2.0/pub/market/GetTicks?marketName=BTC-NEO&tickInterval=hour"},
                      @{@"label" :@"1d",
                        @"url" : @"https://bittrex.com/Api/v2.0/pub/market/GetTicks?marketName=BTC-NEO&tickInterval=day"}];
    } else if ([_type isEqualToString:@"GAS"]) {
        intervals = @[@{@"label" :@"5m",
                        @"url" : @"https://poloniex.com/public?command=returnChartData&currencyPair=BTC_GAS&start=0&end=9999999999&period=300"},
                      @{@"label" :@"15m",
                        @"url" : @"https://poloniex.com/public?command=returnChartData&currencyPair=BTC_GAS&start=0&end=9999999999&period=900"},
                      @{@"label" :@"30m",
                        @"url" : @"https://poloniex.com/public?command=returnChartData&currencyPair=BTC_GAS&start=0&end=9999999999&period=1800"},
                      @{@"label" :@"2h",
                        @"url" : @"https://poloniex.com/public?command=returnChartData&currencyPair=BTC_GAS&start=0&end=9999999999&period=7200"},
                      @{@"label" :@"4h",
                        @"url" : @"https://poloniex.com/public?command=returnChartData&currencyPair=BTC_GAS&start=0&end=9999999999&period=14400"},
                      @{@"label" :@"1d",
                        @"url" : @"https://poloniex.com/public?command=returnChartData&currencyPair=BTC_GAS&start=0&end=9999999999&period=86400"}];
    }
    
    selectedInterval = 0;
    [self loadDataWithInterval:selectedInterval];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"reloadData"
                                               object:nil];

    
}

-(void)loadData {
    [self loadDataWithInterval:selectedInterval];
}

-(void)loadDataWithInterval:(NSUInteger)intervalIndex {
    
    
    if (intervalIndex > intervals.count) {
        NSLog(@"Index bestaat niet");
        return;
    } else {
        NSLog(@"Loading: %@",intervals[intervalIndex][@"label"]);
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [networkManager GET:intervals[intervalIndex][@"url"]
             parameters:nil
               progress:nil
                success:^(NSURLSessionTask *task, id responseObject) {
                    
                    NSMutableArray *tmp = [[NSMutableArray alloc] init];
                    if ([_type isEqualToString:@"NEO"]) {
                        if ([responseObject objectForKey:@"success"] == 0)
                            return;
                        for (id dict in [responseObject objectForKey:@"result"]) {
                            NSDateFormatter *dateFormat = [NSDateFormatter new];
                            dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
                            [tmp addObject:@{@"close":[dict objectForKey:@"C"],
                                             @"time":[[dateFormat dateFromString:[dict objectForKey:@"T"]] dateByAddingHours:2]}];
                        }
                        
                    } else if ([_type isEqualToString:@"GAS"]) {
//                        if ([responseObject objectForKey:@"error"] == [NSNull null])
//                            return;
                        
                        for (id dict in responseObject) {
                            [tmp addObject:@{@"close":[dict objectForKey:@"close"],
                                             @"time":[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"date"] doubleValue]]}];
                        }
                    }
                    
                    
                    
                    int lastLogsCount = 100;
                    if (tmp.count > lastLogsCount) {
                        graphPoints = [tmp subarrayWithRange:NSMakeRange(tmp.count - lastLogsCount, lastLogsCount)];
                    } else {
                        graphPoints = tmp;
                    }
                    
                    NSLog(@"%@",graphPoints);
                    
                    marketGraphTableViewCell* c = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:GraphCellTypeGraph inSection:0]];
                    [c.graphView reloadGraph];
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    
                    [self formatHeadingLabelForIndex:graphPoints.count-1];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }];
}

-(void)formatHeadingLabelForIndex:(NSUInteger)arrayIndex {
    NSDate *date = graphPoints[arrayIndex][@"time"];
    marketGraphTableViewCell* c = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:GraphCellTypeHeader inSection:0]];
    c.dateLabel.text = [date formattedDateWithFormat:@"d MMMM Y HH:mm"];
    c.valueLabel.text = [NSString stringWithFormat:@"%.8f",[graphPoints[arrayIndex][@"close"] doubleValue]];
}



#pragma UIPagingControl delegate methods
-(void)segmentedControlValueDidChange:(id)sender{
    UISegmentedControl *s = (UISegmentedControl*)sender;
    selectedInterval = s.selectedSegmentIndex;
    [self loadDataWithInterval:selectedInterval];
}

#pragma BEM delegate methods
- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @" BTC";
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return graphPoints.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [graphPoints[index][@"close"] doubleValue];
}


- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disablePaging" object:self];
    [self formatHeadingLabelForIndex:index];
}

-(void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enablePaging" object:self];
}

#pragma Table view delegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    marketGraphTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[marketGraphTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" andType:indexPath.row];
        if (indexPath.row == 1) {
            //set delegate and datasource
            cell.graphView.delegate = self;
            cell.graphView.dataSource = self;
        } else if (indexPath.row == 2) { // set datepicker
            int i = 0;
            for (id title in intervals) {
                [cell.intervalPicker insertSegmentWithTitle:[title objectForKey:@"label"] atIndex:i animated:NO];
                i++;
            }
            cell.intervalPicker.selectedSegmentIndex = selectedInterval;
            [cell.intervalPicker addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([_type isEqualToString:@"NEO"])
        return @"Bittrex";
    else
        return @"Poloniex";

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1)
        return 300;
    else
        return UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
