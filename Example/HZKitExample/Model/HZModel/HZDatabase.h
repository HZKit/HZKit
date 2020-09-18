//
//  HZDatabase.h
//  HZKit
//
//  Created by HertzWang on 2018/11/22.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZDatabase : NSObject

+ (instancetype)shared;

/**
 新建数据库

 @param dbName 数据库名称
 @param dbPath 数据库完整路径，默认放在 Documents
 @return 数据库实例（未连接）
 */
- (instancetype)initWithName:(NSString * _Nonnull)dbName path:(NSString *_Nullable)dbPath;

/**
 连接数据库

 @return YES-成功 NO-失败
 */
- (BOOL)connect;

/**
 数据库中执行

 @param block 操作
 */
- (void)inDatabase:(void (^)(FMDatabase *db))block;

/**
 数据库中事务执行

 @param block 操作
 */
- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

@end

NS_ASSUME_NONNULL_END
