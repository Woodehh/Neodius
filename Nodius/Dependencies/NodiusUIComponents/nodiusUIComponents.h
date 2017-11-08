//
//  nodiusUIComponents.h
//  Nodius
//
//  Created by Benjamin de Bos on 27-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertView+Blocks.h"
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>
#import <KLCPopup/KLCPopup.h>
#import <QrcodeBuilder/QrcodeBuilder.h>
#import "CWStatusBarNotification.h"
#import <BDGShare/BDGShare.h>
#import "NEOButton.h"
#import "nodiusDataSource.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SIDE_MARGIN ((IS_IPAD) ? 180 : 15)
#define DIVIDER_MARGIN ((IS_IPAD) ? 10 : 10)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

#define FONT @"Lato"
#define FONT_LIGHT @"Lato-Light"

#define neoGreenColor [UIColor colorWithRed:0.29 green:0.72 blue:0.28 alpha:1.0]
#define neoGreenColorAlpha [[UIColor colorWithRed:0.29 green:0.72 blue:0.28 alpha:1.0] colorWithAlphaComponent:.5]

@interface NodiusUIComponents : NSObject <QRCodeReaderDelegate> {
    QRCodeReaderViewController *vc;
    NSString *tmpString,*tmpShareString;
    UIImage *tmpImage;
    UIViewController *tmpViewController;
    KLCPopup *walletPopup;
}

+ (NodiusUIComponents*)sharedComponents;


typedef void (^addNewWalletCompletionBlock)(bool addressEntered, NSString* walletName, NSString* walletAddress);
-(void)inputWalletInformationOnViewController:(UIViewController*)presentationView withAddressAndName:(BOOL)addressAndName WithCompletionBlock:(addNewWalletCompletionBlock)block;

-(void)showQrModalOnViewController:(UIViewController*)viewController withAddress:(NSString*)address withTitle:(NSString*)title andShareMessage:(NSString*)shareString;

-(CGRect)calculateAutoHeightForField:(UILabel*)label andMaxWidth:(CGFloat)width;


@end
