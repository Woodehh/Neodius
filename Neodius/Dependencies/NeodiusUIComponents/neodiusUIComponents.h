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

@interface NeodiusUIComponents : NSObject <QRCodeReaderDelegate> {
    QRCodeReaderViewController *vc;
}

+ (NeodiusUIComponents*)sharedComponents;


typedef void (^addNewWalletCompletionBlock)(bool addressEntered, NSString* walletName, NSString* walletAddress);
-(void)inputWalletInformationOnViewController:(UIViewController*)presentationView withAddressAndName:(BOOL)addressAndName WithCompletionBlock:(addNewWalletCompletionBlock)block;




@end
