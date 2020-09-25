//
//  HZNavigationScreenshot.h
//  HZKit
//
//  Created by Hertz Wang on 2020/9/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZNavigationScreenshot : NSObject

+ (instancetype)shared;

/// 根据偏移量设置动画效果
/// @param pt 偏移量
- (void)showEffectChange:(CGPoint)pt;

/// 重置快照位置及遮罩透明度
- (void)restore;

/// 结束
- (void)finish;

/// 生成快照
- (UIImage *)screenShot;

/// 更新显示快照
/// @param image 图片
- (void)updateScreenShotImage:(UIImage * _Nullable)image;

/// 隐藏/显示
/// @param hide YES-隐藏
- (void)hidden:(BOOL)hide;

@end

NS_ASSUME_NONNULL_END
