//
//  AppDelegate.m
//  Neodius
//
//  Created by Benjamin de Bos on 16-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//
#import "AppDelegate.h"
#import "menuTableViewController.h"
#import "walletViewTableViewController.h"
#import "settingsTableViewController.h"
#import "NeodiusDataSource.h"
#import "marketInfoTableViewController.h"

@implementation AppDelegate
@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.35 green:0.75 blue:0.00 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:22]
                                                           }];
    
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    
    UIViewController *centerController = [[marketInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UIViewController *menuController = [[menuTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    //create navigation controller for center
    centerController = [[UINavigationController alloc] initWithRootViewController:centerController];
    
    //create viewdeck controller
    deckController = [[IIViewDeckController alloc] initWithCenterViewController:centerController leftViewController:menuController];

    self.window.rootViewController = deckController;
    
    [_window makeKeyAndVisible];

    [LTHPasscodeViewController useKeychain:YES];
    [[LTHPasscodeViewController sharedUser] setTouchIDString:@"Enter use TouchID to unlock Neodius"];
    [[LTHPasscodeViewController sharedUser] setBackgroundColor:[UIColor whiteColor]];
    [[LTHPasscodeViewController sharedUser] setBackgroundImage:[UIImage imageNamed:@"menuLogo"]];
    [[LTHPasscodeViewController sharedUser] setLabelTextColor:neoGreenColor];
    [[LTHPasscodeViewController sharedUser] setLabelFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    
    if ([LTHPasscodeViewController doesPasscodeExist]) {
        if ([LTHPasscodeViewController didPasscodeTimerEnd]) {
            [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:NO
                                                                     withLogout:NO
                                                                 andLogoutTitle:nil];
        }
    }
    
    
    
    return YES;
}




-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end

