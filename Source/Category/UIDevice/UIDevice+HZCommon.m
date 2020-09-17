//
//  UIDevice+HZCommon.m
//  HZKit
//
//  Created by HertzWang on 2018/7/26.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "UIDevice+HZCommon.h"
#import <Security/Security.h>
#import <sys/utsname.h>

@implementation UIDevice (HZCommon)

#pragma mark Identifier
+ (NSString *)hz_deviceIdentifier {
    static NSString *deviceIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        
        deviceIdentifier = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    });

    return deviceIdentifier;
}

#pragma mark Generation
+ (NSString *)hz_deviceGeneration {
    static NSString *deviceGeneration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *deviceIdentifier = [UIDevice hz_deviceIdentifier];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HZKitDeviceModels" ofType:@"plist"];
        if (filePath) {
            NSDictionary *deviceInfo = [NSDictionary dictionaryWithContentsOfFile:filePath];
            deviceGeneration = deviceInfo[deviceIdentifier];
        }
        
        if (deviceGeneration == nil) {
            deviceGeneration = deviceIdentifier;
        }
    });
    
    return deviceGeneration;
}

#pragma mark UDID
+ (NSString *)hz_deviceUDID {
    static NSString *deviceIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 1. keychina 中查询
        NSString *service = @"com.hertzwang.hzkit.device";
        NSString *account = @"device.identifier";
        
        CFTypeRef result = NULL;
        OSStatus status = -1;
        NSMutableDictionary *query = [NSMutableDictionary dictionary];
        [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [query setObject:service forKey:(__bridge id)kSecAttrService];
        [query setObject:account forKey:(__bridge id)kSecAttrAccount];
        [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
        [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
        status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
        
        if (status == noErr) {
            NSData *identifierData = (__bridge_transfer NSData *)result;
            deviceIdentifier = [[NSString alloc] initWithData:identifierData encoding:NSUTF8StringEncoding];
            
        } else {
            // 2. IDFV
            deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            
            NSData *identifierData = [deviceIdentifier dataUsingEncoding:NSUTF8StringEncoding];
            [query removeObjectForKey:(__bridge id)kSecReturnData];
            [query removeObjectForKey:(__bridge id)kSecMatchLimit];
            [query setObject:identifierData forKey:(__bridge id)kSecValueData];
            status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
        }
    });
    
    return deviceIdentifier;
}

@end
