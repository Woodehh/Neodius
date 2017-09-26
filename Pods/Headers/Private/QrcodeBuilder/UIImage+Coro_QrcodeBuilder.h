//
//  UIImage+Coro_QrcodeBuilder.h
//  QRcodeBuilder
//
//  Created by Corotata on 15/11/27.
//  Copyright © 2015年 corotata. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  二维码生成器分类，在https://github.com/yourtion/Demo_CustomQRCode
 *  的基础上进行了一些引用和扩展工作
 */

@interface UIImage (Coro_QrcodeBuilder)

+ (UIImage *)coro_createQRCodeWithText:(NSString *)text size:(CGFloat)size;

+ (UIImage *)coro_createQRCodeWithText:(NSString *)text size:(CGFloat)size centerImage:(UIImage *)centerImage;

+ (UIImage *)coro_createQRCodeWithText:(NSString *)text size:(CGFloat)size AndTransformColorWithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

+ (UIImage *)coro_createQRCodeWithText:(NSString *)text size:(CGFloat)size centerImage:(UIImage *)centerImage AndTransformColorWithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;


@end
