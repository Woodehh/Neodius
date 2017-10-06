//
//  menuTableViewController.m
//  Pods
//
//  Created by Benjamin de Bos on 16-09-17.
//
//

#import "menuTableViewController.h"
#import "NeodiusDataSource.h"
#import "walletViewTableViewController.h"
#import "settingsTableViewController.h"
#import "marketInfoTableViewController.h"
#import "tipJarTableViewController.h"
#import "gasCalculationTableViewController.h"
#import "neoNewsTodayTableViewController.h"

@implementation menuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    self.tableView.tableHeaderView = [self headerView];
    storedWallets = [[NeodiusDataSource sharedData] getStoredWallets];
    UIComponents = [NeodiusUIComponents sharedComponents];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = neoGreenColor;
        cell.selectedBackgroundView = selectionColor;
    }
    
    NSString *icon;
    
    if (indexPath.section == 0) {
        if (indexPath.row >= storedWallets.count) {
            cell.textLabel.text = NSLocalizedString(@"Add wallet",nil);
            icon = @"fa-plus-circle";
        } else {
            cell.textLabel.text = storedWallets[indexPath.row][@"name"];
            icon = @"fa-folder-o";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Quick address lookup",nil);
            icon = @"fa-eye";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"GAS Calculation",nil),@"NEO"];
            icon = @"fa-calculator";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ Market information",nil),@"NEO"];
            icon = @"fa-line-chart";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ Market information",nil),@"GAS"];
            icon = @"fa-area-chart";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"NeoNewsToday";
            icon = @"fa-rss";
        } else if (indexPath.row == 5) {
            cell.textLabel.text = NSLocalizedString(@"Settings",nil);
            icon = @"fa-cog";
        } else if (indexPath.row == 6) {
            cell.textLabel.text = NSLocalizedString(@"Tip jar",nil);
            icon = @"fa-beer";
        } else if (indexPath.row == 7) {
            cell.textLabel.text = NSLocalizedString(@"About",nil);
            icon = @"fa-question-circle-o";
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Visit NEO.org",nil);
            icon = @"fa-rocket";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Visit NEO on Bittrex",nil);
            icon = @"fa-exchange";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Visit GAS on Poloniex",nil);
            icon = @"fa-bus";
        }
    }

    cell.imageView.image = [[NeodiusDataSource sharedData] tableIconPositive:icon];
    cell.imageView.highlightedImage = [[NeodiusDataSource sharedData] tableIconNegative:icon];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:header.textLabel.font.pointSize];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL close = YES;
    
    if (indexPath.section == 0) {
        if (indexPath.row >= storedWallets.count) {
            [UIComponents inputWalletInformationOnViewController:self
                                   withAddressAndName:YES
                                  WithCompletionBlock:^(bool addressEntered, NSString *walletName, NSString *walletAddress) {
                                      if (addressEntered) {
                                          if (![walletName isEqualToString:@""]) {         
                                              [[NeodiusDataSource sharedData] addNewWallet:walletName withAddress:walletAddress];
                                              storedWallets = [[NeodiusDataSource sharedData] getStoredWallets];
                                              [self.tableView reloadData];
                                          }
                                      }
                                      [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                                  }];
            
        } else {
            
            [self showWalletWithTitle:storedWallets[indexPath.row][@"name"]
                           andAddress:storedWallets[indexPath.row][@"address"]];
            
        }
        
        
    } else if (indexPath.section == 1) {
        
        
        UIViewController *menuItem;
        
        if (indexPath.row == 0) {
            close = NO;
            [UIComponents inputWalletInformationOnViewController:self
                                              withAddressAndName:NO
                                             WithCompletionBlock:^(bool addressEntered, NSString *walletName, NSString *walletAddress) {
                                                 if (addressEntered) {
                                                     if (![walletAddress isEqualToString:@""]) {
                                                         [self showWalletWithTitle:NSLocalizedString(@"Quick address lookup", nil)
                                                                        andAddress:walletAddress];
                                                     }
                                                 }
                                                 [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                                             }];
        } else if (indexPath.row == 1) {
            gasCalculationTableViewController *menuItem = [[gasCalculationTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            self.viewDeckController.centerViewController = [[UINavigationController alloc] initWithRootViewController:menuItem];
        } else if (indexPath.row == 2) {
            marketInfoTableViewController *menuItem = [[marketInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            menuItem.type = @"NEO";
            self.viewDeckController.centerViewController = [[UINavigationController alloc] initWithRootViewController:menuItem];
        } else if (indexPath.row == 3) {
            marketInfoTableViewController *menuItem = [[marketInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            menuItem.type = @"GAS";
            self.viewDeckController.centerViewController = [[UINavigationController alloc] initWithRootViewController:menuItem];
        } else if (indexPath.row == 4) {
            menuItem = [[neoNewsTodayTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            self.viewDeckController.centerViewController = [[UINavigationController alloc] initWithRootViewController:menuItem];
        } else if (indexPath.row == 5) {
            menuItem = [[settingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            self.viewDeckController.centerViewController = [[UINavigationController alloc] initWithRootViewController:menuItem];
        } else if (indexPath.row == 6) {
            menuItem = [[tipJarTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            self.viewDeckController.centerViewController = [[UINavigationController alloc] initWithRootViewController:menuItem];
        } else if (indexPath.row == 7) {
            RFAboutViewController* menuItem = [[RFAboutViewController alloc] initWithAppName:@"NEODIUS"
                                                                                  appVersion:nil
                                                                                    appBuild:nil
                                                                         copyrightHolderName:@"ITS-Vision"
                                                                                contactEmail:@"info@its-vision.nl"
                                                                               titleForEmail:NSLocalizedString(@"Contact us",nil)
                                                                                  websiteURL:[NSURL URLWithString:@"https://github.com/ITSVision"]
                                                                          titleForWebsiteURL:@"https://github.com/ITSVision"
                                                                          andPublicationYear:@"2017"];
            
            menuItem.closeButtonImage = [[NeodiusDataSource sharedData] tableIconPositive:@"fa-reorder"];
            menuItem.tintColor = [UIColor whiteColor];
            menuItem.navigationBarTintColor = [UIColor whiteColor];
            menuItem.navigationBarBarTintColor = neoGreenColor;
            menuItem.headerTextColor = [UIColor whiteColor];
            menuItem.headerBackgroundColor = neoGreenColor;
            menuItem.blurHeaderBackground = NO;
            menuItem.fontAppName = [UIFont fontWithName:@"HelveticaNeue-light" size:36];
            menuItem.leftBarButton = [[UIBarButtonItem alloc] initWithImage:[[NeodiusDataSource sharedData] tableIconPositive:@"fa-reorder"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(openLeftSide)];
            
            UINavigationController *c = [[UINavigationController alloc] initWithRootViewController:menuItem];
            
            self.viewDeckController.centerViewController = c;
        }
        
        if (close)
            [self.viewDeckController closeSide:YES];

    } else {
        if (indexPath.row == 0) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:@"http://neo.org"] options:@{} completionHandler:nil];
        } else if (indexPath.row == 1) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:@"https://bittrex.com/Market/Index?MarketName=BTC-NEO"] options:@{} completionHandler:nil];
            
        } else if (indexPath.row == 2) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:@"https://poloniex.com/exchange#btc_gas"] options:@{} completionHandler:nil];
        }
    }
}

-(void)showWalletWithTitle:(NSString*)title andAddress:(NSString*)address {
    walletViewTableViewController *wvtvc = [[walletViewTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    wvtvc.walletTitle = title;
    wvtvc.walletAddress = address;
    self.viewDeckController.centerViewController = [[UINavigationController alloc] initWithRootViewController:wvtvc];
    [self.viewDeckController closeSide:YES];
}

-(void)openLeftSide {
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
}

-(UIView*) headerView {
    UIView* headerview = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 200, 50)];
    UIImageView *menuLogo = [[UIImageView alloc] initWithFrame:headerview.frame];
    menuLogo.image = [UIImage imageNamed:@"imageMenu"];
    menuLogo.contentMode = UIViewContentModeScaleAspectFit;
    [headerview addSubview:menuLogo];
    
    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetKeychain)];
    t.numberOfTapsRequired = 20;
    [headerview addGestureRecognizer:t];
    
    return headerview;
}

-(void)resetKeychain {
    NSLog(@"Clearing keychain");
    [[NeodiusDataSource sharedData] resetKeychain];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return NSLocalizedString(@"Wallets",nil);
    if (section == 1)
        return NSLocalizedString(@"Tools",nil);
    
    return NSLocalizedString(@"Links",nil);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return storedWallets.count+1;
    else if (section == 1)
        return 8;
    else
        return 3;
}

@end
