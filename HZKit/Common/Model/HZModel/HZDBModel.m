//
//  HZDBModel.m
//  HZKit
//
//  Created by HertzWang on 2018/11/22.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZDBModel.h"

@interface HZDBModel ()

@property (nonatomic, strong) HZDatabase *db;

@end

@implementation HZDBModel

- (BOOL)insert {
    return NO;
}

- (HZDatabase *)getDB {
    return [HZDatabase shared];
}

@end
