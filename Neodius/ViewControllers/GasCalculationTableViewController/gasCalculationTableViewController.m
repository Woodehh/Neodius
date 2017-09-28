//
//  gasCalculationTableViewController.m
//  Neodius
//
//  Created by Benjamin de Bos on 27-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "gasCalculationTableViewController.h"

@implementation gasCalculationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"GAS Calculation", nil);
    UIImage *menuIcon = [[NeodiusDataSource sharedData] tableIconPositive:@"fa-reorder"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuIcon
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openLeftSide)];
    self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionFooterHeight = 200;
}

//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:header.textLabel.font.pointSize+2];
//    header.textLabel.textAlignment = NSTextAlignmentCenter;
//}


-(void)openLeftSide {
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellName = @"tableCell";
    gasCalculationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[gasCalculationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    CGFloat t_gas = 0.9769, a_gas = 0.4129, t_dividend = 13.98, a_dividend = 5.58;
    
    if (indexPath.row == 0) {
        cell.label1.text = NSLocalizedString(@"Time",nil);
        cell.label2.text = NSLocalizedString(@"Actual GAS",nil);;
        cell.label3.text = NSLocalizedString(@"Theoretical GAS",nil);;
        [cell isHeaderCell];
    } else if (indexPath.row == 1) {
        cell.label1.text = NSLocalizedString(@"Per day",nil);
        cell.label2.text = [NSString stringWithFormat:@"%f",t_gas];
        cell.label3.text = [NSString stringWithFormat:@"%f",a_gas];
    } else if (indexPath.row == 2) {
        cell.label1.text = NSLocalizedString(@"Per week",nil);
        cell.label2.text = [NSString stringWithFormat:@"%f",t_gas*7];
        cell.label3.text = [NSString stringWithFormat:@"%f",a_gas*7];
    } else if (indexPath.row == 3) {
        cell.label1.text = NSLocalizedString(@"Per month",nil);
        cell.label2.text = [NSString stringWithFormat:@"%f",t_gas*31];
        cell.label3.text = [NSString stringWithFormat:@"%f",a_gas*31];
    } else if (indexPath.row == 4) {
        cell.label1.text = NSLocalizedString(@"Per year",nil);
        cell.label2.text = [NSString stringWithFormat:@"%f",t_gas*365];
        cell.label3.text = [NSString stringWithFormat:@"%f",a_gas*365];
    } else if (indexPath.row == 5) {
        cell.label1.text = NSLocalizedString(@"Dividend",nil);
        cell.label2.text = [NSString stringWithFormat:@"%.1f%%",t_dividend];
        cell.label3.text = [NSString stringWithFormat:@"%.1f%%",a_dividend];
    }
    
    //if (indexPath.row == 0)
        //[cell setIsHeader];

    
 
    
    // Configure the cell...
    
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, self.tableView.frame.size.width-30, 300)];
    UILabel *creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, footerView.frame.size.width, 120)];
    creditLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    creditLabel.numberOfLines = 0;
    creditLabel.textAlignment = NSTextAlignmentCenter;
    creditLabel.text = @"GAS Calculation has been brought to life by N1njaWTF of NeoToGas.com. Neodius' encourages you to tip some NEO/GAS to N1njaWTF for his awesome work!";
    [creditLabel sizeToFit];
    [footerView addSubview:creditLabel];
    
    NEOButton *btnDonate = [[NEOButton alloc] initWithFrame:CGRectMake(15,
                                                                       creditLabel.frame.origin.x+creditLabel.frame.size.height+25,
                                                                       footerView.frame.size.width,
                                                                       40)
                                                  withTitle:@"Tip N1njaWTF"
                                                   withIcon:FAIconThumbsUp
                                                  isPrimary:YES];
    [btnDonate addTarget:self action:@selector(showTipJar) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:btnDonate];

    NEOButton *btnVisit = [[NEOButton alloc] initWithFrame:CGRectMake(15,
                                                                       creditLabel.frame.origin.x+creditLabel.frame.size.height+70,
                                                                       footerView.frame.size.width,
                                                                       40)
                                                  withTitle:@"Visit NeoToGas.com"
                                                   withIcon:FAIconGlobe
                                                  isPrimary:NO];
    [btnVisit addTarget:self action:@selector(visitWebsite) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btnVisit];

    
    return footerView;

}

-(void)visitWebsite {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:@"https://neotogas.com"] options:@{} completionHandler:nil];

}

-(void)showTipJar {
    NSLog(@"called");
    [[NeodiusUIComponents sharedComponents] showQrModalOnViewController:self
                                                            withAddress:@"AbZiS1dhT2ciBMMRU7aScDC4johyMy35sA"
                                                              withTitle:@"N1njaWTF Tip jar"
                                                        andShareMessage:@"Tip N1njaWTF of NeoToGas.com some GAS or NEO! :-)"];
}

@end
