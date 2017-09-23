//
//  marketInfoTableViewController.m
//  Neodius
//
//  Created by Benjamin de Bos on 23-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "marketInfoTableViewController.h"

@implementation marketInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *baseCrypto,*baseFiat;

    //setup the request network manager
    networkManager = [AFHTTPSessionManager manager];
    
    self.title = NSLocalizedString(@"Market information",nil);

    baseCrypto  = [[[NeodiusDataSource sharedData] getCryptoData] objectForKey:[[NeodiusDataSource sharedData] getBaseCrypto]];
    baseFiat    = [[[NeodiusDataSource sharedData] getFiatData] objectForKey:[[NeodiusDataSource sharedData] getBaseFiat]];
    
    refreshInterval = [NSNumber numberWithInt:[[[NeodiusDataSource sharedData] getRefreshInterval] intValue]];
    
    statsArray = [[NSMutableArray alloc] initWithArray:@[@{@"title":@"NEO"},@{@"title":@"GAS"}]];
    
    UIImage *menuIcon = [[NeodiusDataSource sharedData] tableIconPositive:@"fa-reorder"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuIcon
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openLeftSide)];

}

-(void)viewDidAppear:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

-(void)openLeftSide {
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
}

-(void)loadData {

    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self restartTimerProcessForSeconds:refreshInterval];
        
        if (!firstNoInternet) {
            if ([[NeodiusDataSource sharedData] getShowMessages]) {
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
            if ([[NeodiusDataSource sharedData] getShowMessages]) {
                CWStatusBarNotification *n = [CWStatusBarNotification new];
                n.notificationLabelBackgroundColor = [UIColor whiteColor];
                n.notificationLabelTextColor = neoGreenColor;
                [n displayNotificationWithMessage:NSLocalizedString(@"Oh yes, internet is back!", nil) forDuration:3];
            }
            firstNoInternet = NO;
        }
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [networkManager GET:[NSString stringWithFormat:@"https://bittrex.com/api/v1.1/public/getmarketsummary?market=%@-NEO",@"BTC"]
             parameters:nil
               progress:nil
                success:^(NSURLSessionTask *task, id responseObject) {

                    statsArray[0] = @{@"label": @"NEO",
                                      @"24low": [[[responseObject objectForKey:@"result"] objectAtIndex:0] objectForKey:@"Low"],
                                      @"24high":[[[responseObject objectForKey:@"result"] objectAtIndex:0] objectForKey:@"High"],
                                      @"value": [[[responseObject objectForKey:@"result"] objectAtIndex:0] objectForKey:@"Last"]};
                    [self.tableView reloadData];
                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [networkManager GET:@"https://poloniex.com/public?command=returnTicker"
                 parameters:nil
                   progress:nil
                    success:^(NSURLSessionTask *task, id responseObject) {
                        
                        NSDictionary *tmpDict = [responseObject objectForKey:[NSString stringWithFormat:@"%@_GAS",@"BTC"]];
                        
                        [statsArray replaceObjectAtIndex:1 withObject:@{@"label": @"GAS",
                                                                        @"24low": [tmpDict objectForKey:@"low24hr"],
                                                                        @"24high":[tmpDict objectForKey:@"high24hr"],
                                                                        @"value": [tmpDict objectForKey:@"last"]}];
                        [self.tableView reloadData];
                    } failure:^(NSURLSessionTask *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                    }];
    });
    
}

-(void)showTimerProcess:(NSNumber*)timer {
    if ([[NeodiusDataSource sharedData] getShowTimer])
        [self.navigationController showSGProgressWithDuration:[timer floatValue] andTintColor:[UIColor whiteColor]];
}

-(void)restartTimerProcessForSeconds:(NSNumber*)timer {
    //set progress to 0
    [self.navigationController setSGProgressPercentage:0];
    //dispatch with delay:
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self showTimerProcess:timer];
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * [timer floatValue]+1);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transactionCell"];

        //SET UP FOR GAUGES
        if (indexPath.section == 0) {
            
            CGFloat baseHeight = self.tableView.frame.size.width/2;
            CGFloat baseWidth = self.tableView.frame.size.width-20;
            CGFloat labelPosition = baseHeight;
            CGFloat labelWidth = 100;

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //title
            UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(20,10,baseWidth-20,40)];
            t.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
            t.textAlignment = NSTextAlignmentCenter;
            t.numberOfLines = 2;
            t.tag = 10;
            [cell addSubview:t];

            //title
            UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(20,40,baseWidth-20,40)];
            v.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            v.textAlignment = NSTextAlignmentCenter;
            v.numberOfLines = 2;
            v.tag = 11;
            [cell addSubview:v];

            
            //gauge
            MSSimpleGauge* a = [[MSSimpleGauge alloc] initWithFrame:CGRectMake(10, 80, baseWidth,baseHeight)];
            a.tag = 12;
            a.fillArcFillColor = neoGreenColor;
            a.fillArcStrokeColor = [UIColor colorWithRed:.41 green:.76 blue:.73 alpha:1];
            [cell addSubview:a];

            //low
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20,labelPosition,labelWidth,40)];
            l.tag = 13;
            l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            l.textAlignment = NSTextAlignmentCenter;
            l.numberOfLines = 2;
            [cell addSubview:l];

            //high
            UILabel *h = [[UILabel alloc] initWithFrame:CGRectMake(baseWidth-labelWidth,labelPosition,labelWidth,40)];
            h.tag = 14;
            h.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            h.textAlignment = NSTextAlignmentCenter;
            h.numberOfLines = 2;
            [cell addSubview:h];
        }
    }
    
    if (indexPath.section == 0) {
        
        //set values
        NSNumber *low24 = [NSNumber numberWithFloat:[[[statsArray objectAtIndex:indexPath.row] objectForKey:@"24low"] floatValue]];
        NSNumber *high24 = [NSNumber numberWithFloat:[[[statsArray objectAtIndex:indexPath.row] objectForKey:@"24high"] floatValue]];
        NSNumber *value = [NSNumber numberWithFloat:[[[statsArray objectAtIndex:indexPath.row] objectForKey:@"value"] floatValue]];

        //set title
        UILabel *t = (UILabel*)[cell viewWithTag:10];
        t.text = [[statsArray objectAtIndex:indexPath.row] objectForKey:@"label"];
        
        //set value
        UILabel *v = (UILabel*)[cell viewWithTag:11];
        v.text = [[NeodiusDataSource sharedData] formatNumber:value ofType:3 withFiatSymbol:nil];
        
        //set gauge to correct settings
        MSSimpleGauge* g = (MSSimpleGauge*)[cell viewWithTag:12];
        g.minValue = [[[statsArray objectAtIndex:indexPath.row] objectForKey:@"24low"] floatValue];
        g.maxValue = [[[statsArray objectAtIndex:indexPath.row] objectForKey:@"24high"] floatValue];
        [g setValue:[value floatValue] animated:YES];

        //set 24 low
        UILabel *l = (UILabel*)[cell viewWithTag:13];
        l.text = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"24h low", nil),[[NeodiusDataSource sharedData] formatNumber:low24 ofType:3 withFiatSymbol:nil]];
        
        //set 24 high
        UILabel *h = (UILabel*)[cell viewWithTag:14];
        h.text = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"24h high", nil),[[NeodiusDataSource sharedData] formatNumber:high24 ofType:3 withFiatSymbol:nil]];
        
        
    }
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Current market";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return (self.tableView.frame.size.width/2)+100;
    
    return 20;
    
}

@end
