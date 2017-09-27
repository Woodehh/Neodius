//
//  walletViewTableViewController.h
//  Neodius
//
//  Created by Benjamin de Bos on 16-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <APParallaxHeader/UIScrollView+APParallaxHeader.h>
#import <ViewDeck/ViewDeck.h>
#import <FontAwesome4-ios/FontAwesome4-ios.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SGNavigationProgress/UINavigationController+SGProgress.h>
#import <Reachability/Reachability.h>
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import <ViewDeck/ViewDeck.h>
#import <UIWebView-Blocks/UIWebView+Blocks.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <YCFirstTime/YCFirstTime.h>
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import "NEOButton.h"
#import "NeodiusDataSource.h"
#import "neodiusUIComponents.h"


@interface walletViewTableViewController : UITableViewController <APParallaxViewDelegate> {
    UIView *customTableHeader;
    UILabel *neoLabel, *gasLabel,*fiatLabel, *baseCryptoLabel,*unclaimedGasLabel;
    NSNumber *neoAmount, *gasAmount,*fiatAmount, *btcAmount,*unclaimedGasAmount;
    NSNumber *cryptoValue;
    AFHTTPSessionManager *networkManager;
    MBProgressHUD *waiter;
    NSString *walletAddress;
    NSDictionary *baseCrypto,*baseFiat;
    NSArray *transactions;
    NSNumber *refreshInterval;
    BOOL firstNoInternet;
    UIView *addressPopup;
    KLCPopup* walletPopup;
    UIViewController *webViewRoot;
    
}

@property (nonatomic,retain) NSString *walletTitle, *walletAddress;


@end
