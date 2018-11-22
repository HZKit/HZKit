//
//  HZBankModel.m
//  HZKit
//
//  Created by HertzWang on 2018/11/22.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZBankModel.h"

@implementation HZBankModel

- (BOOL)insert {
    __block BOOL result = NO;
    
    [[self getDB] inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"INSERT INTO bank (bin, name, type) VALUES (?, ?, ?)";
        result = [db executeUpdate:sql withArgumentsInArray:@[ self.bin, self.name, self.type ]];
    }];
    
    return result;
}

@end
