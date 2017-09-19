//
//  settingsTableViewController.h
//  Neodius
//
//  Created by Benjamin de Bos on 16-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ViewDeck/ViewDeck.h>
#import <FontAwesome4-ios/FontAwesome4-ios.h>
#import <LTHPasscodeViewController/LTHPasscodeViewController.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "NeodiusDataSource.h"

@interface settingsTableViewController : UITableViewController {
    NSDictionary *baseFiat,*baseCrypto,*refreshInterval;
    UISwitch *securitySwitch, *touchIdSwitch, *showTimer, *showMessages, *useMainNet;
}

@end
