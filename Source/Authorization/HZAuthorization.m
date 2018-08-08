//
//  HZAuthorization.m
//  HZKit
//
//  Created by HertzWang on 2018/8/7.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZAuthorization.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <CoreNFC/CoreNFC.h>

NSString *const kAuthorizationCameraKey = @"NSCameraUsageDescription";
NSString *const kAuthorizationNFCKey = @"NFCReaderUsageDescription";

NSString *const kAuthorizationAssert = @">>> Unknown usage description <<<";

@interface HZAuthorization ()

@property (nonatomic, strong) NSDictionary *infoDict;

@end

@implementation HZAuthorization

#pragma mark - Public
+ (void)authorizationType:(HZAuthorizationType)type completionHandler:(HZAuthorizationBlock)handler {
    switch (type) {
        case HZAuthorizationNFC:
        {
            [HZAuthorization authorizationNFC:^(BOOL grandted, NSString *description) {
                if (handler) {
                    handler(grandted, description);
                }
            }];
        }
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

+ (void)toAuthorization {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - Pirvate
+ (void)authorizationNFC:(HZAuthorizationBlock)handler {
    [self checkInfoPlistKey:kAuthorizationNFCKey];
    
    if (@available(iOS 11.0, *)) {
        if (NFCNDEFReaderSession.readingAvailable) {
            handler(YES, @"");
        } else {
            handler(NO, @"Device is not available or not open capabilities");
        }
    } else {
        handler(NO, @"iOS 11 and later");
    }
}

+ (void)authorizationCamera:(HZAuthorizationBlock)handler {
    
    [self checkInfoPlistKey:kAuthorizationCameraKey];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        handler(NO, @"Camera is not available");
        
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
                    handler(YES, @"User allow");
                } else {
                    handler(NO, @"User reject");
                }
            }];
        }
            break;
        default:
            handler(NO, @"Restricted or Denied");
            break;
    }
}

+ (void)checkInfoPlistKey:(NSString *)key {
    NSArray *keys = [[[NSBundle mainBundle] infoDictionary] allKeys];
    if ([keys containsObject:key] == NO) {
        NSAssert(NO, kAuthorizationAssert);
    }
}

@end
