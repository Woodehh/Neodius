//
//  walletManagementTableViewController.h
//  Neodius
//
//  Created by Benjamin de Bos on 17-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>
#import "FontAwesome4-ios.h"
#import "UIAlertView+Blocks.h"
#import "NeodiusDataSource.h"
#import "neodiusUIComponents.h"

@interface walletManagementTableViewController : UITableViewController <QRCodeReaderDelegate> {
    NSMutableArray *storedWallets;
    UIImage *editIcon,*doneIcon;
    UIBarButtonItem *editButton;
    NeodiusUIComponents *UIComponents;
}

@end
