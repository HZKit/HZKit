//
//  HZAuthorization.m
//  HZKit
//
//  Created by HertzWang on 2018/8/7.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZAuthorization.h"
#import <AVFoundation/AVCaptureDevice.h>

@implementation HZAuthorization

+ (void)authorizationType:(HZAuthorizationType)type completionHandler:(HZAuthorizationBlock)handler {
    switch (type) {
        case HZAuthorizationNFC:
            
            break;
        case HZAuthorizationMediaLibrary:
            
            break;
        case HZAuthorizationBluetooth:
            
            break;
        case HZAuthorizationCalendars:
            
            break;
        case HZAuthorizationCamera:
        {
            [HZAuthorization authorizationCamera:^(BOOL grandted, NSString *description) {
                if (handler) {
                    handler(grandted, description);
                }
            }];
        }
            break;
        case HZAuthorizationContacts:
            
            break;
        case HZAuthorizationFaceID:
            
            break;
        case HZAuthorizationHealth:
            
            break;
        case HZAuthorizationHomeKit:
            
            break;
        case HZAuthorizationLocation:
            
            break;
        case HZAuthorizationMicrophone:
            
            break;
        case HZAuthorizationMotion:
            
            break;
        case HZAuthorizationPhotoLibrary:
            
            break;
        case HZAuthorizationReminders:
            
            break;
        case HZAuthorizationTV:
            
            break;
        default:
            break;
    }
}

+ (void)authorizationCamera:(HZAuthorizationBlock)handler {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        handler(NO, @"设置不支持");
        
        return;
    }
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            handler(YES, nil);
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    handler(YES, nil);
                } else {
                    handler(YES, @"");
                }
            }];
        }
            break;
        default:
            handler(NO, @"");
            break;
    }
}

@end
