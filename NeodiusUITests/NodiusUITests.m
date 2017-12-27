//
//  NeodiusUITests.m
//  NeodiusUITests
//
//  Created by Benjamin de Bos on 06-10-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NeodiusUITests-Swift.h"

@interface NeodiusUITests : XCTestCase
    @property (nonatomic,retain) XCUIApplication *app;
    @end

@implementation NeodiusUITests
    
- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [Snapshot setupSnapshot:app];
    [app launch];
}
    
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
-(void)openNavigationMenu {
    [[[_app.navigationBars childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
}
    
-(void)openRightMenuOption {
    [[[_app.navigationBars childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
}
    
-(void)selectMenuItemWithIdentifier:(NSString*)identifier {
    [self openNavigationMenu];
    [[_app.tables.cells matchingIdentifier:identifier].element tap];
}
    
-(void)tapBackButton {
    [self openNavigationMenu];
}
    
-(void)selectMenuItemWithOfIndex:(NSInteger)index {
    [self openNavigationMenu];
    [[_app.tables.cells elementBoundByIndex:index] tap];
}
    
-(void)takeSnapShotWithName:(NSString*)name {
    NSLog(@"TAKING SCREENSHOT: %@",name);
    [Snapshot snapshot:name timeWaitingForIdle:(double)0];
}
    
-(XCUIElement*)currentAlertView {
    return [_app.alerts elementBoundByIndex:0];
}
    
-(void)tapButtonInCurrentAlertView:(NSInteger)button {
    [[[self currentAlertView].buttons elementBoundByIndex:button] tap];
}
    
-(void)enterTextInAlertViewField:(NSInteger)field andValue:(NSString*)value {
    XCUIElement *view = [self currentAlertView];
    XCUIElement *input = [[view childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:field];
    [input typeText:value];
}
    
-(void)slideLeftOnPageController {
    [[_app.tables.cells elementBoundByIndex:0] swipeLeft];
}
    
    
- (void)testExample {
    
    //new application: init the global app
    _app = [[XCUIApplication alloc] init];
    
    //    //screenshot from wallet
    //    [self selectMenuItemWithIdentifier:@"first_wallet"];
    //    [self takeSnapShotWithName:@"screen-wallet"];
    //
    //    //screenshot of QR Code
    //    [self openRightMenuOption];
    //    [self takeSnapShotWithName:@"screen-wallet-qr-code"];
    //    [self openRightMenuOption]; // THIS IS A FIX FOR TAPPING OUTSIDE THE QR MODAL!
    //
    //
    //    //gas calculation screenshot
    //    [self selectMenuItemWithIdentifier:@"gas_calculation"];         //open gas calc
    //    [self openRightMenuOption];                                     //open option menu
    //    [self takeSnapShotWithName:@"screen-gas-calculation-options"];  //take screenshot
    //    [self tapButtonInCurrentAlertView:0];                           //select manual option
    //    [self enterTextInAlertViewField:0 andValue:@"1200"];            //enter 1200 in first field
    //    [self tapButtonInCurrentAlertView:1];                           //tap calculate
    //    [self takeSnapShotWithName:@"screen-gas-calculation"];          //take screenshot
    //
    
    //neo market info
    [self selectMenuItemWithIdentifier:@"neo_market_info"];
    [self takeSnapShotWithName:@"screen-neo-market-info"];
    [self slideLeftOnPageController];
    [self takeSnapShotWithName:@"screen-neo-market-chart"];
    
    //gas market info
    [self selectMenuItemWithIdentifier:@"gas_market_info"];
    [self takeSnapShotWithName:@"screen-gas-market-info"];
    [self slideLeftOnPageController];
    [self takeSnapShotWithName:@"screen-gas-market-chart"];
    
    //    //settings screen
    //    [self selectMenuItemWithIdentifier:@"settings"];
    //    [self takeSnapShotWithName:@"screen-settings"];
    //
    //    //tipjar screen
    //    [self selectMenuItemWithIdentifier:@"tip_jar"];
    //    [self takeSnapShotWithName:@"screen-tip-jar"];
    //
    //    //neo news today screen
    //    [self selectMenuItemWithIdentifier:@"neo_news_today"];
    //    [self takeSnapShotWithName:@"screen-neo-news-today"];
    //
    //    //neo news today screen
    //    [self openNavigationMenu];
    //    [self takeSnapShotWithName:@"screen-menu"];
    
    
}
    
@end

