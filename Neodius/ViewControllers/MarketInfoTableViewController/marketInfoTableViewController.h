//
//  marketInfoTableViewController.h
//  Neodius
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
#import "FontAwesome4-ios.h"
#import "NeodiusDataSource.h"
#import "marketViewCustomTableViewCell.h"

@interface marketInfoTableViewController : UITableViewController {
    NSDictionary *baseCrypto,*baseFiat;
    NSArray *transactions;
    NSNumber *refreshInterval;
    BOOL firstNoInternet;
    AFHTTPSessionManager *networkManager;
    NSMutableArray *statsArray;
    NSString *type;
    NSNumber *cryptoFiatValue;
}

@property (nonatomic,retain) NSString *type;

@end
