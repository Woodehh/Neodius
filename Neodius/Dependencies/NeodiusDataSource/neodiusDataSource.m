//
//  globalVars.m
//  Artez V2.0
//
//  Created by Benjamin de Bos on 09-05-13.
//  Copyright (c) 2013 GMoledina.ca. All rights reserved.
//

#import "neodiusDataSource.h"


@implementation NeodiusDataSource

static NeodiusDataSource *sharedData = nil;

+ (NeodiusDataSource*)sharedData {
    if (sharedData == nil) {
        sharedData = [[super allocWithZone:NULL] init];
    }
    return sharedData;
}


-(NSString*)buildAPIUrlWithEndpoint:(NSString*)property {
    
    NSString *apiLocation;
    
    if ([self getUseMainNet])
        apiLocation = @"http://api.wallet.cityofzion.io/v2%@";
    else
        apiLocation = @"http://testnet-api.wallet.cityofzion.io/v2%@";

    return [NSString stringWithFormat:apiLocation,property];
}

//Preference management
//setters
-(void)savePreferenceForKey:(NSString*)key andValue:(NSString*)value {
    [[A0SimpleKeychain keychain] setString:value forKey:key];
}
//getters
-(NSString*)getPreferenceForKey:(NSString*)key {
    if ([[A0SimpleKeychain keychain] stringForKey:key] == nil)
    return @"";
    return [[A0SimpleKeychain keychain] stringForKey:key];
}

//Cache loader function
-(NSDictionary*)loadCacheForJsonFile:(NSString*)file{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@"json"]];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
}

//Load the caches
//get crypto prefs
-(NSDictionary*)getCryptoData {
    return [self loadCacheForJsonFile:@"cryptoCurrencies"];
}
//get fiat prefs
-(NSDictionary*)getFiatData {
    return [self loadCacheForJsonFile:@"fiatCurrencies"];
}
//get refreshintervals
-(NSDictionary*)getIntervalData {
    return [self loadCacheForJsonFile:@"refreshIntervals"];
}




//Fiat management
//setter for base fiat
-(void)setBaseFiat:(NSString *)selectedBaseFiat {
    [self savePreferenceForKey:@"selectedBaseFiat" andValue:selectedBaseFiat];
}
//getter for base fiat
-(NSString*)getBaseFiat {
    NSString *s = [self getPreferenceForKey:@"selectedBaseFiat"];
    if ([s isEqualToString:@""])
        return @"USD";
    return s;
}

//Crypto management
//setter for base crypto
-(void)setBaseCrypto:(NSString *)selectedBaseCrypto {
    [self savePreferenceForKey:@"selectedBaseCrypto" andValue:selectedBaseCrypto];
}
//getter for base crypto
-(NSString*)getBaseCrypto {
    NSString *s = [self getPreferenceForKey:@"selectedBaseCrypto"];
    if ([s isEqualToString:@""])
        return @"BTC";
    return s;
}

//Wallet management
//getter for wallets
-(NSArray*)getStoredWallets {
    NSData *storedWalletData = [[A0SimpleKeychain keychain] dataForKey:@"storedWallets"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:storedWalletData];
}
//setter for wallets
-(void)setStoredWallets:(NSArray*)wallets {
    [[A0SimpleKeychain keychain] setData:[NSKeyedArchiver archivedDataWithRootObject:wallets] forKey:@"storedWallets"];
}
//add new wallet
-(void)addNewWallet:(NSString*)name withAddress:(NSString*)address {
    NSMutableArray *_tmpWallets = [[NSMutableArray alloc] initWithArray:[self getStoredWallets]];
    [_tmpWallets addObject:@{@"name": name, @"address" : address}];
    [self setStoredWallets:_tmpWallets];
}

-(void)updateWalletAtIndex:(NSUInteger)index withName:(NSString*)name andAddress:(NSString*)address {
    NSMutableArray *_tmpWallets = [[NSMutableArray alloc] initWithArray:[self getStoredWallets]];
    [_tmpWallets replaceObjectAtIndex:index withObject:@{@"name":name,@"address":address}];
    [[NeodiusDataSource sharedData] setStoredWallets:(NSArray*)_tmpWallets];
}

//Crypto management
//setter for base crypto
-(void)setRefreshInterval:(NSString *)refreshInterval {
    [self savePreferenceForKey:@"selectedRefreshInterval" andValue:refreshInterval];
}

//getter for refresh interval
-(NSString*)getRefreshInterval {
    NSString *s = [self getPreferenceForKey:@"selectedRefreshInterval"];
    if ([s isEqualToString:@""])
        return @"10";
    return [self getPreferenceForKey:@"selectedRefreshInterval"];
}

