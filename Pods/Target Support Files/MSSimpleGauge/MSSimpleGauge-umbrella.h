#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MSAnnotatedGauge.h"
#import "MSArcLayer.h"
#import "MSArcLayerSubclass.h"
#import "MSGradientArcLayer.h"
#import "MSNeedleView.h"
#import "MSRangeGauge.h"
#import "MSSimpleGauge.h"
#import "MSSimpleGaugeSubclass.h"

FOUNDATION_EXPORT double MSSimpleGaugeVersionNumber;
FOUNDATION_EXPORT const unsigned char MSSimpleGaugeVersionString[];

