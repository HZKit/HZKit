//
//  UIDevice+Common.m
//  HZKit
//
//  Created by Hertz Wang on 2018/6/26.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "UIDevice+Common.h"
#import <Security/Security.h>

@implementation UIDevice (Common)

- (NSString *)hz_deviceIdentifier {
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

+ (NSMutableDictionary *)_queryForService:(NSString *)service account:(NSString *)account {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    
    if (service) {
    }
    
    if (account) {
    }
    
    return dictionary;
}

@end
