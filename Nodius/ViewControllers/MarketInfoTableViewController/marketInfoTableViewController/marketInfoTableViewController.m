//
//  marketInfoTableViewController.m
//  Nodius
//
//  Created by Benjamin de Bos on 23-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "marketInfoTableViewController.h"

@implementation marketInfoTableViewController

@synthesize type = _type;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_type == nil)
        _type = @"NEO";
    
    self.title = [NSString stringWithFormat:NSLocalizedString(@"%@ Market information",nil),_type];
    
    //setup the request network manager
    networkManager = [AFHTTPSessionManager manager];

    baseCrypto  = [[NodiusDataSource sharedData] getCryptoData][[[NodiusDataSource sharedData] getBaseCrypto]];
    baseFiat    = [[NodiusDataSource sharedData] getFiatData][[[NodiusDataSource sharedData] getBaseFiat]];
    
    refreshInterval = @([[NodiusDataSource sharedData] getRefreshInterval].intValue);
    
    if ([_type isEqualToString:@"NEO"]) {
        statsArray = [[NSMutableArray alloc] initWithArray:@[@{@"label":@"NEO",@"rank":@0}]];
    } else {
        statsArray = [[NSMutableArray alloc] initWithArray:@[@{@"label":@"GAS",@"rank":@0}]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"reloadData"
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

-(void)loadData {
    
    NSLog(@"Loading data");
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self restartTimerProcessForSeconds:refreshInterval];
        if (!firstNoInternet) {
            if ([[NodiusDataSource sharedData] getShowMessages]) {
                CWStatusBarNotification *n = [CWStatusBarNotification new];
                n.notificationLabelBackgroundColor = [UIColor redColor];
                n.notificationLabelTextColor = [UIColor whiteColor];
                [n displayNotificationWithMessage:NSLocalizedString(@"No network we'll inform you when it's back!", nil) forDuration:3];
            }
            firstNoInternet = YES;
        }
        return;
    } else {
        if (firstNoInternet) {
            if ([[NodiusDataSource sharedData] getShowMessages]) {
                CWStatusBarNotification *n = [CWStatusBarNotification new];
                n.notificationLabelBackgroundColor = [UIColor whiteColor];
                n.notificationLabelTextColor = neoGreenColor;
                [n displayNotificationWithMessage:NSLocalizedString(@"Oh yes, internet is back!", nil) forDuration:3];
            }
            firstNoInternet = NO;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [networkManager GET:[NSString stringWithFormat:@"https://api.coinmarketcap.com/v1/ticker/%@/?convert=%@",
                         _type,
                         baseFiat[@"id"]]
             parameters:nil
               progress:nil
                success:^(NSURLSessionTask *task, id responseObject) {
                    NSNumber *volume = @([responseObject[0][baseFiat[@"node_volume"]] floatValue]);
                    NSNumber *cap = @([responseObject[0][baseFiat[@"node_cap"]] floatValue]);
                    NSNumber *rank = @([responseObject[0][@"rank"] floatValue]);
                    NSNumber *change_1h = @([responseObject[0][@"percent_change_1h"] floatValue]);
                    NSNumber *change_24h = @([responseObject[0][@"percent_change_24h"] floatValue]);
                    NSNumber *change_7d = @([responseObject[0][@"percent_change_7d"] floatValue]);
                    
                    [networkManager GET:[NSString stringWithFormat:@"https://api.coinmarketcap.com/v1/ticker/%@/?convert=%@",
                                         baseCrypto[@"name"],
                                         baseFiat[@"id"]]
                             parameters:nil
                               progress:nil
                                success:^(NSURLSessionTask *task, id responseObject) {
                                    
                                    cryptoFiatValue = @([responseObject[0][baseFiat[@"node_price"]]floatValue]);
                                    
                                    
                                    
                                    if ([_type isEqualToString:@"NEO"]) {
                                        [networkManager GET:[NSString stringWithFormat:@"https://bittrex.com/api/v1.1/public/getmarketsummary?market=%@-NEO",baseCrypto[@"id"]]
                                                 parameters:nil
                                                   progress:nil
                                                    success:^(NSURLSessionTask *task, id responseObject) {
                                                        
                                                        statsArray[0] = @{@"label": @"NEO",
                                                                          @"24low": responseObject[@"result"][0][@"Low"],
                                                                          @"24high":responseObject[@"result"][0][@"High"],
                                                                          @"last": responseObject[@"result"][0][@"Last"],
                                                                          @"volume" : volume,
                                                                          @"cap" : cap,
                                                                          @"bid" : responseObject[@"result"][0][@"Bid"],
                                                                          @"ask" : responseObject[@"result"][0][@"Ask"],
                                                                          @"rank" : rank,
                                                                          @"percent_change_1h": change_1h,
                                                                          @"percent_change_24h": change_24h,
                                                                          @"percent_change_7d": change_7d
                                                                          };
                                                        [self.tableView reloadData];
                                                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        
                                                    } failure:^(NSURLSessionTask *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                    }];
                                    } else {
                                        [networkManager GET:@"https://poloniex.com/public?command=returnTicker"
                                                 parameters:nil
                                                   progress:nil
                                                    success:^(NSURLSessionTask *task, id responseObject) {
                                                        
                                                        NSDictionary *tmpDict = responseObject[[NSString stringWithFormat:@"%@_GAS",baseCrypto[@"id"]]];
                                                        
                                                        statsArray[0] = @{@"label": @"GAS",
                                                                          @"24low": @([tmpDict[@"low24hr"] floatValue]),
                                                                          @"24high":@([tmpDict[@"high24hr"] floatValue]),
                                                                          @"last": @([tmpDict[@"last"] floatValue]),
                                                                          @"volume": volume,
                                                                          @"cap": cap,
                                                                          @"bid": @([tmpDict[@"highestBid"] floatValue]),
                                                                          @"ask": @([tmpDict[@"lowestAsk"] floatValue]),
                                                                          @"rank": rank,
                                                                          @"percent_change_1h": change_1h,
                                                                          @"percent_change_24h": change_24h,
                                                                          @"percent_change_7d": change_7d
                                                                          };
                                                        [self.tableView reloadData];
                                                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        
                                                    } failure:^(NSURLSessionTask *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                    }];
                                    }
                                } failure:^(NSURLSessionTask *operation, NSError *error) {
                                    NSLog(@"Error: %@", error);
                                }];
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
    
}

-(void)showTimerProcess:(NSNumber*)timer {
    if ([[NodiusDataSource sharedData] getShowTimer])
        [self.navigationController showSGProgressWithDuration:timer.floatValue andTintColor:[UIColor whiteColor]];
}

-(void)restartTimerProcessForSeconds:(NSNumber*)timer {
    //set progress to 0
    [self.navigationController setSGProgressPercentage:0];
    //dispatch with delay:
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showTimerProcess:timer];
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * timer.floatValue+1);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            [self loadData];
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 2;
    else if (section == 1)
        return 3;
    else if (section == 2)
        return 3;
    else if (section == 3)
        return 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transactionCell"];
        
        if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
            //type of cell
            cell = [[marketViewCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"transactionCell"];
            
            //selection style
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //textlabel
            cell.textLabel.font = [UIFont fontWithName:FONT_LIGHT size:16.0];
            cell.textLabel.numberOfLines = 2;
            [cell.textLabel sizeToFit];
            
            //detaillabel
            cell.detailTextLabel.font = [UIFont fontWithName:FONT_LIGHT size:16.0];
            cell.detailTextLabel.numberOfLines = 2;
            
        } else if (indexPath.section == 3) {
            
            //type of cell
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transactionCell"];
            
            //selection style
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //SET UP FOR GAUGE
            CGFloat baseHeight = self.tableView.frame.size.width/2;
            CGFloat baseWidth = self.tableView.frame.size.width-20;
            CGFloat labelPosition = baseHeight-30;
            CGFloat labelWidth = 100;
            
            //title
            UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(20,10,baseWidth-20,40)];
            v.font = [UIFont fontWithName:FONT_LIGHT size:16];
            v.textAlignment = NSTextAlignmentCenter;
            v.numberOfLines = 2;
            v.tag = 11;
            [cell.contentView addSubview:v];
            
            //gauge
            MSSimpleGauge* a = [[MSSimpleGauge alloc] initWithFrame:CGRectMake(10, 50, baseWidth,baseHeight)];
            a.tag = 12;
            a.fillArcFillColor = neoGreenColor;
            a.fillArcStrokeColor = [UIColor colorWithRed:.41 green:.76 blue:.73 alpha:1];
            [cell.contentView addSubview:a];
            
            //low
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20,labelPosition,labelWidth,40)];
            l.tag = 13;
            l.font = [UIFont fontWithName:FONT_LIGHT size:14];
            l.textAlignment = NSTextAlignmentCenter;
            l.numberOfLines = 2;
            l.text = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"24h low", nil),[[NodiusDataSource sharedData] formatNumber:0 ofType:3 withFiatSymbol:nil]];
            [cell.contentView addSubview:l];
            
            //high
            UILabel *h = [[UILabel alloc] initWithFrame:CGRectMake(baseWidth-labelWidth,labelPosition,labelWidth,40)];
            h.tag = 14;
            h.font = [UIFont fontWithName:FONT_LIGHT size:14];
            h.textAlignment = NSTextAlignmentCenter;
            h.numberOfLines = 2;
            h.text = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"24h low", nil),[[NodiusDataSource sharedData] formatNumber:0 ofType:3 withFiatSymbol:nil]];
            [cell.contentView addSubview:h];
        }
    }
    
    
    if (indexPath.section == 0 || indexPath.section == 1  || indexPath.section == 2) {
        NSString *node, *title, *icon;
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                title = NSLocalizedString(@"Bid price",nil);
                node = @"bid";
                icon = @"fa-bullhorn";
            } else if (indexPath.row == 1) {
                title = NSLocalizedString(@"Ask price",nil);
                node = @"ask";
                icon = @"fa-sign-out";
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                title = NSLocalizedString(@"Market Cap",nil);
                node = @"cap";
                icon = @"fa-arrows-alt";
            } else if (indexPath.row == 1) {
                title = NSLocalizedString(@"Volume",nil);
                node = @"volume";
                icon = @"fa-pie-chart";
            } else if (indexPath.row == 2) {
                title = NSLocalizedString(@"Rank",nil);
                node = @"rank";
                icon = @"fa-trophy";
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                title = NSLocalizedString(@"1 Hour",nil);
                node = @"percent_change_1h";
                icon = @"fa-arrows-alt";
            } else if (indexPath.row == 1) {
                title = NSLocalizedString(@"24 Hours",nil);
                node = @"percent_change_24h";
                icon = @"fa-arrows-alt";
            } else if (indexPath.row == 2) {
                title = NSLocalizedString(@"7 Days",nil);
                node = @"percent_change_7d";
                icon = @"fa-arrows-alt";
            }
        }
        
        //set sources
        NSNumber *src = statsArray[0][node];
        NSNumber *value = @(src.floatValue * cryptoFiatValue.floatValue);

        //set title and imageview
        cell.textLabel.text = title;
        
        //icons alternating
        if (indexPath.section == 2) {
            
            UIColor *c;
            
            if (src.floatValue == 0) {
                c = neoGreenColor;
                icon = @"fa-genderless";
            } else if (src.floatValue > 0) {
                c = [UIColor colorWithRed:0.25 green:0.28 blue:0.80 alpha:1.0];
                icon = @"fa-arrow-up";
            } else if (src.floatValue < 0) {
                c = [UIColor redColor];
                icon = @"fa-arrow-down";
            }
            
            cell.imageView.image =  [UIImage imageWithIcon:icon
                                           backgroundColor:[UIColor clearColor]
                                                 iconColor:c
                                                 iconScale:1.0
                                                   andSize:CGSizeMake(24, 24)];
        } else {
            cell.imageView.image = [[NodiusDataSource sharedData] tableIconPositive:icon];
        }
        
        
        
        if (indexPath.section == 0) {
            NSString * cryptoValue = [[NodiusDataSource sharedData] formatNumber:((src == nil) ? @0 : src) ofType:3 withFiatSymbol:baseFiat[@"symbol"]];
            NSString * fiatValue = [[NodiusDataSource sharedData] formatNumber:((value == nil) ? @0 : value) ofType:2 withFiatSymbol:baseFiat[@"symbol"]];
            cryptoValue = [cryptoValue stringByAppendingString:@"\n"];
            cryptoValue = [cryptoValue stringByAppendingString:fiatValue];
            cell.detailTextLabel.text = cryptoValue;
            
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                cell.detailTextLabel.text = [[NodiusDataSource sharedData] formatNumber:((src == nil) ? @0 : src) ofType:2 withFiatSymbol:baseFiat[@"symbol"]];
            } else {
                cell.detailTextLabel.text = src.stringValue;
            }
            
        } else if (indexPath.section == 2) {
            cell.detailTextLabel.text = [[NodiusDataSource sharedData] formatNumber:((src == nil) ? @0 : src) ofType:4 withFiatSymbol:nil];
        }
    } else if (indexPath.section == 3) {
        
        //set values
        NSNumber *low24 = @([statsArray[indexPath.row][@"24low"] floatValue]);
        NSNumber *high24 = @([statsArray[indexPath.row][@"24high"] floatValue]);
        NSNumber *value = @([statsArray[indexPath.row][@"last"] floatValue]);
        
        //set value
        UILabel *v = (UILabel*)[cell viewWithTag:11];
        v.text = [[NodiusDataSource sharedData] formatNumber:value ofType:3 withFiatSymbol:nil];
        
        //floats
        float low = [statsArray[indexPath.row][@"24low"] floatValue];
        float high = [statsArray[indexPath.row][@"24high"] floatValue];
        float last = [statsArray[indexPath.row][@"last"] floatValue];
        int gaugeValue = round(((last-low)/(high-low)*100));
        
        //set gauge to correct settings
        MSSimpleGauge* g = (MSSimpleGauge*)[cell viewWithTag:12];
        g.minValue = 0;
        g.maxValue = 100;
        [g setValue:gaugeValue animated:YES];
        
        //set 24 low
        UILabel *l = (UILabel*)[cell viewWithTag:13];
        l.text = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"24h low", nil),[[NodiusDataSource sharedData] formatNumber:low24 ofType:3 withFiatSymbol:nil]];
        
        //set 24 high
        UILabel *h = (UILabel*)[cell viewWithTag:14];
        h.text = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"24h high", nil),[[NodiusDataSource sharedData] formatNumber:high24 ofType:3 withFiatSymbol:nil]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:FONT_LIGHT size:header.textLabel.font.pointSize];
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return NSLocalizedString(@"Current bid/ask price",nil);
    else if (section == 1)
        return NSLocalizedString(@"Current market values",nil);
    else if (section == 2)
        return NSLocalizedString(@"Changes",nil);
    else if (section == 3)
        return NSLocalizedString(@"24 Hour trading",nil);
    
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 60;
    else if (indexPath.section == 3)
        return (self.tableView.frame.size.width/2)+70;
    return UITableViewAutomaticDimension;
    
}

@end
