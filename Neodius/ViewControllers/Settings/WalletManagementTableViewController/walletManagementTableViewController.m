//
//  walletManagementTableViewController.m
//  Neodius
//
//  Created by Benjamin de Bos on 17-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "walletManagementTableViewController.h"

@implementation walletManagementTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    storedWallets = [[NSMutableArray alloc] initWithArray:[[NeodiusDataSource sharedData] getStoredWallets]];
    self.title = NSLocalizedString(@"Wallet management", nil);
    
    editIcon = [UIImage imageWithIcon:@"fa-pencil"
                       backgroundColor:[UIColor clearColor]
                             iconColor:[UIColor redColor]
                             iconScale:1.0
                               andSize:CGSizeMake(24, 24)];
    
    
    doneIcon = [UIImage imageWithIcon:@"fa-check"
                      backgroundColor:[UIColor clearColor]
                            iconColor:[UIColor redColor]
                            iconScale:1.0
                              andSize:CGSizeMake(24, 24)];

    
    
    editButton = [[UIBarButtonItem alloc] initWithImage:editIcon
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(toggleTableEdit)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else
    return storedWallets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    
    if (cell == nil) {
        if (indexPath.section == 0)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"menuCell"];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"menuCell"];
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = neoGreenColor;
        cell.selectedBackgroundView = selectionColor;
        [cell setTintColor:neoGreenColor];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"Add wallet", nil);
        cell.imageView.image = [[NeodiusDataSource sharedData] tableIconPositive:@"fa-plus-circle"];
        cell.imageView.highlightedImage = [[NeodiusDataSource sharedData] tableIconNegative:@"fa-plus-circle"];
    } else {
        cell.textLabel.text = storedWallets[indexPath.row][@"name"];
        cell.detailTextLabel.text = storedWallets[indexPath.row][@"address"];
        cell.imageView.image = [[NeodiusDataSource sharedData] tableIconPositive:@"fa-folder-o"];
        cell.imageView.highlightedImage = [[NeodiusDataSource sharedData] tableIconNegative:@"fa-folder-o"];
        
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        [UIAlertView showWithTitle:nil
                           message:NSLocalizedString(@"Pick a method",nil)
                 cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                 otherButtonTitles:@[NSLocalizedString(@"By QR-Code",nil),NSLocalizedString(@"By entering an address",nil)]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              
                              if (buttonIndex == 1 || buttonIndex == 2) {
                                  
                                  //new wallet part
                                  UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add wallet",nil)
                                                                               message:NSLocalizedString(@"Enter a name and the address",nil)
                                                                              delegate:self
                                                                     cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                                                     otherButtonTitles:NSLocalizedString(@"Okay",nil), nil];
                                  
                                  //set to two fields
                                  av.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                                  [[av textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"Enter a name", nil)];
                                  [[av textFieldAtIndex:1] setSecureTextEntry:NO];
                                  [[av textFieldAtIndex:1] setPlaceholder:NSLocalizedString(@"Enter the address", nil)];
                                  av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
                                      if (buttonIndex == alertView.firstOtherButtonIndex) {
                                          [[NeodiusDataSource sharedData] addNewWallet:[alertView textFieldAtIndex:0].text
                                                                           withAddress:[alertView textFieldAtIndex:1].text];

                                          //reload the stored wallets
                                          storedWallets = (NSMutableArray*)[[NeodiusDataSource sharedData] getStoredWallets];
                                          [self.tableView reloadData];
                                      }
                                      [tableView deselectRowAtIndexPath:indexPath animated:YES];
                                  };
                                  
                                  
                                  if (buttonIndex == 1) {
                                      QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
                                      QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                                                                                                    codeReader:reader
                                                                                                           startScanningAtLoad:YES
                                                                                                        showSwitchCameraButton:YES
                                                                                                               showTorchButton:YES];
                                      vc.modalPresentationStyle = UIModalPresentationFormSheet;
                                      vc.delegate = self;
                                      [self presentViewController:vc animated:YES completion:nil];
                                      [reader setCompletionWithBlock:^(NSString *resultAsString) {
                                          [vc dismissViewControllerAnimated:YES completion:^{
                                              [[av textFieldAtIndex:1] setText:resultAsString];
                                              [av show];
                                          }];
                                          
                                      }];
                                  } else if (buttonIndex == 2) {
                                      [av show];
                                  }
                              }
                          }];
        
    } else {
        
        NSString *walletName = storedWallets[indexPath.row][@"name"];
        NSString *walletAddress = storedWallets[indexPath.row][@"address"];
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Edit wallet",nil)
                                                     message:NSLocalizedString(@"Enter a name and the address",nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                           otherButtonTitles:NSLocalizedString(@"Okay",nil), nil];
        
        //set to two fields
        av.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [[av textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"Enter a name", nil)];
        [av textFieldAtIndex:0].text = walletName;
        
        [[av textFieldAtIndex:1] setSecureTextEntry:NO];
        [[av textFieldAtIndex:1] setPlaceholder:NSLocalizedString(@"Enter the address", nil)];
        [av textFieldAtIndex:1].text = walletAddress;
        
        av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == alertView.firstOtherButtonIndex) {

                [[NeodiusDataSource sharedData] updateWalletAtIndex:indexPath.row
                                                          withName:[alertView textFieldAtIndex:0].text
                                                           andAddress:[alertView textFieldAtIndex:1].text];
                //reload the stored wallets
                storedWallets = (NSMutableArray*)[[NeodiusDataSource sharedData] getStoredWallets];
                [self.tableView reloadData];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        };
        [av show];
    }
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return NSLocalizedString(@"Add wallet", nil);
    return NSLocalizedString(@"Current wallets", nil);
}

-(void)toggleTableEdit {
    if (!super.editing) {
        editButton.image = doneIcon;
    } else {
        editButton.image = editIcon;
    }
    [super setEditing:!(self.tableView).editing animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1)
        return YES;
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *walletTitle = storedWallets[indexPath.row][@"name"];
        [UIAlertView showWithTitle:NSLocalizedString(@"Are you sure?", nil)
                           message:[NSString stringWithFormat:NSLocalizedString(@"You're about to remove %@. Are you sure?", nil),walletTitle]
                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                 otherButtonTitles:@[NSLocalizedString(@"Yes", nil)]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              if (buttonIndex == alertView.firstOtherButtonIndex) {
                                  [storedWallets removeObjectAtIndex:indexPath.row];
                                  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                  [[NeodiusDataSource sharedData] setStoredWallets:storedWallets];
                              }
                          }];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSDictionary *record = storedWallets[sourceIndexPath.row];
    [storedWallets removeObjectAtIndex:sourceIndexPath.row];
    [storedWallets insertObject:record atIndex:destinationIndexPath.row];
    [[NeodiusDataSource sharedData] setStoredWallets:storedWallets];
}



@end
