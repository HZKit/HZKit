//
//  HZVersionManager.h
//  HZKit
//
//  Created by HertzWang on 2018/6/11.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HZVersionManagerBlock)(BOOL isFindNew, id info);

@interface HZVersionManager : NSObject

+ (void)checkAppUpdateWithAppId:(NSString *)appId complete:(HZVersionManagerBlock)block;

@end
