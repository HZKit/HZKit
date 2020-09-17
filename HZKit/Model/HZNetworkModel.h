//
//  HZNetworkModel.h
//  HZKit
//
//  Created by HertzWang on 2018/9/30.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseModel.h"

@class HZNetworkItemModel, HZNetworkItemImagesModel;

NS_ASSUME_NONNULL_BEGIN

@interface HZNetworkModel : JSONModel

@property (nonatomic) NSInteger total;
@property (nonatomic) NSString *title;
@property (nonatomic) NSArray<HZNetworkItemModel *> *entries;

@end

@interface HZNetworkItemModel : JSONModel

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSInteger wish;
@property (nonatomic) NSInteger collection;
@property (nonatomic) NSArray<HZNetworkItemImagesModel *> *images;
@property (nonatomic) NSString *original_title;
@property (nonatomic) NSString *orignal_title;
@property (nonatomic) NSString *pubdate;
@property (nonatomic) NSString *rating;
@property (nonatomic) NSInteger *stars;

@end

@interface HZNetworkItemImagesModel : JSONModel

@property (nonatomic) NSString *large;
@property (nonatomic) NSString *medium;
@property (nonatomic) NSString *small;

@end

NS_ASSUME_NONNULL_END
