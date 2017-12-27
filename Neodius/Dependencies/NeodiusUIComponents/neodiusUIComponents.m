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

-(void)showQrModalOnViewController:(UIViewController*)viewController withAddress:(NSString*)address withTitle:(NSString*)title andShareMessage:(NSString*)shareString {
    
    tmpString = address;
    tmpShareString = shareString;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0, 280, 460)];
    v.layer.cornerRadius = 10.0f;
    v.backgroundColor = [UIColor whiteColor];
    tmpViewController = viewController;

    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, v.frame.size.width-40, 40)];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = ((title == nil) ? NSLocalizedString(@"Wallet address",nil) : title);
    lblTitle.adjustsFontSizeToFitWidth = YES;
    lblTitle.font = [UIFont fontWithName:FONT_LIGHT size:32];
    [v addSubview:lblTitle];

    UILabel *lbladdress = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, v.frame.size.width-40, 40)];
    lbladdress.textAlignment = NSTextAlignmentCenter;
    lbladdress.text = address;
    lbladdress.adjustsFontSizeToFitWidth = YES;;
    lbladdress.font = [UIFont fontWithName:FONT_LIGHT size:16];
    lbladdress.numberOfLines = 0;
    [v addSubview:lbladdress];

    UIImage *qrImage = [UIImage coro_createQRCodeWithText:address size:200];
    tmpImage = qrImage;
    UIImageView *qrHolder = [[UIImageView alloc] initWithFrame:CGRectMake(20, 110, 240, 240)];
    qrHolder.frame = CGRectMake(qrHolder.frame.origin.x,
                                qrHolder.frame.origin.y,
                                qrHolder.frame.size.width,
                                qrHolder.frame.size.height);

    qrHolder.image = qrImage;
    [v addSubview:qrHolder];

    NEOButton *btnCopy = [[NEOButton alloc]
                          initWithFrame:CGRectMake(20,360,v.frame.size.width-40,40)
                          withTitle:NSLocalizedString(@"Copy address",nil)
                          withIcon:FAIconClone
                          isPrimary:YES
                          ];
    [btnCopy addTarget:self action:@selector(copyToClipboardWithAddress) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btnCopy];
    
    NEOButton *btnShare = [[NEOButton alloc]
                          initWithFrame:CGRectMake(20,410,v.frame.size.width-40,40)
                          withTitle:NSLocalizedString(@"Share address",nil)
                          withIcon:FAIconClone
                          isPrimary:NO
                          ];
    [btnShare addTarget:self action:@selector(shareAddress) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btnShare];

    walletPopup = [KLCPopup popupWithContentView:v
                                        showType:KLCPopupShowTypeBounceInFromBottom
                                     dismissType:KLCPopupDismissTypeShrinkOut
                                        maskType:KLCPopupMaskTypeDimmed
                        dismissOnBackgroundTouch:YES
                           dismissOnContentTouch:NO];
    [walletPopup show];
}

-(void)shareAddress {
    [walletPopup dismiss:YES];
    
    NSString *publishString ;
    if (tmpShareString == nil) {
        publishString = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"This is the NEO address. Feel free to transfer some NEO or GAS! :)", nil),tmpString];
    } else {
        publishString = tmpShareString;
    }
    
    NSArray *activityItems = [NSArray arrayWithObjects:publishString, tmpImage, nil];
    UIActivityViewController * activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                          applicationActivities:nil];
    activityViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [tmpViewController presentViewController:activityViewController animated:YES completion:nil];

}

-(CGRect)calculateAutoHeightForField:(UILabel*)label andMaxWidth:(CGFloat)width {
    NSAttributedString *attributedText =    [[NSAttributedString alloc]
                                             initWithString:label.text
                                             attributes:@
                                             {
                                             NSFontAttributeName: label.font
                                             }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    CGRect labelFrame = label.frame;
    labelFrame.size.height = size.height;
    return labelFrame;
}

-(void)copyToClipboardWithAddress {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = tmpString;
    if ([[NeodiusDataSource sharedData] getShowMessages])  {
        CWStatusBarNotification *n = [CWStatusBarNotification new];
        n.notificationLabelBackgroundColor = neoGreenColor;
        n.notificationLabelTextColor = [UIColor whiteColor];
        [n displayNotificationWithMessage:NSLocalizedString(@"Address copied to clipboard", nil) forDuration:3];
    }
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
