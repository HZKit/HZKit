//
//  HZScanViewController.h
//  HZKit
//
//  Created by HertzWang on 2018/8/10.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZScanViewController : UIViewController

@end

#pragma mark - HZScanMaskView
@interface HZScanMaskView : UIView

+ (instancetype)maskViewWithFrame:(CGRect)frame transparentFrame:(CGRect)transparentFrame;

@end
