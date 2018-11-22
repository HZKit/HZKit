//
//  HZModel.h
//  HZKit
//
//  Created by HertzWang on 2018/11/20.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZModel : NSObject<NSCoding, NSCopying>

@property (nonatomic, assign) NSUInteger modelId; // 唯一标识

@end

@interface HZModel (JSON)

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
