//
//  AppDelegate.h
//  Nodius
//
//  Created by Benjamin de Bos on 16-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ViewDeck/ViewDeck.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <LTHPasscodeViewController/LTHPasscodeViewController.h>
#import <Instabug/Instabug.h>


@class IIViewDeckController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    IIViewDeckController* deckController;
}

@property (retain, nonatomic) UIWindow *window;



@end



