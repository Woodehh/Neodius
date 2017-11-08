//
//  currencySettingsTableViewController.m
//  Nodius
//
//  Created by Benjamin de Bos on 16-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "selectionSettingsTableViewController.h"

@implementation selectionSettingsTableViewController

@synthesize type = _type;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_type isEqualToString:@"fiat"]) {
        settingData = [[NodiusDataSource sharedData] getFiatData];
        currentlySelected = [[NodiusDataSource sharedData] getBaseFiat];
        self.title = NSLocalizedString(@"Base fiat currency",nil);
        sectionHeader = NSLocalizedString(@"Select currency",nil);
    } else if ([_type isEqualToString:@"crypto"]) {
        settingData = [[NodiusDataSource sharedData] getCryptoData];
        currentlySelected = [[NodiusDataSource sharedData] getBaseCrypto];
        self.title = NSLocalizedString(@"Base crypto currency",nil);
        sectionHeader = NSLocalizedString(@"Select crypto currency",nil);
    } else if ([_type isEqualToString:@"refreshInterval"]) {
        settingData = [[NodiusDataSource sharedData] getIntervalData];
        currentlySelected = [[NodiusDataSource sharedData] getRefreshInterval];
        self.title = NSLocalizedString(@"Refresh interval",nil);
        sectionHeader = NSLocalizedString(@"Select interval",nil);
    }
    //get currency keys and sort them
    settingDataKeys = [settingData.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = settingDataKeys[indexPath.row];
    
    for (int row = 0; row < [tableView numberOfRowsInSection:0]; row++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    UITableViewCell* checkCell = [tableView cellForRowAtIndexPath:indexPath];
    checkCell.accessoryType = UITableViewCellAccessoryCheckmark;

    if ([_type isEqualToString:@"fiat"]) {
        [[NodiusDataSource sharedData] setBaseFiat:key];
    } else if ([_type isEqualToString:@"crypto"]) {
        [[NodiusDataSource sharedData] setBaseCrypto:key];
    } else if ([_type isEqualToString:@"refreshInterval"]) {
        [[NodiusDataSource sharedData] setRefreshInterval:key];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return settingDataKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = settingDataKeys[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"menuCell"];
        cell.textLabel.font = [UIFont fontWithName:FONT_LIGHT size:16];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = neoGreenColor;
        cell.selectedBackgroundView = selectionColor;
        [cell setTintColor:neoGreenColor];
    }
    
    if ([_type isEqualToString:@"fiat"] || [_type isEqualToString:@"crypto"]) {
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",settingData[key][@"name"],settingData[key][@"symbol"]];
    } else if ([_type isEqualToString:@"refreshInterval"]) {
        
        NSString *labelValue = settingData[key][@"labelValue"];
        NSString *labelType = settingData[key][@"labelType"];

        cell.textLabel.text = [[NodiusDataSource sharedData] switchIntervalLabel:labelValue andType:labelType];
        
    }
    
    if ([settingData[key][@"id"] isEqualToString:currentlySelected])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:FONT_LIGHT size:header.textLabel.font.pointSize];
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sectionHeader;
}
        
@end
