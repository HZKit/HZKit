//
//  HZImagePicker.h
//  HZKitExample
//
//  Created by Wang, Haizhou on 2020/9/27.
//  Copyright © 2020 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HZImagePicker;

NS_ASSUME_NONNULL_BEGIN

@protocol HZImagePickerDelegate <NSObject>

@optional

/// 选择完成
/// @param picker 选择器
/// @param results 图片结果集成，如果是视频则为视频的封面
/// @param videoPath 视频本地路径
- (void)imagePicker:(HZImagePicker *)picker didFinishPicking:(NSArray<UIImage *> *)results videoPath:(NSString *)videoPath;

/// 取消选择
/// @param picker 选择器
- (void)imagePickerDidCancel:(HZImagePicker *)picker;

@end

@interface HZImagePicker : NSObject

@property (nonatomic, weak) id<HZImagePickerDelegate> delegate;
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, assign) BOOL allowsVideo;
@property (nonatomic, assign) BOOL allowsLivePhotos;
@property (nonatomic, assign) NSInteger selectionLimit API_AVAILABLE(ios(14.0));

- (void)show;
//- (void)

@end

NS_ASSUME_NONNULL_END
