//
//  NeodiusDataSource.h
//  Artez V2.0
//
//  Created by Benjamin de Bos on 09-05-13.
//  Copyright (c) 2013 GMoledina.ca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SimpleKeychain/SimpleKeychain.h>
#import <FontAwesome4-ios/FontAwesome4-ios.h>
#import <AFNetworking/AFNetworking.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
#define neoGreenColor [UIColor colorWithRed:0.35 green:0.75 blue:0.00 alpha:1.0]

@interface NeodiusDataSource : NSObject

+ (NeodiusDataSource*)sharedData;

-(NSString*)buildAPIUrlWithEndpoint:(NSString*)property;

@property (NS_NONATOMIC_IOSONLY, getter=getFiatData, readonly, copy) NSDictionary *fiatData;
@property (NS_NONATOMIC_IOSONLY, getter=getCryptoData, readonly, copy) NSDictionary *cryptoData;
@property (NS_NONATOMIC_IOSONLY, getter=getIntervalData, readonly, copy) NSDictionary *intervalData;
@property (NS_NONATOMIC_IOSONLY, getter=getDonationData, readonly, copy) NSArray *donationData;

@property (NS_NONATOMIC_IOSONLY, getter=getBaseFiat, copy) NSString *baseFiat;
@property (NS_NONATOMIC_IOSONLY, getter=getBaseCrypto, copy) NSString *baseCrypto;
@property (NS_NONATOMIC_IOSONLY, getter=getStoredWallets, copy) NSArray *storedWallets;

-(void)addNewWallet:(NSString*)name withAddress:(NSString*)address;
-(void)updateWalletAtIndex:(NSUInteger)index withName:(NSString*)name andAddress:(NSString*)address;


@property (NS_NONATOMIC_IOSONLY, getter=getShowTimer) BOOL showTimer;
@property (NS_NONATOMIC_IOSONLY, getter=getShowMessages) BOOL showMessages;
@property (NS_NONATOMIC_IOSONLY, getter=getUseMainNet) BOOL useMainNet;

-(UIImage*)tableIconNegative:(NSString*)icon;
-(UIImage*)tableIconPositive:(NSString*)icon;

@property (NS_NONATOMIC_IOSONLY, getter=getRefreshInterval, copy) NSString *refreshInterval;

-(void)resetKeychain;
-(NSString*)switchIntervalLabel:(NSString*)labelValue andType:(NSString*)labelType;

-(NSString*)formatNumber:(NSNumber*)number ofType:(int)type withFiatSymbol:(NSString*)fiatSymbol;

-(CGFloat)calculateGasForNeo:(CGFloat)neoAmount andBlockGenerationTime:(CGFloat)generationtime;
-(CGFloat)calculateGasForNeo:(CGFloat)neoAmount;

typedef void (^blockGenerationCompletionBlock)(CGFloat blockGenerationTime, NSError* error);
typedef void (^blockGenerationProgressBlock)(CGFloat percentage,NSString *localizedMessage);
-(void)calculateBlockGenerationTimeWithCompletionBlock:(blockGenerationCompletionBlock)block andProgressBlock:(blockGenerationProgressBlock)progress;



@end
