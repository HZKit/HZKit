//
//  HZDatabase.m
//  HZKit
//
//  Created by HertzWang on 2018/11/22.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZDatabase.h"

@interface HZDatabase ()

@property (nonatomic, strong) NSString *dbName;
@property (nonatomic, strong) NSString *dbPath;

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation HZDatabase

+ (instancetype)shared {
    static HZDatabase *instance = nil;;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HZDatabase alloc] initWithName:@"Bank.db" path:nil];
        if (![instance connect]) {
#if DEBUG
            NSLog(@"数据库连接失败");
#endif
        }
    });
    
    return instance;
}

#pragma mark - Init
- (instancetype)initWithName:(NSString * _Nonnull)dbName path:(NSString * _Nullable)dbPath{
    self = [super init];
    if (self) {
        _dbName = [dbName copy];
        _dbPath = [dbPath copy];
    }
    
    return self;
}

#pragma mark - Private
- (NSString *)getDBPath {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dbPath = [docPath stringByAppendingPathComponent:_dbName];
    
    return dbPath;
    
}

#pragma mark - Public

- (BOOL)connect {
    NSString *dbPath = _dbPath;
    if (!dbPath) {
        dbPath = [self getDBPath];
    }
    
    if (!_dbQueue) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    
#if DEBUG
    NSLog(@"db path:%@", dbPath);
#endif
    
    if (_dbQueue) {
        [_dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            NSString *bankSQL = @"CREATE TABLE IF NOT EXISTS bank ( \
                                _id INTEGER PRIMARY KEY AUTOINCREMENT, \
                                bin  CHAR(19) UNIQUE, \
                                name CHAR(64), \
                                type CHAR(6) \
                                 )";
            if (![db executeUpdate:bankSQL]) {
                *rollback = YES;
            };
        }];
    }
    
    return (_dbQueue ? YES : NO);
}

- (void)inDatabase:(void (^)(FMDatabase *db))block {
    [_dbQueue inDatabase:block];
}

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block {
    [_dbQueue inTransaction:block];
}

@end
