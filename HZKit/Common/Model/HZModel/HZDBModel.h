//
//  HZDBModel.h
//  HZKit
//
//  Created by HertzWang on 2018/11/22.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZModel.h"

#import "HZDatabase.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZDBModel : HZModel

- (HZDatabase *)getDB;

- (BOOL)insert;

@end

NS_ASSUME_NONNULL_END
