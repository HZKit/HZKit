//
//  HZBankModel.h
//  HZKit
//
//  Created by HertzWang on 2018/11/22.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZBankModel : HZDBModel

@property (nonatomic, strong) NSString *bin; // 卡号前6位
@property (nonatomic, strong) NSString *name; // 银行名称
@property (nonatomic, strong) NSString *type; // 卡类型

@end

NS_ASSUME_NONNULL_END
