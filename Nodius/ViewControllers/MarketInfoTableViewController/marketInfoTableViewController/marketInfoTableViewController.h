//
//  marketInfoTableViewController.h
//  Nodius
//
//  Created by Benjamin de Bos on 23-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ViewDeck/ViewDeck.h>
#import <AFNetworking/AFNetworking.h>
#import <MSSimpleGauge/MSAnnotatedGauge.h>
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import <Reachability/Reachability.h>
#import <SGNavigationProgress/UINavigationController+SGProgress.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "FontAwesome4-ios.h"
#import "NodiusDataSource.h"
#import "nodiusUIComponents.h"
#import "marketViewCustomTableViewCell.h"

@interface marketInfoTableViewController : UITableViewController {
    NSDictionary *baseCrypto,*baseFiat;
    NSArray *transactions;
    NSNumber *refreshInterval;
    BOOL firstNoInternet;
    AFHTTPSessionManager *networkManager;
    NSMutableArray *statsArray;
    NSNumber *cryptoFiatValue;
}

-(void)loadData;

@property (nonatomic,retain) NSString *type;

@end
