//
//  farmCompassButton.m
//  FarmCompass
//
//  Created by Benjamin de Bos on 22-05-17.
//  Copyright © 2017 Invoice.Farm. All rights reserved.
//

#import "NEOButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation NEOButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)titleValue withIcon:(NSInteger)icon isPrimary:(BOOL)primary {
    
    greenColor = [UIColor colorWithRed:0.35 green:0.75 blue:0.00 alpha:1.0];
    whiteColor = [UIColor whiteColor];
    
    self = [super initWithFrame:frame];
    if (self) {
        title = titleValue;
        
        if (primary)
            [self makePrimaryButton:self withIcon:icon];
        else
            [self makeSecondaryButton:self withIcon:icon];
        

    }
    return self;
}

-(void) setupButton:(NEOButton*)button withIcon:(NSInteger)icon isPrimary:(BOOL)primary {
    CALayer *layer = button.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = greenColor.CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    

    NSMutableAttributedString *iconString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",
                                                                                               [NSString fontAwesomeIconStringForEnum:icon],
                                                                                               title]];

    [iconString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"FontAwesome" size:14]
                       range:NSMakeRange(0,1)];
    
    if (primary) {
        [iconString addAttribute:NSForegroundColorAttributeName value:whiteColor range:NSMakeRange(0, iconString.length)];
    } else {
        [iconString addAttribute:NSForegroundColorAttributeName value:greenColor range:NSMakeRange(0, iconString.length)];
    }
    
    [self setAttributedTitle:iconString forState:UIControlStateNormal];
}

- (void)makePrimaryButton:(NEOButton*)button withIcon:(NSInteger)icon {
    [self setupButton:button withIcon:icon isPrimary:YES];
    //default state
    button.backgroundColor = greenColor;
    [button setTitleColor:whiteColor forState:UIControlStateNormal];    
}

- (void)makeSecondaryButton:(NEOButton*)button withIcon:(NSInteger)icon {
    [self setupButton:button withIcon:icon isPrimary:NO];
    button.backgroundColor = whiteColor;
    [button setTitleColor:greenColor forState:UIControlStateNormal];
}

@end
