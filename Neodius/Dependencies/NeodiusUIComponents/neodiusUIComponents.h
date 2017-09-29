//
//  neodiusUIComponents.h
//  Neodius
//
//  Created by Benjamin de Bos on 27-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertView+Blocks.h"
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>
#import <KLCPopup/KLCPopup.h>
#import <QrcodeBuilder/QrcodeBuilder.h>
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import <BDGShare/BDGShare.h>
#import "NEOButton.h"
#import "neodiusDataSource.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SIDE_MARGIN ((IS_IPAD) ? 180 : 15)
#define DIVIDER_MARGIN ((IS_IPAD) ? 10 : 10)

@interface NeodiusUIComponents : NSObject <QRCodeReaderDelegate> {
    QRCodeReaderViewController *vc;
    NSString *tmpString,*tmpShareString;
    UIImage *tmpImage;
    UIViewController *tmpViewController;
    KLCPopup *walletPopup;
    
}



+ (NeodiusUIComponents*)sharedComponents;


typedef void (^addNewWalletCompletionBlock)(bool addressEntered, NSString* walletName, NSString* walletAddress);
-(void)inputWalletInformationOnViewController:(UIViewController*)presentationView withAddressAndName:(BOOL)addressAndName WithCompletionBlock:(addNewWalletCompletionBlock)block;

-(void)showQrModalOnViewController:(UIViewController*)viewController withAddress:(NSString*)address withTitle:(NSString*)title andShareMessage:(NSString*)shareString;

-(CGRect)calculateAutoHeightForField:(UILabel*)label andMaxWidth:(CGFloat)width;


@end
