//
//  menuTableViewController.h
//  Pods
//
//  Created by Benjamin de Bos on 16-09-17.
//
//

#import <UIKit/UIKit.h>
#import <ViewDeck/ViewDeck.h>
#import <RFAboutView/RFAboutViewController.h>
#import "FontAwesome4-ios.h"
#import "nodiusUIComponents.h"

@interface menuTableViewController : UITableViewController  {
    NSArray *storedWallets;
    NodiusUIComponents *UIComponents;
}

@end
