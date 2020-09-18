//
//  HZModel+Database.h
//  HZKit
//
//  Created by HertzWang on 2018/11/22.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZModel.h"
#import "HZDatabase.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZModel (Database)

@property (nonatomic, copy) NSString *tableName;

- (HZDatabase *)getDB;

/**
 插入model数据（表结构与model属性完全一致时使用）

 @return 数据唯一标识id
 */
- (long long)insert;

/**
 插入model数据（表结构与model属性不一致时使用）

 @param content 表列表和值
 @param table 表象
 @return 数据唯一标识id
 */
- (long long)insertData:(NSDictionary *)content atTable:(NSString *)table;

// TODO: 待完善
- (BOOL)update;
- (BOOL)updateData:(NSDictionary *)content atTable:(NSString *)table;
- (BOOL)deleteData;

@end

NS_ASSUME_NONNULL_END
