//
//  walletViewTableViewController.m
//  Neodius
//
//  Created by Benjamin de Bos on 16-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "walletViewTableViewController.h"

@implementation walletViewTableViewController

@synthesize walletAddress = _walletAddress, walletTitle = _walletTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    


    baseCrypto  = [[NeodiusDataSource sharedData] getCryptoData][[[NeodiusDataSource sharedData] getBaseCrypto]];
    baseFiat    = [[NeodiusDataSource sharedData] getFiatData][[[NeodiusDataSource sharedData] getBaseFiat]];
    refreshInterval = @([[NeodiusDataSource sharedData] getRefreshInterval].intValue);
    transactions = @[];

    //show first time
    [[YCFirstTime shared] executeOnce:^{
        [UIAlertView showWithTitle:NSLocalizedString(@"Hey there!",nil)
                           message:NSLocalizedString(@"Welcome to Neodius, we aim to make the NEO blockchain more accessible to everybody.\n\nTo use this app, get your wallet address and add this to Neodius. You can do that by tapping the menu button on the left top side and tap Add Wallet.\n\nDon't forget to give feedback through the about screen!",nil)
                 cancelButtonTitle:NSLocalizedString(@"Cheers thanks!", nil)
                 otherButtonTitles:nil
                          tapBlock:nil];
        
    } forKey:@"neoFirstTimeMessagePopup"];
    
    

    //setup the request network manager
    networkManager = [AFHTTPSessionManager manager];
    
    UIImage *menuIcon = [[NeodiusDataSource sharedData] tableIconPositive:@"fa-reorder"];
    UIImage *qrIcon = [[NeodiusDataSource sharedData] tableIconPositive:@"fa-qrcode"];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuIcon
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                        action:@selector(openLeftSide)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:qrIcon
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showQrModal)];

    //setup header
    UIView *headerView = [self headerView];
    [self.tableView addParallaxWithView:headerView andHeight:headerView.frame.size.height];
    (self.tableView.parallaxView).delegate = self;
    
    if (_walletAddress == nil && _walletTitle == nil) {
        NSArray *storedWallets = [[NeodiusDataSource sharedData] getStoredWallets];
        if (storedWallets.count > 0) {
            self.title = storedWallets[0][@"name"];
            _walletTitle = storedWallets[0][@"title"];
            _walletAddress = storedWallets[0][@"address"];
            [self loadData];
        } else {
            
        }
    } else {
        self.title = _walletTitle;
        [self loadData];
    }
    
    
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Transactions", nil);
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
    
    [networkManager GET:[[NeodiusDataSource sharedData] buildAPIUrlWithEndpoint:[NSString stringWithFormat:@"/address/balance/%@",_walletAddress]]
             parameters:nil
               progress:nil
                success:^(NSURLSessionTask *task, id responseObject) {
                    neoAmount = responseObject[@"NEO"][@"balance"];
                    gasAmount = responseObject[@"GAS"][@"balance"];
                    
                    [self formatValueField:neoLabel withLabel:@"NEO" andValue:neoAmount andType:0];
                    [self formatValueField:gasLabel withLabel:@"GAS" andValue:gasAmount andType:1];

                    [networkManager GET:[NSString stringWithFormat:@"https://bittrex.com/api/v1.1/public/getmarketsummary?market=%@-NEO",baseCrypto[@"symbol"]]
                             parameters:nil
                               progress:nil
                                success:^(NSURLSessionTask *task, id responseObject) {
                                    cryptoValue = responseObject[@"result"][0][@"Bid"];
                                    NSNumber *totalCrypto = @(cryptoValue.floatValue * neoAmount.floatValue);
                                    [self formatValueField:baseCryptoLabel withLabel:baseCrypto[@"symbol"] andValue:totalCrypto andType:3];
                                } failure:^(NSURLSessionTask *operation, NSError *error) {
                                    NSLog(@"Error: %@", error);
                                }];
                    
                    [networkManager GET:[NSString stringWithFormat:@"https://api.coinmarketcap.com/v1/ticker/NEO/?convert=%@",baseFiat[@"id"]]
                             parameters:nil
                               progress:nil
                                success:^(NSURLSessionTask *task, id responseObject) {
                                    
                                    NSString *fiatValue = responseObject[0][baseFiat[@"node_price"]];
                                    NSNumber *totalFiat = @(fiatValue.floatValue * neoAmount.floatValue);
                                    [self formatValueField:fiatLabel withLabel:[baseFiat[@"name"] uppercaseString] andValue:totalFiat andType:2];
                                } failure:^(NSURLSessionTask *operation, NSError *error) {
                                    NSLog(@"Error: %@", error);
                                }];
                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
    
                [self restartTimerProcessForSeconds:refreshInterval];
    
    [networkManager GET:[[NeodiusDataSource sharedData] buildAPIUrlWithEndpoint:[NSString stringWithFormat:@"/address/claims/%@",_walletAddress]]
             parameters:nil
               progress:nil
                success:^(NSURLSessionTask *task, id responseObject) {
                    
                    unclaimedGasAmount = @(([responseObject[@"total_unspent_claim"] floatValue]+[responseObject[@"total_claim"] floatValue])/100000000);
                    [self formatValueField:unclaimedGasLabel withLabel:NSLocalizedString(@"Unclaimed GAS",nil).uppercaseString andValue:unclaimedGasAmount andType:3];

                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
    
    
    [networkManager GET:[[NeodiusDataSource sharedData] buildAPIUrlWithEndpoint:[NSString stringWithFormat:@"/address/history/%@",_walletAddress]]
             parameters:nil
               progress:nil
                success:^(NSURLSessionTask *task, id responseObject) {
                    
                    transactions = responseObject[@"history"];
                    [self.tableView reloadData];
                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];

    
    
}

-(void)showQrModal {
    
//    if (transactions.count==0)
//        return;
//    
    [[NeodiusUIComponents sharedComponents] showQrModalOnViewController:self
                                                            withAddress:_walletAddress
                                                              withTitle:nil
                                                       andShareMessage:nil];
    
}

-(void)restartTimerProcessForSeconds:(NSNumber*)timer {
    //set progress to 0
    [self.navigationController setSGProgressPercentage:0];
    //dispatch with delay:
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self showTimerProcess:timer];
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * timer.floatValue+1);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            [self loadData];
        });
    });
    
}

