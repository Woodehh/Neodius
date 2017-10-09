//
//  currencySettingsTableViewController.h
//  Neodius
//
//  Created by Benjamin de Bos on 16-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ViewDeck/ViewDeck.h>
#import "FontAwesome4-ios.h"
#import "NeodiusDataSource.h"

@interface selectionSettingsTableViewController : UITableViewController {
    NSDictionary *settingData;
    NSString *type,*currentlySelected,*sectionHeader;
    NSArray *settingDataKeys;
    
}

@property (nonatomic,retain) NSString* type;

@end
