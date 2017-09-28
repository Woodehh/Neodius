//
//  tipJarTableViewController.m
//  Neodius
//
//  Created by Benjamin de Bos on 27-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "tipJarTableViewController.h"

@implementation tipJarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *menuIcon = [[NeodiusDataSource sharedData] tableIconPositive:@"fa-reorder"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuIcon
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openLeftSide)];
    self.title = NSLocalizedString(@"Tip jar", nil);
    tipJars = [[NeodiusDataSource sharedData] getDonationData];
}

-(void)openLeftSide {
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tipJars.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];

        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = neoGreenColor;
        cell.selectedBackgroundView = selectionColor;

        UILabel *cryptoTitle = [[UILabel alloc]init];
        cryptoTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        cryptoTitle.frame = CGRectMake(0, 10, self.tableView.frame.size.width, 40);
        cryptoTitle.textAlignment = NSTextAlignmentCenter;
        cryptoTitle.contentMode = UIViewContentModeScaleAspectFit;
        cryptoTitle.tag = 1;
        cryptoTitle.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:cryptoTitle];
        
        UIImageView *logoView = [[UIImageView alloc]init];
        logoView.frame = CGRectMake(0, cryptoTitle.frame.origin.x + cryptoTitle.frame.size.height + 15, self.tableView.frame.size.width, 70);
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        logoView.tag = 2;
        [cell.contentView addSubview:logoView];

        UILabel *cryptoAddress = [[UILabel alloc]init];
        cryptoAddress.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        cryptoAddress.frame = CGRectMake(0, logoView.frame.origin.x + logoView.frame.size.height + 60, self.tableView.frame.size.width, 40);
        cryptoAddress.textAlignment = NSTextAlignmentCenter;
        cryptoAddress.contentMode = UIViewContentModeScaleAspectFit;
        cryptoAddress.tag = 3;
        cryptoAddress.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:cryptoAddress];
    }

    
    [(UILabel*)[cell viewWithTag:1] setText:[NSString stringWithFormat:NSLocalizedString(@"Donate %@", nil),[[tipJars objectAtIndex:indexPath.section] objectForKey:@"name"]]];
    [(UIImageView*)[cell viewWithTag:2] setImage:[UIImage imageNamed:[[tipJars objectAtIndex:indexPath.section] objectForKey:@"image"]]];
    [(UILabel*)[cell viewWithTag:3] setText:[[tipJars objectAtIndex:indexPath.section] objectForKey:@"address"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *name = [[tipJars objectAtIndex:indexPath.section] objectForKey:@"name"];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Donate %@", nil),name];
    
    NSString *address = [[tipJars objectAtIndex:indexPath.section] objectForKey:@"address"];
    NSString *shareMessage = [NSString stringWithFormat:NSLocalizedString(@"Feel free to send some %@ in order to make support the Neodius development! :-)", nil), name];
    shareMessage = [shareMessage stringByAppendingString:[NSString stringWithFormat:@" %@",address]];
    
    [[NeodiusUIComponents sharedComponents] showQrModalOnViewController:self
                                                            withAddress:address
                                                              withTitle:title
                                                        andShareMessage:shareMessage];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:header.textLabel.font.pointSize];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}
@end
