//
//  settingsTableViewController.h
//  Nodius
//
//  Created by Benjamin de Bos on 16-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ViewDeck/ViewDeck.h>
#import <LTHPasscodeViewController/LTHPasscodeViewController.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <GSLanguagePickerController/GSLanguagePickerController.h>
#import "FontAwesome4-ios.h"
#import "NodiusDataSource.h"

@interface settingsTableViewController : UITableViewController {
    NSDictionary *baseFiat,*baseCrypto,*refreshInterval;
    UISwitch *securitySwitch, *touchIdSwitch, *showTimer, *showMessages, *useMainNet;
    NSBundle *localizationBundle;
    
}

@end
