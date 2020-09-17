//
//  HZNetworkClient.h
//  HZKit
//
//  Created by HertzWang on 2018/9/29.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSONModel, HZDataResponse;

NS_ASSUME_NONNULL_BEGIN

typedef void(^HZNetworkResponseBlock)(HZDataResponse *response);

@interface HZNetworkClient : NSObject

+ (instancetype)shared;

- (BOOL)hasNetwork;
- (BOOL)isViaWiFi;
- (BOOL)isViaWWAN;

+ (void)postURL:(NSString *)URLString parameters:(NSDictionary *)parameters modelClass:(Class)modelClass responseObject:(HZNetworkResponseBlock)completionHandler;
+ (void)getURL:(NSString *)URLString parameters:(NSDictionary *)parameters modelClass:(Class)modelClass  responseObject:(HZNetworkResponseBlock)completionHandler;
// TODO: download、upload

@end

@interface HZDataResponse : NSObject

@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, assign) id response;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, strong) id model;

- (instancetype)initWithModelClass:(Class _Nullable)modelClass
                         task:(NSURLSessionTask *)task
                    response:(id _Nullable)response
                       error:(NSError * _Nullable )error;

@end

NS_ASSUME_NONNULL_END
