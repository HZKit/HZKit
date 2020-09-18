//
//  HZModel+Database.m
//  HZKit
//
//  Created by HertzWang on 2018/11/22.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZModel+Database.h"
#import <objc/runtime.h>

static char *HZDBModelTableNameKey = "HZDBModelTableNameKey";

@implementation HZModel (Database)

#pragma mark - Property

- (void)setTableName:(NSString *)tableName {
    objc_setAssociatedObject(self, HZDBModelTableNameKey, tableName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)tableName {
    return objc_getAssociatedObject(self, HZDBModelTableNameKey);
}


#pragma mark - Public
- (HZDatabase *)getDB {
    return [HZDatabase shared];
}

- (long long)insert {
    __block long long result = 0;
    
    NSString *table = self.tableName;
    if (!table) {
        return result;
    }
    
    [[self getDB] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ ", table]; // SQL语句
        NSMutableString *colums = [[NSMutableString alloc] init]; // 列
        NSMutableString *values = [[NSMutableString alloc] init]; // 值
        NSMutableArray *args = [[NSMutableArray alloc] init]; // 参数
        
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [self valueForKey:key];
            if (!value) {
                continue; // 过虑掉空值
            }
            [args addObject:value];
            [values appendString:@"?,"];
            
            if ([key hasPrefix:@"_"]) {
                key = [key substringFromIndex:1];
            }
            [colums appendFormat:@"%@,", key];
        }
        
        // 删除最后的逗号
        [colums deleteCharactersInRange:NSMakeRange(colums.length - 1, 1)];
        [values deleteCharactersInRange:NSMakeRange(values.length - 1, 1)];
        
        [sql appendFormat:@"(%@) VALUES(%@)", colums, values]; // 拼接SQL
        if ([db executeUpdate:sql withArgumentsInArray:args]) {
            result = [db lastInsertRowId];
            self.modelId = result;
        }
        
        if ([db hadError]) {
#if DEBUG
            NSLog(@"insert failed! reason: %@", [db lastErrorMessage]);
#endif
        }
    }];
    
    return result;
}

- (long long)insertData:(NSDictionary *)content atTable:(NSString *)table {
    __block long long result = 0;
    
    [[self getDB] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ ", table]; // SQL语句
        NSMutableString *colums = [[NSMutableString alloc] init]; // 列
        NSMutableString *values = [[NSMutableString alloc] init]; // 值
        NSMutableArray *args = [[NSMutableArray alloc] init]; // 参数
        
        for (id key in content) {
            [colums appendFormat:@"%@,", key];
            [values appendString:@"?,"];
            [args addObject:[content objectForKey:key]];
        }
        
        // 删除最后的逗号
        [colums deleteCharactersInRange:NSMakeRange(colums.length - 1, 1)];
        [values deleteCharactersInRange:NSMakeRange(values.length - 1, 1)];
        
        [sql appendFormat:@"(%@) VALUES(%@)", colums, values]; // 拼接SQL
        if ([db executeUpdate:sql withArgumentsInArray:args]) {
            result = [db lastInsertRowId];
            self.modelId = result;
        }
        
        if ([db hadError]) {
#if DEBUG
            NSLog(@"insert failed! reason: %@", [db lastErrorMessage]);
#endif
        }
    }];
    
    return result;
}

- (BOOL)update {
    return NO;
}

- (BOOL)updateData:(NSDictionary *)content atTable:(NSString *)table {
    return NO;
}

- (BOOL)deleteData {
    return NO;
}

@end
