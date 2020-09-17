//
//  UIDevice+HZCommon.h
//  HZKit
//
//  Created by HertzWang on 2018/7/26.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 // TODO: 编写 UIDevice Category 使用文档
 */
@interface UIDevice (HZCommon)

/**
 Device Identifier: iPhone7,2, iPhone6,1

 @return Identifier
 */
+ (NSString *)hz_deviceIdentifier;

/**
 Device Generation: iPhone 8、iPhone X

 @return Generation
 */
+ (NSString *)hz_deviceGeneration;

/**
 UDID
 
 @return UDID
 */
+ (NSString *)hz_deviceUDID;

@end
