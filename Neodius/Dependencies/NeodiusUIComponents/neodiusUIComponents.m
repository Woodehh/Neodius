//
//  neodiusUIComponents.m
//  Neodius
//
//  Created by Benjamin de Bos on 27-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "neodiusUIComponents.h"

@implementation NeodiusUIComponents

static NeodiusUIComponents *sharedComponents = nil;

+ (NeodiusUIComponents*)sharedComponents {
    if (sharedComponents == nil) {
        sharedComponents = [[super allocWithZone:NULL] init];
    }
    return sharedComponents;
}

-(void)inputWalletInformationOnViewController:(UIViewController*)presentationView
                           withAddressAndName:(BOOL)addressAndName
                          WithCompletionBlock:(addNewWalletCompletionBlock)block {
    [UIAlertView showWithTitle:nil
                       message:NSLocalizedString(@"Pick a method",nil)
             cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
             otherButtonTitles:@[NSLocalizedString(@"By QR-Code",nil),NSLocalizedString(@"By entering an address",nil)]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == alertView.cancelButtonIndex) {
                              //cancel pressed return no
                              block(NO,@"",@"");
                          } else {
                              
                              __block UIAlertView *av;
                              __block UITextField *name, *address;
                              
                              //otherwise: if buttonindex == 1 or two setup the things we need
                              if (buttonIndex == 1 || buttonIndex == 2) {
                                  if (addressAndName || buttonIndex == 2) {
                                      av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Address input",nil)
                                                                       message:NSLocalizedString(@"Enter a name and the address",nil)
                                                                      delegate:self
                                                             cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                                             otherButtonTitles:NSLocalizedString(@"Okay",nil), nil];
                                      
                                      
                                      if (addressAndName) {
                                          //set to two fields
                                          av.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                                          name = [av textFieldAtIndex:0];
                                          address = [av textFieldAtIndex:1];
                                      } else {
                                          //set single input
                                          av.alertViewStyle = UIAlertViewStylePlainTextInput;
                                          address = [av textFieldAtIndex:0];
                                      }
                                      //placeholders textviews etc
                                      name.placeholder = NSLocalizedString(@"Enter a name", nil);
                                      address.placeholder = NSLocalizedString(@"Enter the address", nil);
                                      address.secureTextEntry = NO;

                                      av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
                                          if (buttonIndex == alertView.firstOtherButtonIndex) {
                                              block(YES,name.text,address.text);
                                          } else {
                                              block(NO,nil,nil);
                                          }
                                      };
                                      if (buttonIndex == 2)
                                          [av show];
                                  }

                                  //if QRCOde is pressed we need to launch the QR Scanner
                                  if (buttonIndex == 1) {
                                    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
                                    vc = [QRCodeReaderViewController readerWithCancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                                                                      codeReader:reader
                                                                             startScanningAtLoad:YES
                                                                          showSwitchCameraButton:YES
                                                                                 showTorchButton:YES];
                                      
                                    vc.modalPresentationStyle = UIModalPresentationFormSheet;
                                    vc.delegate = self;
                                    [presentationView presentViewController:vc animated:YES completion:nil];
                                    [reader setCompletionWithBlock:^(NSString *resultAsString) {
                                        [vc dismissViewControllerAnimated:YES completion:^{
                                            if (addressAndName) {
                                                address.text = resultAsString;
                                                [av show];
                                            } else {
                                                block(YES,nil,resultAsString);
                                            }
                                        }];
                                    }];
                                  }
                              }
                          }
                      }
     ];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