//timer preferences
//setter for timer show
-(void)setShowTimer:(BOOL)showTimer {
    [self savePreferenceForKey:@"showTimer" andValue:((showTimer) ? @"1" : @"0")];
}
//getter for timer show
-(BOOL)getShowTimer {
    NSString *s = [self getPreferenceForKey:@"showTimer"];
    if ([s isEqualToString:@""]) {
        return YES;
    } else {
        return (([[self getPreferenceForKey:@"showTimer"] isEqualToString:@"1"]) ? YES : NO);
    }
}

//show messages prefs
//getter for show messages
-(void)setShowMessages:(BOOL)showMessages {
    [self savePreferenceForKey:@"showMessages" andValue:((showMessages) ? @"1" : @"0")];
}
//setter for show messages
-(BOOL)getShowMessages {
    NSString *s = [self getPreferenceForKey:@"showMessages"];
    if ([s isEqualToString:@""]) {
        return YES;
    } else {
        return (([[self getPreferenceForKey:@"showMessages"] isEqualToString:@"1"]) ? YES : NO);
    }
}


//show messages prefs
//getter for show messages
-(void)setUseMainNet:(BOOL)mainNet {
    [self savePreferenceForKey:@"useMainNet" andValue:((mainNet) ? @"1" : @"0")];
}
//setter for show messages
-(BOOL)getUseMainNet {
    NSString *s = [self getPreferenceForKey:@"useMainNet"];
    if ([s isEqualToString:@""]) {
        return YES;
    } else {
        return (([[self getPreferenceForKey:@"useMainNet"] isEqualToString:@"1"]) ? YES : NO);
    }
}





//icon creator
-(UIImage*)tableIconNegative:(NSString*)icon  {
    return [UIImage imageWithIcon:icon
                  backgroundColor:[UIColor clearColor]
                        iconColor:[UIColor whiteColor]
                        iconScale:1.0
                          andSize:CGSizeMake(24, 24)];
}

-(UIImage*)tableIconPositive:(NSString*)icon  {
    return [UIImage imageWithIcon:icon
           backgroundColor:[UIColor clearColor]
                 iconColor:neoGreenColor
                 iconScale:1.0
                          andSize:CGSizeMake(24, 24)];
}


//clear keychain:
-(void)resetKeychain {
    [self deleteAllKeysForSecClass:kSecClassGenericPassword];
    [self deleteAllKeysForSecClass:kSecClassInternetPassword];
    [self deleteAllKeysForSecClass:kSecClassCertificate];
    [self deleteAllKeysForSecClass:kSecClassKey];
    [self deleteAllKeysForSecClass:kSecClassIdentity];
}

-(void)deleteAllKeysForSecClass:(CFTypeRef)secClass {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:(__bridge id)secClass forKey:(__bridge id)kSecClass];
    OSStatus result __unused = SecItemDelete((__bridge CFDictionaryRef) dict) ;
    NSAssert(result == noErr || result == errSecItemNotFound, @"Error deleting keychain data (%d)", (int)result);
}

//format keychain
-(NSString*)switchIntervalLabel:(NSString*)labelValue andType:(NSString*)labelType {
    
    if ([labelType isEqualToString:@"second"])
        labelType = NSLocalizedString(@"second", nil);
    else if ([labelType isEqualToString:@"seconds"])
        labelType = NSLocalizedString(@"seconds", nil);
    else if ([labelType isEqualToString:@"minute"])
        labelType = NSLocalizedString(@"minute", nil);
    else if ([labelType isEqualToString:@"minutes"])
        labelType = NSLocalizedString(@"minutes", nil);
    
    return [NSString stringWithFormat:@"%@ %@",labelValue, labelType];
}


//number formatter
-(NSString*)formatNumber:(NSNumber*)number ofType:(int)type withFiatSymbol:(NSString*)fiatSymbol {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
    if (type == 0) {
        f.maximumFractionDigits = 0;
        
    } else if (type == 1) {
        f.numberStyle = NSNumberFormatterCurrencyStyle;
        f.maximumFractionDigits = 5;
        f.minimumFractionDigits = 0;
        f.currencySymbol = @"";
        
    } else if (type == 2) {
        f.locale = [NSLocale currentLocale];
        f.numberStyle = NSNumberFormatterCurrencyStyle;
        f.currencySymbol = fiatSymbol;
        f.usesGroupingSeparator = YES;
        
    } else if (type == 3) {
        f.numberStyle = NSNumberFormatterCurrencyStyle;
        f.maximumFractionDigits = 8;
        f.minimumFractionDigits = 8;
        f.currencySymbol = @"";
        
    }
    
    return [f stringFromNumber:number];
}



+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self)
	{
		if (sharedData == nil)
		{
			sharedData = [super allocWithZone:zone];
			return sharedData;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end
