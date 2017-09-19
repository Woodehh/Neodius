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

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
#define neoGreenColor [UIColor colorWithRed:0.35 green:0.75 blue:0.00 alpha:1.0]


@interface NeodiusDataSource : NSObject  {
}


+ (NeodiusDataSource*)sharedData;

-(NSString*)buildAPIUrlWithEndpoint:(NSString*)property;

-(NSDictionary*)getFiatData;
-(NSDictionary*)getCryptoData;
-(NSDictionary*)getIntervalData;

-(void)setBaseFiat:(NSString *)selectedBaseFiat;
-(void)setBaseCrypto:(NSString *)selectedBaseCrypto;

-(NSString*)getBaseFiat;
-(NSString*)getBaseCrypto;
-(NSArray*)getStoredWallets;

-(void)setStoredWallets:(NSArray*)wallets;
-(void)addNewWallet:(NSString*)name withAddress:(NSString*)address;
-(void)updateWalletAtIndex:(NSUInteger)index withName:(NSString*)name andAddress:(NSString*)address;


-(void)setShowTimer:(BOOL)showTimer;
-(BOOL)getShowTimer;

-(void)setShowMessages:(BOOL)showMessages;
-(BOOL)getShowMessages;

-(void)setUseMainNet:(BOOL)mainNet;
-(BOOL)getUseMainNet;

-(UIImage*)tableIconNegative:(NSString*)icon;
-(UIImage*)tableIconPositive:(NSString*)icon;

-(void)setRefreshInterval:(NSString *)refreshInterval;
-(NSString*)getRefreshInterval;

-(void)resetKeychain;
-(NSString*)switchIntervalLabel:(NSString*)labelValue andType:(NSString*)labelType;

@end
