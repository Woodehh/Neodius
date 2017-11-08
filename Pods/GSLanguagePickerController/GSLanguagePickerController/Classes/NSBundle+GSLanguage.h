//
//  NSBundle+GSLanguage.h
//  GSLanguagePickerController
//
//  Created by gaosen on 01/23/2017.
//  Copyright (c) 2017 gaosen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const NSCurrentLocaleDidChangeNotification;

@interface NSBundle (GSLanguage)

+ (void)setDefaultLanguage:(NSString *)languageId;
+ (NSString *)defaultLanguage;

@end
