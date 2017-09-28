//
//  gasCalculationTableViewController.m
//  Neodius
//
//  Created by Benjamin de Bos on 27-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//



#import "gasCalculationTableViewController.h"

@implementation gasCalculationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"GAS Calculation", nil);
    UIImage *menuIcon = [[NeodiusDataSource sharedData] tableIconPositive:@"fa-reorder"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuIcon
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openLeftSide)];

    UIImage *calculatorIcon = [[NeodiusDataSource sharedData] tableIconPositive:@"fa-calculator"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:calculatorIcon
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(calculationSource)];

    
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionFooterHeight = 200;

    self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionFooterHeight = 200;

    //setup the request network manager
    networkManager = [AFHTTPSessionManager manager];

    neoAmount = @0;
    t_gas = 0;
    a_gas = 0;
    t_dividend = 0;
    a_dividend = 0;
    
    [[YCFirstTime shared] executeOnce:^{
        [UIAlertView showWithTitle:NSLocalizedString(@"Hey there!",nil)
                           message:NSLocalizedString(@"Tap the icon on the right upper side to enter the NEO amount to calculate!", nil)
                 cancelButtonTitle:NSLocalizedString(@"Cheers thanks!", nil)
                 otherButtonTitles:nil
                          tapBlock:nil];
    } forKey:@"neoGasCalculationFirstTimeMessagePopup"];

}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:header.textLabel.font.pointSize];
    header.textLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)calculationSource {
    [UIAlertView showWithTitle:nil
                       message:NSLocalizedString(@"What source would you like to have for the GAS Calculation?", nil)
             cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
             otherButtonTitles:@[NSLocalizedString(@"By entering an amount of NEO",nil),NSLocalizedString(@"By selecting a wallet",nil)]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == 1) {
                              [self showAmountInput];
                          } else if (buttonIndex == 2) {
                              [self showWalletSelection];
                          }
                      }];
}

-(void)showWalletSelection {
    
    NSArray* storedWallets = [[NeodiusDataSource sharedData] getStoredWallets];

    NSMutableArray *walletTitles = [[NSMutableArray alloc] init];
    for (id object in storedWallets) {
        [walletTitles addObject:[object objectForKey:@"name"]];
    }

    [UIAlertView showWithTitle:NSLocalizedString(@"Select wallet", nil)
                       message:nil
             cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
             otherButtonTitles:walletTitles
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex != alertView.cancelButtonIndex) {
                              [self calculateForWallet:[[storedWallets objectAtIndex:buttonIndex-1] objectForKey:@"address"]];
                          }
                      }];
}


-(void)calculateForWallet:(NSString*)walletAddress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [networkManager GET:[[NeodiusDataSource sharedData] buildAPIUrlWithEndpoint:[NSString stringWithFormat:@"/address/balance/%@",walletAddress]]
             parameters:nil
               progress:nil
                success:^(NSURLSessionTask *task, id responseObject) {
                    NSLog(@"%f",[responseObject[@"NEO"][@"balance"] floatValue]);
                    [self calculateWithAmount:[responseObject[@"NEO"][@"balance"] floatValue]];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
}

-(void)showAmountInput {
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter NEO Amount", nil)
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      otherButtonTitles:NSLocalizedString(@"Okay", nil),nil];
    
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [self calculateWithAmount:[[alertView textFieldAtIndex:0].text floatValue]];
        }
    };
    [av show];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:NSLocalizedString(@"Calculating GAS for: %@ NEO", nil),neoAmount];
}

-(void)calculateWithAmount:(float)amount {
    neoAmount = @(amount);
    t_gas = 0.0005 * amount;
    a_gas = 0.0002 * amount;
    t_dividend = 13.98;
    a_dividend = 5.58;
    [self.tableView reloadData];

}


