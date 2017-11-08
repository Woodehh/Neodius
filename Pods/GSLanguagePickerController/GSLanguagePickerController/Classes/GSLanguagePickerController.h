//
//  GSLanguagePickerController.h
//  GSLanguagePickerController
//
//  Created by gaosen on 01/23/2017.
//  Copyright (c) 2017 gaosen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSBundle+GSLanguage.h"

@interface GSLanguagePickerController : UITableViewController

@property BOOL useDoneButton;
@property (nonatomic, retain) UIColor *cellSelectedBackgroundColor, *cellSelectedFontColor,*cellTintColor;
@property (nonatomic, retain) UIFont *cellFont, *cellDetailFont;
@end
