//
//  HZBankModel.m
//  HZKit
//
//  Created by HertzWang on 2018/11/22.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZBankModel.h"

@implementation HZBankModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.tableName = @"bank"; // 设置表名
    }
    
    return self;
}

@end
