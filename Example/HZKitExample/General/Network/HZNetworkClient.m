//
//  HZNetworkClient.m
//  HZKit
//
//  Created by HertzWang on 2018/9/29.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZNetworkClient.h"

#import "AFNetworking.h"

NSTimeInterval kHZNetworkTimeout = 30.f;

@interface HZNetworkClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation HZNetworkClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [self getHTTPSessionManager];
    }
    return self;
}

- (AFHTTPSessionManager *)getHTTPSessionManager {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // request serializer
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.stringEncoding = NSUTF8StringEncoding;
    requestSerializer.timeoutInterval = kHZNetworkTimeout;
    
    manager.requestSerializer = requestSerializer;
    
    // response serializer
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                      @"text/html",
                                                                      @"text/json",
                                                                      @"text/plain",
                                                                      @"text/javascript",
                                                                      @"text/xml",
                                                                      @"image/*",
                                                                      @"application/octet-stream",
                                                                      @"application/zip"]];
    
    manager.responseSerializer = responseSerializer;
    
    // security policy
    // TODO: If you want to be safer, please modify.
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    
    manager.securityPolicy = securityPolicy;
    
    return manager;
}

+ (instancetype)shared {
    static HZNetworkClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HZNetworkClient alloc] init];
    });
    
    return instance;
}

- (BOOL)isViaWiFi {
    AFNetworkReachabilityStatus status = self.manager.reachabilityManager.networkReachabilityStatus;
    return (status == AFNetworkReachabilityStatusReachableViaWiFi);
}
- (BOOL)isViaWWAN {
    AFNetworkReachabilityStatus status = self.manager.reachabilityManager.networkReachabilityStatus;
    return (status == AFNetworkReachabilityStatusReachableViaWWAN);
}
- (BOOL)hasNetwork {
    AFNetworkReachabilityStatus status = self.manager.reachabilityManager.networkReachabilityStatus;
    return (status > AFNetworkReachabilityStatusNotReachable);
}

+ (void)postURL:(NSString *)URLString parameters:(NSDictionary *)parameters modelClass:(Class)modelClass responseObject:(HZNetworkResponseBlock)completionHandler {
    
    HZNetworkClient *client = [HZNetworkClient shared];
    
    [client.manager POST:URLString
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     [self responseWithCompletionHandler:completionHandler
                                              modelClass:modelClass
                                                    task:task
                                                response:responseObject
                                                   error:nil];
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     [self responseWithCompletionHandler:completionHandler
                                              modelClass:nil
                                                    task:task
                                                response:nil
                                                   error:error];
                 }];
}

+ (void)getURL:(NSString *)URLString parameters:(NSDictionary *)parameters modelClass:(Class)modelClass  responseObject:(HZNetworkResponseBlock)completionHandler {
    
    HZNetworkClient *client = [HZNetworkClient shared];
    
    [client.manager GET:URLString
             parameters:parameters
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self responseWithCompletionHandler:completionHandler
                                             modelClass:modelClass
                                                   task:task
                                               response:responseObject
                                                  error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self responseWithCompletionHandler:completionHandler
                                             modelClass:modelClass
                                                   task:task
                                               response:nil
                                                  error:error];
                }];
}

+ (void)responseWithCompletionHandler:(HZNetworkResponseBlock)completionHandler
                           modelClass:(Class)modelClass
                                 task:(NSURLSessionDataTask *)task
                             response:(id)responseObject
                                error:(NSError *)error {
    
    if (completionHandler) {
        HZDataResponse *response = [[HZDataResponse alloc] initWithModelClass:modelClass task:task response:responseObject error:error];
        completionHandler(response);
    }
}

@end


@implementation HZDataResponse

- (instancetype)initWithModelClass:(Class)modelClass
                         task:(NSURLSessionTask *)task
                     response:(id _Nullable)response
                        error:(NSError * _Nullable )error {
    
    self = [super init];
    if (self) {
        _task = task;
        _response = response;
        _error = error;
        
        if (response && [response isKindOfClass:[NSDictionary class]] && modelClass) {
            NSError *transError = nil;
            NSDictionary *dict = (NSDictionary *)response;
            _model = [(JSONModel *)[modelClass alloc] initWithDictionary:dict
                                                                   error:&transError];
            _error = transError;
        }
    }
    
    return self;
}

@end
