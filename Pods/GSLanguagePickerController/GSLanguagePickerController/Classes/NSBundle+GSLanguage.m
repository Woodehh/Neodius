//
//  NSBundle+GSLanguage.m
//  GSLanguagePickerController
//
//  Created by gaosen on 01/23/2017.
//  Copyright (c) 2017 gaosen. All rights reserved.
//

#import "NSBundle+GSLanguage.h"
#import <objc/runtime.h>

NSString *const kDefaultLanguage = @"AppleLanguages";

@implementation NSBundle (GSLanguage)

+ (void)load {
#if DEBUG
    Method ori_Method = class_getInstanceMethod(NSBundle.class, @selector(localizedStringForKey:value:table:));
    Method my_Method = class_getInstanceMethod(NSBundle.class, @selector(runtimeLocalizedStringForKey:value:table:));
    method_exchangeImplementations(ori_Method, my_Method);
#endif
}

- (NSString *)runtimeLocalizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSString *lang = [NSBundle defaultLanguage];
    if (lang.length == 0) {
        lang = [self.preferredLocalizations firstObject];
    }
    
    NSString *langBundlePath = [self pathForResource:lang ofType:@"lproj"];
    
    // Try legacy lproj name (Used in UIKit.framework)
    if (!langBundlePath) {
        // Example: English.lproj French.lproj Spanish.lproj
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en"];
        NSString *displayName = [locale displayNameForKey:NSLocaleIdentifier value:lang];
        langBundlePath = [self pathForResource:displayName ofType:@"lproj"];
    }
    
    if (!langBundlePath) {
        // Example: zh_CN.lproj zh_HK.lproj en_GB.lproj
        // ⚠️ Use system region code
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:lang];
        NSString *region = [locale objectForKey:NSLocaleCountryCode] ?: [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        NSString *lang_region = [NSString stringWithFormat:@"%@_%@", [locale objectForKey:NSLocaleLanguageCode], region];
        langBundlePath = [self pathForResource:lang_region ofType:@"lproj"];
    }
    
    if (langBundlePath) {
        NSBundle *bundle = [NSBundle bundleWithPath:langBundlePath];
        return [bundle runtimeLocalizedStringForKey:key value:value table:tableName];
    } else {
        return [self runtimeLocalizedStringForKey:key value:value table:tableName];
    }
}

+ (void)setDefaultLanguage:(NSString *)languageId {
    [[NSUserDefaults standardUserDefaults] setObject:@[languageId ?: @""] forKey:kDefaultLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSCurrentLocaleDidChangeNotification object:languageId];
}

+ (NSString *)defaultLanguage {
    NSString *languageId = [[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultLanguage] objectAtIndex:0];
    return languageId;
}

@end
