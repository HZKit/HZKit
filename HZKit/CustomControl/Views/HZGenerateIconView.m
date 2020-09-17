//
//  HZGenerateIconView.m
//  HZKit
//
//  Created by HertzWang on 2018/11/29.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZGenerateIconView.h"
#import "HZGenerateIconModel.h"

#define kAppStoreIconSize 1024

@interface HZGenerateIconView ()

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat backgroundColorR;
@property (nonatomic, assign) CGFloat backgroundColorG;
@property (nonatomic, assign) CGFloat backgroundColorB;

@end

@implementation HZGenerateIconView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.frame = CGRectMake(0, 0, kAppStoreIconSize, kAppStoreIconSize);
        self.backgroundColor = [UIColor clearColor];
        
        self.cornerRadius = 0;
        self.backgroundColorR = 13.0;
        self.backgroundColorG = 66.0;
        self.backgroundColorB = 164.0;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 背景
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    UIColor *bgColor = [UIColor colorWithRed:(self.backgroundColorR/255.0)
                                       green:(self.backgroundColorG/255.0)
                                        blue:(self.backgroundColorB/255.0) alpha:1.0];
    [bgColor setFill];
    [bgPath fill];
    
    // 160 150 200
    UIColor *tintColor = [UIColor colorWithRed:(160.0/255.0) green:(150.0/255.0) blue:(200.0/255.0) alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.text = @"小王";
    label.font = [UIFont boldSystemFontOfSize:(label.hz_width * 0.5)];
    label.textColor = tintColor;
    label.textAlignment = NSTextAlignmentCenter;
    
    [label drawTextInRect:label.bounds];
    
}
// TODO: 设置属性
- (void)updateValue:(CGFloat)value {
    [self setValue:[NSNumber numberWithDouble:value] forKey:@"cornerRadius"];
    
    [self setNeedsDisplay];
}


@end
