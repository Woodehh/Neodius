//
//  neoNewsTodayTableViewController.h
//  Nodius
//
//  Created by Benjamin de Bos on 05-10-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <XMLReader/XMLReader.h>
#import <ViewDeck/ViewDeck.h>
#import <KXHtmlLabel/KXHtmlLabel.h>
#import <Regexer/Regexer.h>
#import <AsyncImageView/AsyncImageView.h>
#import "UIWebView+Blocks.h"
#import "nodiusUIComponents.h"
//#import "ScrollableGraphView-Swift.h"

@interface neoNewsTodayTableViewController : UITableViewController {
    AFHTTPSessionManager *networkManager;
    MBProgressHUD *hud;
    NSArray *posts;
    UIViewController *webViewRoot;
}

@end
