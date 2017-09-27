//
//  menuTableViewController.h
//  Pods
//
//  Created by Benjamin de Bos on 16-09-17.
//
//

#import <UIKit/UIKit.h>
#import <FontAwesome4-ios/FontAwesome4-ios.h>
#import <RFAboutView/RFAboutViewController.h>
#import <ViewDeck/ViewDeck.h>
#import "neodiusUIComponents.h"

@interface menuTableViewController : UITableViewController  {
    NSArray *storedWallets;
    NeodiusUIComponents *UIComponents;
}

@end
