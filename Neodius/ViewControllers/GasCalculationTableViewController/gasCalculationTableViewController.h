//
//  gasCalculationTableViewController.h
//  Neodius
//
//  Created by Benjamin de Bos on 27-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ViewDeck/ViewDeck.h>
#import "UIAlertView+Blocks.h"
#import "gasCalculationTableViewCell.h"
#import "NEOButton.h"
#import "neodiusUIComponents.h"
#import "neodiusDataSource.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <YCFirstTime/YCFirstTime.h>

@interface gasCalculationTableViewController : UITableViewController {
    CGFloat t_gas, a_gas, t_dividend, a_dividend;
    AFHTTPSessionManager *networkManager;
    NSNumber *neoAmount;
}

@end
