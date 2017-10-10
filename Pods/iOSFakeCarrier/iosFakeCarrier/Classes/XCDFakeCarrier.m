//
// Copyright (c) 2012-2013 Cédric Luthi / @0xced. All rights reserved.
//

// Adapted from https://gist.github.com/0xced/3035167 to allow modifying signal strength and other symbols
// Adapted from https://github.com/ksuther/StatusBarCustomization.git


//#warning Fake carrier enabled - disable it from production build!

static const char *fakeCarrier;
static const char *fakeTime;
static int fakeCellSignalStrength = -1;
static int fakeWifiStrength = 3; // default to full strength
static int fakeDataNetwork = 5; // default to Wi-Fi



#import "XCDFakeCarrier.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static NSString* fakeCarrierS;
static NSString* fakeTimeS;


static NSMutableDictionary *fakeItemIsEnabled;

static NSUInteger timeStringOffset;
static NSUInteger timeStringSize;
static NSUInteger gsmSignalStrengthBarsOffset;
static NSUInteger gsmSignalStrengthBarsSize;
static NSUInteger serviceStringOffset;
static NSUInteger serviceStringSize;


@implementation XCDFakeCarrier


+(void)setLocalizedStatusBarWithTime:(NSDateComponents*)time {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* dateTime = [calendar dateFromComponents:time];
    [self setFakeTime:[NSDateFormatter localizedStringFromDate:dateTime dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self setNetworkType:8];
        [self setFakeCarrier:@"iPad"];
        [self setWiFiStrength:3];
    } else {
        [self setFakeCarrier:NSLocalizedStringFromTableInBundle(@"fakeCarrier", @"FakeiOSLocalized", [self bundle], @"")];
        [self setNetworkType:2];
        [self setCellStrength:5];
    }

}

+ (NSBundle *)bundle
{
    NSBundle *bundle;

    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"iosFakeCarrier" withExtension:@"bundle"];
    if (!bundleUrl) {
      bundleUrl = [[NSBundle bundleForClass:XCDFakeCarrier.class] URLForResource:@"iosFakeCarrier" withExtension:@"bundle"];
    }
    if (bundleUrl) {
        // Should be, when using cocoapods
        bundle = [NSBundle bundleWithURL:bundleUrl];
    } else {
        bundle = [NSBundle mainBundle];
    }
    return bundle;
}


+ (void)setCellStrength:(int)cellStrength
{
    fakeCellSignalStrength = cellStrength;
    [self updateStatusbarView];
}

+ (void)setWiFiStrength:(int)wifiStrength
{
    fakeWifiStrength = wifiStrength;
    [self updateStatusbarView];
}

+ (void)setNetworkType:(int)networkType
{
    fakeDataNetwork = networkType;
    [self updateStatusbarView];
}

+ (void)setEnabled:(BOOL)enabled atIndex:(NSInteger)index
{
    [fakeItemIsEnabled setObject:@(enabled) forKey:@(index)];
    [self updateStatusbarView];
}

+(void)setFakeCarrier:(NSString*) newCarrier {
    fakeCarrierS = newCarrier;
    [self updateStatusbarView];
}

+(void)setFakeTime:(NSString*) newFakeTime {
    fakeTimeS = newFakeTime;
    [self updateStatusbarView];
}

+(void)updateStatusbarView {
    [[UIApplication sharedApplication].keyWindow.rootViewController setNeedsStatusBarAppearanceUpdate];
}



+ (void) load
{
    fakeCarrier = "Vodafone";
    if (!fakeCarrier)
    {
        NSLog(@"You must set the FAKE_CARRIER environment variable");
        return;
    }
    fakeTime = "9:41";
    
    const Class UIStatusBarComposedData = objc_getClass("UIStatusBarComposedData");
    const Method rawData = class_getInstanceMethod(UIStatusBarComposedData, sel_getUid("rawData"));
    const char *typeEncoding = method_getTypeEncoding(rawData);
    
    if (typeEncoding)
    {
        NSRegularExpression *typeEncodingRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\^(\\{\\?=\\[\\d+[Bc]\\]\\[\\d+c\\]ii\\[\\d+c\\])" options:(NSRegularExpressionOptions)0 error:NULL];
        NSString *typeEncodingString = @(typeEncoding);
        NSTextCheckingResult *typeEncodingMatch = [typeEncodingRegularExpression firstMatchInString:typeEncodingString options:(NSMatchingOptions)0 range:NSMakeRange(0, typeEncodingString.length)];
        if (typeEncodingMatch.numberOfRanges > 1)
        {
            NSString *partialTypeEncoding = [[typeEncodingString substringWithRange:[typeEncodingMatch rangeAtIndex:1]] stringByAppendingString:@"}"];
            NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:partialTypeEncoding.UTF8String];
            NSString *parsedTypeEncoding = methodSignature.debugDescription;
            NSRegularExpression *parsedTypeEncodingRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"^            memory \\{offset = (\\d+), size = (\\d+)\\}" options:NSRegularExpressionAnchorsMatchLines error:NULL];
            NSArray<NSTextCheckingResult *> *offsetMatches = [parsedTypeEncodingRegularExpression matchesInString:parsedTypeEncoding options:(NSMatchingOptions)0 range:NSMakeRange(0, parsedTypeEncoding.length)];
            if (offsetMatches.count == 5)
            {
                timeStringOffset =            [[parsedTypeEncoding substringWithRange:[offsetMatches[1] rangeAtIndex:1]] integerValue];
                timeStringSize =              [[parsedTypeEncoding substringWithRange:[offsetMatches[1] rangeAtIndex:2]] integerValue];
                gsmSignalStrengthBarsOffset = [[parsedTypeEncoding substringWithRange:[offsetMatches[3] rangeAtIndex:1]] integerValue];
                gsmSignalStrengthBarsSize =   [[parsedTypeEncoding substringWithRange:[offsetMatches[3] rangeAtIndex:2]] integerValue];
                serviceStringOffset =         [[parsedTypeEncoding substringWithRange:[offsetMatches[4] rangeAtIndex:1]] integerValue];
                serviceStringSize =           [[parsedTypeEncoding substringWithRange:[offsetMatches[4] rangeAtIndex:2]] integerValue];
                
                BOOL isTimeStringOK = timeStringOffset > 0 && timeStringSize > 0;
                BOOL isSignalStrengthBarsOK = gsmSignalStrengthBarsOffset > 0 && gsmSignalStrengthBarsSize == sizeof(int);
                BOOL isServiceStringOK = serviceStringOffset > 0 && serviceStringSize > 0;
                if (isTimeStringOK && isSignalStrengthBarsOK && isServiceStringOK)
                {
                    const SEL fakeSelector = @selector(fake_rawData);
                    const Method fakeRawData = class_getInstanceMethod(self, fakeSelector);
                    if (class_addMethod(UIStatusBarComposedData, fakeSelector, method_getImplementation(fakeRawData), typeEncoding))
                    {
                        method_exchangeImplementations(rawData, class_getInstanceMethod(UIStatusBarComposedData, fakeSelector));
                        NSLog(@"Using \"%s\" fake carrier", fakeCarrier);
                        return;
                    }
                }
            }
        }
    }
    
    NSLog(@"XCDFakeCarrier failed to initialize");
}







