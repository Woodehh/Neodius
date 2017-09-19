//
//  UIImage+FontAwesome.m
//
//  Copyright (c) 2017 Benjamin de Bos - ITS-Vision. All rights reserved.
//
//  Based on the awesome job by: Alex Usbergo. Highly optimised by Benjamin de Bos
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//

#import "UIImage+FontAwesome.h"
#import "NSString+FontAwesome.h"

@implementation UIImage (UIImage_FontAwesome)

+(UIImage*)imageWithIcon:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor iconScale:(CGFloat)scale andSize:(CGSize)size{
    
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    //// Abstracted Attributes
    NSString* textContent = [NSString fontAwesomeIconStringForIconIdentifier:identifier];
    
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, size.width, size.height)];
    [bgColor setFill];
    [rectanglePath fill];
    
    
    //// Text Drawing
    
    NSMutableParagraphStyle *p = [[NSMutableParagraphStyle alloc]init] ;
    [p setAlignment:NSTextAlignmentCenter];
    [p setLineBreakMode:NSLineBreakByWordWrapping];
    
    
    float fontSize=(MIN(size.height,size.width))*scale;
    CGRect textRect = CGRectMake(size.width/2-(fontSize/2)*1.2, size.height/2-fontSize/2, fontSize*1.2, fontSize);
    [textContent drawInRect: textRect
             withAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:(float)((int)fontSize)],
                               NSParagraphStyleAttributeName: p,
                               NSForegroundColorAttributeName: iconColor,
                               NSBackgroundColorAttributeName: bgColor
                               }];
    [iconColor setFill];
    
    //Image returns
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
