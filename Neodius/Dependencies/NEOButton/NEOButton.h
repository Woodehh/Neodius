//
//  farmCompassButton.m
//  FarmCompass
//
//  Created by Benjamin de Bos on 22-05-17.
//  Copyright © 2017 Invoice.Farm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontAwesome4-ios.h"

@interface NEOButton : UIButton {
    UIColor *greenColor,*whiteColor;
    NSString *title;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)titleValue withIcon:(NSInteger)icon isPrimary:(BOOL)primary NS_DESIGNATED_INITIALIZER;
- (void)makePrimaryButton:(NEOButton*)button withIcon:(NSInteger)icon;
- (void)makeSecondaryButton:(NEOButton*)button withIcon:(NSInteger)icon;

@end
