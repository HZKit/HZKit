//
//  HZCustomControlModel.h
//  HZKit
//
//  Created by Hertz Wang on 2018/7/28.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZBaseModel.h"

@interface HZCustomControlModel : HZBaseModel

@property (nonatomic, copy) NSString *icon;

+ (instancetype)modelWithIcon:(NSString *)icon action:(NSString *)action;

@end
