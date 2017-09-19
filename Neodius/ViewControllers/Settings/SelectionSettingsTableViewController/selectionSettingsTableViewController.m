//
//  currencySettingsTableViewController.m
//  Neodius
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
        settingData = [[NeodiusDataSource sharedData] getFiatData];
        currentlySelected = [[NeodiusDataSource sharedData] getBaseFiat];
        self.title = NSLocalizedString(@"Base fiat currency",nil);
        sectionHeader = NSLocalizedString(@"Select currency",nil);
    } else if ([_type isEqualToString:@"crypto"]) {
        settingData = [[NeodiusDataSource sharedData] getCryptoData];
        currentlySelected = [[NeodiusDataSource sharedData] getBaseCrypto];
        self.title = NSLocalizedString(@"Base crypto currency",nil);
        sectionHeader = NSLocalizedString(@"Select crypto currency",nil);
    } else if ([_type isEqualToString:@"refreshInterval"]) {
        settingData = [[NeodiusDataSource sharedData] getIntervalData];
        currentlySelected = [[NeodiusDataSource sharedData] getRefreshInterval];
        self.title = NSLocalizedString(@"Refresh interval",nil);
        sectionHeader = NSLocalizedString(@"Select interval",nil);
    }
    //get currency keys and sort them
    settingDataKeys = [[settingData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [settingDataKeys objectAtIndex:indexPath.row];
    
    for (int row = 0; row < [tableView numberOfRowsInSection:0]; row++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    UITableViewCell* checkCell = [tableView cellForRowAtIndexPath:indexPath];
    checkCell.accessoryType = UITableViewCellAccessoryCheckmark;

    if ([_type isEqualToString:@"fiat"]) {
        [[NeodiusDataSource sharedData] setBaseFiat:key];
    } else if ([_type isEqualToString:@"crypto"]) {
        [[NeodiusDataSource sharedData] setBaseCrypto:key];
    } else if ([_type isEqualToString:@"refreshInterval"]) {
        [[NeodiusDataSource sharedData] setRefreshInterval:key];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [settingDataKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = [settingDataKeys objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"menuCell"];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = neoGreenColor;
        cell.selectedBackgroundView = selectionColor;
        [cell setTintColor:neoGreenColor];
    }
    
    if ([_type isEqualToString:@"fiat"] || [_type isEqualToString:@"crypto"]) {
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",[[settingData objectForKey:key] objectForKey:@"name"],[[settingData objectForKey:key] objectForKey:@"symbol"]];
    } else if ([_type isEqualToString:@"refreshInterval"]) {
        
        NSString *labelValue = [[settingData objectForKey:key] objectForKey:@"labelValue"];
        NSString *labelType = [[settingData objectForKey:key] objectForKey:@"labelType"];

        cell.textLabel.text = [[NeodiusDataSource sharedData] switchIntervalLabel:labelValue andType:labelType];
        
    }
    
    if ([[[settingData objectForKey:key] objectForKey:@"id"] isEqualToString:currentlySelected])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    return cell;
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sectionHeader;
}
        
@end