-(void)showTimerProcess:(NSNumber*)timer {
    if ([[NeodiusDataSource sharedData] getShowTimer])
        [self.navigationController showSGProgressWithDuration:timer.floatValue andTintColor:[UIColor whiteColor]];
}

-(UIView*)headerView {

    CGFloat headSpace = ((IS_IPHONE_X) ? 60 : 25), spacing = 20;
    
    customTableHeader = [[UIView alloc] initWithFrame:CGRectNull];
    [customTableHeader setBackgroundColor:neoGreenColor];

    //set neo label
    neoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headSpace+60, self.tableView.frame.size.width, 60)];
    [self formatValueField:neoLabel withLabel:@"NEO" andValue:@0 andType:0];

    //set gas label
    gasLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, neoLabel.frame.origin.y+neoLabel.frame.size.height+spacing, self.tableView.frame.size.width, 60)];
    [self formatValueField:gasLabel withLabel:@"GAS" andValue:@0 andType:1];

    //set gas label
    unclaimedGasLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gasLabel.frame.origin.y+gasLabel.frame.size.height+spacing, self.tableView.frame.size.width, 60)];
    [self formatValueField:unclaimedGasLabel withLabel:NSLocalizedString(@"Unclaimed GAS",nil).uppercaseString andValue:@0 andType:1];

    //set BTC label
    baseCryptoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, unclaimedGasLabel.frame.origin.y+unclaimedGasLabel.frame.size.height+spacing, self.tableView.frame.size.width, 60)];
    [self formatValueField:baseCryptoLabel withLabel:baseCrypto[@"symbol"] andValue:@0 andType:4];
    
    //set fiat label
    fiatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, baseCryptoLabel.frame.origin.y+baseCryptoLabel.frame.size.height+spacing, self.tableView.frame.size.width, 60)];
    [self formatValueField:fiatLabel withLabel:[baseFiat[@"name"] uppercaseString] andValue:@0 andType:2];
    
    customTableHeader.frame = CGRectMake(0, 0, self.tableView.frame.size.width, fiatLabel.frame.origin.y+fiatLabel.frame.size.height-headSpace);

    
    [customTableHeader addSubview:neoLabel];
    [customTableHeader addSubview:gasLabel];
    [customTableHeader addSubview:unclaimedGasLabel];
    [customTableHeader addSubview:baseCryptoLabel];
    [customTableHeader addSubview:fiatLabel];
    
    return customTableHeader;
}



