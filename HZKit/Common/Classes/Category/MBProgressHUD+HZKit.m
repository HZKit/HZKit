//
//  MBProgressHUD+HZKit.m
//  HZKit
//
//  Created by HertzWang on 2018/8/8.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "MBProgressHUD+HZKit.h"

#define HZ_KEY_WINDOW [[UIApplication sharedApplication] keyWindow]
#define HZ_HUD_DELAY 1.5
#define HZ_HUD_BEZEL_BACKGROUND_COLOR [[UIColor blackColor] colorWithAlphaComponent:0.8]
#define HZ_HUD_LABEL_COLOR [UIColor whiteColor]

#define dispatch_main_async_hud(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

@implementation MBProgressHUD (HZKit)

+ (void)hz_showHUD:(NSString *)message {
    dispatch_main_async_hud(^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:HZ_KEY_WINDOW animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = HZ_HUD_BEZEL_BACKGROUND_COLOR;
        hud.label.textColor = HZ_HUD_LABEL_COLOR;
        hud.label.text = message;
        
        [hud hideAnimated:YES afterDelay:HZ_HUD_DELAY];
    });
}

+ (void)hz_showToast:(NSString *)message {
    dispatch_main_async_hud(^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:HZ_KEY_WINDOW animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = HZ_HUD_BEZEL_BACKGROUND_COLOR;
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset); // bottom
        hud.label.textColor = HZ_HUD_LABEL_COLOR;
        hud.label.text = message;
        
        [hud hideAnimated:YES afterDelay:HZ_HUD_DELAY];
    });
}

@end

#pragma mark -
void HZShowHUD(NSString *message) {
    [MBProgressHUD hz_showHUD:message];
}

void HZShowToast(NSString *message) {
    [MBProgressHUD hz_showToast:message];
}
