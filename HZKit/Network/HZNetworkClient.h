//
//  HZNetworkClient.h
//  HZKit
//
//  Created by HertzWang on 2018/9/29.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class <#name#>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HZNetworkSuccessBlock)(NSURLSessionTask *task, id object);
typedef void(^HZNetworkFailureBlock)(NSURLSessionTask *task, NSError *error);

@interface HZNetworkClient : NSObject

+ (instancetype)shared;

- (BOOL)hasNetwork;
- (BOOL)isViaWiFi;
- (BOOL)isViaWWAN;

- (void)postURL:(NSString *)url parameters:(NSDictionary *)parameters success:(HZNetworkSuccessBlock)success failure:(HZNetworkFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