-(void)openLeftSide {
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellName = @"tableCell";
    gasCalculationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[gasCalculationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }

    if (indexPath.row == 0) {
        cell.label1.text = NSLocalizedString(@"Time",nil);
        cell.label2.text = NSLocalizedString(@"Actual GAS",nil);;
        cell.label3.text = NSLocalizedString(@"Theoretical GAS",nil);;
        [cell isHeaderCell];
    } else if (indexPath.row == 1) {
        cell.label1.text = NSLocalizedString(@"Per day",nil);
        cell.label2.text = [NSString stringWithFormat:@"%f",t_gas];
        cell.label3.text = [NSString stringWithFormat:@"%f",a_gas];
    } else if (indexPath.row == 2) {
        cell.label1.text = NSLocalizedString(@"Per week",nil);
        cell.label2.text = [NSString stringWithFormat:@"%f",t_gas*7];
        cell.label3.text = [NSString stringWithFormat:@"%f",a_gas*7];
    } else if (indexPath.row == 3) {
        cell.label1.text = NSLocalizedString(@"Per month",nil);
        cell.label2.text = [NSString stringWithFormat:@"%f",t_gas*31];
        cell.label3.text = [NSString stringWithFormat:@"%f",a_gas*31];
    } else if (indexPath.row == 4) {
        cell.label1.text = NSLocalizedString(@"Per year",nil);
        cell.label2.text = [NSString stringWithFormat:@"%f",t_gas*365];
        cell.label3.text = [NSString stringWithFormat:@"%f",a_gas*365];
    } else if (indexPath.row == 5) {
        cell.label1.text = NSLocalizedString(@"Dividend",nil);
        cell.label2.text = [NSString stringWithFormat:@"%.1f%%",t_dividend];
        cell.label3.text = [NSString stringWithFormat:@"%.1f%%",a_dividend];
    }

    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(SIDE_MARGIN, 10, self.tableView.frame.size.width-(SIDE_MARGIN*2), 300)];
    UILabel *creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(footerView.frame.origin.x,
                                                                     20,
                                                                     footerView.frame.size.width,
                                                                     120)];
    creditLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    creditLabel.numberOfLines = 0;
    creditLabel.textAlignment = NSTextAlignmentCenter;
    creditLabel.text = NSLocalizedString(@"GAS Calculation has been brought to life by N1njaWTF of NeoToGas.com. Neodius' encourages you to tip some NEO/GAS to N1njaWTF for his awesome work!",nil);
    creditLabel.frame = [[NeodiusUIComponents sharedComponents] calculateAutoHeightForField:creditLabel andMaxWidth:creditLabel.frame.size.width];
    
    
    [footerView addSubview:creditLabel];
    
    NEOButton *btnDonate = [[NEOButton alloc] initWithFrame:CGRectMake(footerView.frame.origin.x,
                                                                       creditLabel.frame.origin.y+creditLabel.frame.size.height+20,
                                                                       footerView.frame.size.width,
                                                                       40)
                                                  withTitle:@"Tip N1njaWTF"
                                                   withIcon:FAIconThumbsUp
                                                  isPrimary:YES];
    [btnDonate addTarget:self action:@selector(showTipJar) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:btnDonate];

    NEOButton *btnVisit = [[NEOButton alloc] initWithFrame:CGRectMake(footerView.frame.origin.x,
                                                                       btnDonate.frame.origin.y+btnDonate.frame.size.height+10,
                                                                       footerView.frame.size.width,
                                                                       40)
                                                  withTitle:@"Visit NeoToGas.com"
                                                   withIcon:FAIconGlobe
                                                  isPrimary:NO];
    [btnVisit addTarget:self action:@selector(visitWebsite) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btnVisit];

    
    return footerView;
}




-(void)visitWebsite {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:@"https://neotogas.com"] options:@{} completionHandler:nil];

}

-(void)showTipJar {
    NSLog(@"called");
    [[NeodiusUIComponents sharedComponents] showQrModalOnViewController:self
                                                            withAddress:@"AbZiS1dhT2ciBMMRU7aScDC4johyMy35sA"
                                                              withTitle:@"N1njaWTF Tip jar"
                                                        andShareMessage:@"Tip N1njaWTF of NeoToGas.com some GAS or NEO! :-)"];
}

@end
