//
//  marketGraphTableViewController.h
//  Neodius
//
//  Created by Benjamin de Bos on 13-10-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <DateTools/DateTools.h>
#import "NeodiusDataSource.h"
#import "neodiusUIComponents.h"
#import "BEMSimpleLineGraphView.h"
#import "marketGraphTableViewCell.h"

@interface marketGraphTableViewController : UITableViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate> {
    AFHTTPSessionManager *networkManager;
    NSArray *graphPoints;
    NSString *timeRange;
    NSArray *intervals;
    NSUInteger selectedInterval;

}
@property (nonatomic,retain) NSString *type;

@end