-(UILabel*)formatValueField:(UILabel*)s withLabel:(NSString*)lbl andValue:(NSNumber*)value andType:(int)type {
    //set attributes
    s.textColor = [UIColor whiteColor];
    s.textAlignment = NSTextAlignmentCenter;
    s.numberOfLines = 2;
    s.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    //setup fonts for big and small numbers
    UIFont *titleFont = [UIFont fontWithName:FONT_LIGHT size:16];
    UIFont *valueFont = [UIFont fontWithName:FONT size:30];
    
    //title dictionary
    NSDictionary *titleDict = @{NSFontAttributeName: titleFont};
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",lbl] attributes: titleDict];
    //value dictionaries
    NSDictionary *valueDict = @{NSFontAttributeName: valueFont};
    NSMutableAttributedString *valueString = [[NSMutableAttributedString alloc] 
                                              initWithString:[[[NeodiusDataSource sharedData] formatNumber:value ofType:type withFiatSymbol:baseFiat[@"symbol"]] stringByTrimmingCharactersInSet:
                                              [NSCharacterSet whitespaceCharacterSet]] attributes: valueDict];

    //append the value to the title
    [titleString appendAttributedString:valueString];
    
    //set the lineheight
    NSMutableParagraphStyle *p = [[NSMutableParagraphStyle alloc] init];
    p.alignment = NSTextAlignmentCenter;
    p.lineSpacing = 3;
    
    [titleString addAttribute:NSParagraphStyleAttributeName value:p range:NSMakeRange(0, titleString.length)];
    
    //setup the attributed text
    s.attributedText = titleString;

    return s;
}

-(void)openLeftSide {
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (transactions.count == 0)
        return 1;
    return transactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    if (cell == nil) {
        if (transactions.count == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transactionCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [UIView new];
            
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"transactionCell"];
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            cell.tintColor = neoGreenColor;
            
            
            UIView *selectionColor = [[UIView alloc] init];
            selectionColor.backgroundColor = neoGreenColor;
            cell.selectedBackgroundView = selectionColor;
            
            cell.textLabel.highlightedTextColor = [UIColor whiteColor];
            cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell"];
    }

    if (transactions.count == 0) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:14];
        cell.textLabel.text = NSLocalizedString(@"No transactions found", nil);
        
    } else {
        NSString *txid = [transactions[indexPath.row][@"txid"] substringToIndex:32];
        NSString *trxType;
        if ([[transactions[indexPath.row][@"gas_sent"] stringValue] isEqualToString:@"1"]) {
            trxType = @"GAS";
        } else {
            trxType = @"NEO";
        }
        
        NSNumber *trxAmount = @([transactions[indexPath.row][trxType] floatValue]);
        
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont fontWithName:FONT_LIGHT size:16];
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",trxType, [[NeodiusDataSource sharedData] formatNumber:trxAmount ofType:3 withFiatSymbol:@""]];
        cell.detailTextLabel.text = txid;
        cell.detailTextLabel.font = [UIFont fontWithName:FONT_LIGHT size:14];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tap called");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (transactions.count == 0)
        return;
        
        
    NSString *url = [NSString stringWithFormat:@"https://neotracker.io/tx/%@",transactions[indexPath.row][@"txid"]];

    webViewRoot = [[UIViewController alloc] init];
    [webViewRoot setTitle:NSLocalizedString(@"View transaction", nil)];
    webViewRoot.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[NeodiusDataSource sharedData] tableIconNegative:@"fa-times"]
                                                                                     style:UIBarButtonItemStyleDone
                                                                                    target:self
                                                                                    action:@selector(closeModal)];

    UIWebView *webView = [UIWebView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:url]]
                                         loaded:^(UIWebView *webView) {
                                             [MBProgressHUD hideHUDForView:webViewRoot.view animated:YES];
                                         }
                                         failed:^(UIWebView *webView, NSError *error) {
                                             NSLog(@"Failed loading %@", error);
                                         }];

    webViewRoot.view = webView;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:webViewRoot.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = NSLocalizedString(@"Loading transaction", nil);
    [hud showAnimated:YES];
    
    
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewRoot]
                                            animated:YES
                                          completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:FONT_LIGHT size:header.textLabel.font.pointSize];
}


-(void)closeModal {
    [webViewRoot dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
