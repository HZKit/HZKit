//
//  HZAuthorization.h
//  HZKit
//
//  Created by HertzWang on 2018/8/7.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HZAuthorizationBlock)(BOOL grandted, NSString *description);

typedef NS_ENUM(NSUInteger, HZAuthorizationType) {
    HZAuthorizationNFC,
    HZAuthorizationMediaLibrary,
    HZAuthorizationBluetooth,
    HZAuthorizationCalendars,
    HZAuthorizationCamera,
    HZAuthorizationContacts,
    HZAuthorizationFaceID,
    HZAuthorizationHealth,
    HZAuthorizationHomeKit,
    HZAuthorizationLocation,
    HZAuthorizationMicrophone,
    HZAuthorizationMotion,
    HZAuthorizationPhotoLibrary,
    HZAuthorizationReminders,
    HZAuthorizationTV
};

// TODO: 整理使用
@interface HZAuthorization : NSObject

+ (void)authorizationType:(HZAuthorizationType)type completionHandler:(HZAuthorizationBlock)handler;
+ (void)toAuthorization;

@end