/*
+ (void)load
{

#if TARGET_IPHONE_SIMULATOR

    fakeCarrier = "Carrier";
    fakeTime = "10:21 AM";

    fakeItemIsEnabled = [[NSMutableDictionary alloc] init];

    BOOL __block success = NO;
    Class UIStatusBarComposedData = objc_getClass("UIStatusBarComposedData");
    SEL selector = NSSelectorFromString(@"rawData");
    Method method = class_getInstanceMethod(UIStatusBarComposedData, selector);
    NSDictionary *statusBarDataInfo = @{ @"^{?=[25c][64c]ii[100c]": @"fake_rawData",
                                         @"^{?=[24c][64c]ii[100c]": @"fake_rawData",
                                         @"^{?=[23c][64c]ii[100c]": @"fake_rawData",
                                         // use B instead of c for 64-bit
                                         @"^{?=[25B][64c]ii[100c]": @"fake_rawData" };
    [statusBarDataInfo enumerateKeysAndObjectsUsingBlock:^(NSString *statusBarDataTypeEncoding, NSString *fakeSelectorString, BOOL *stop) {
        if (method && [@(method_getTypeEncoding(method)) hasPrefix:statusBarDataTypeEncoding])
        {
            SEL fakeSelector = NSSelectorFromString(fakeSelectorString);
            Method fakeMethod = class_getInstanceMethod(self, fakeSelector);
            success = class_addMethod(UIStatusBarComposedData, fakeSelector, method_getImplementation(fakeMethod), method_getTypeEncoding(fakeMethod));
            fakeMethod = class_getInstanceMethod(UIStatusBarComposedData, fakeSelector);
            method_exchangeImplementations(method, fakeMethod);
        }
    }];

    if (success)
        NSLog(@"Fake carrier enabled - don't forgot to disable it in production build!");
    else
        NSLog(@"XCDFakeCarrier failed to initialize");
#endif
}
*/


- (void *) fake_rawData
{
    char *rawData = [self fake_rawData];
    
    fakeCarrier = [fakeCarrierS UTF8String];
    fakeTime = [fakeTimeS UTF8String];
    
    BOOL isEmptyCarrier = [@(fakeCarrier ?: "") stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
    BOOL isEmptyTime = [@(fakeTime ?: "") stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
    
    if (isEmptyCarrier && isEmptyTime)
    {
        bzero(rawData, serviceStringOffset + serviceStringSize);
        return rawData;
    }
    
    strlcpy(rawData + serviceStringOffset, fakeCarrier, serviceStringSize);
    
    if (fakeTime)
        strlcpy(rawData + timeStringOffset, fakeTime, timeStringSize);
    
    int gsmSignalStrengthBars = 5;
    memcpy(rawData + gsmSignalStrengthBarsOffset, &gsmSignalStrengthBars, gsmSignalStrengthBarsSize);
    
    BOOL enableSignalBars = YES;
    memcpy(rawData + 3, &enableSignalBars, sizeof(enableSignalBars));
    
    BOOL enableBatteryLevelPercentage = YES;
    memcpy(rawData + 8, &enableBatteryLevelPercentage, sizeof(enableBatteryLevelPercentage));
    
    /*
     0  center  Time
     1  right   Do not Sisturb
     2  left    Airplane
     3  left    Signal Bars
     4  left    Carrier
     5  left    Wi-Fi
     6  right   Time
     7  right   Battery Logo
     8  right   Battery Level Percentage
     9  right   Battery Level Percentage
     10  right   Bluetooth Battery
     11  right   Bluetooth
     12  right   TTY
     13  right   Alarm
     14  right   Plus
     15          unknown
     16  right   Location Service
     17  right   Rotation Lock
     18          unknown
     19  right   AirPlay
     20  right   Siri
     21  left    Play
     22  left    VPN
     23  left    Call Forward
     24  left    Network Activity Indicator
     25  left    Black Square
     */
    return rawData;
}


@end
