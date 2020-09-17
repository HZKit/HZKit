//
//  HZGenerateIconViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/11/29.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZGenerateIconViewController.h"
#import "HZGenerateIconView.h"
#import "HZGenerateIconModel.h"
#import "HZGenerateIconTableViewCell.h"

NSString *const kHZGenerateIconTableViewCellIdentifier = @"HZGenerateIconTableViewCell";
NSString *const kUpdateSliderAction = @"updateAction:";

@interface HZGenerateIconViewController () <UITableViewDataSource>

@property (nonatomic, strong) HZGenerateIconView *iconView;
@property (nonatomic, strong) UITableView *configView;
@property (nonatomic, strong) NSMutableArray<HZGenerateIconModel *> *options;

@end

@implementation HZGenerateIconViewController


CGFloat padding = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)initUI {
    self.title = @"生成Icon";
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveIconAction)];
    self.navigationItem.rightBarButtonItem = saveBarButton;
    
    _iconView = [[HZGenerateIconView alloc] init];
    [self.view addSubview:_iconView];
    
    
    _configView = [[UITableView alloc] init];
//    _configView.delegate = self;
    _configView.dataSource = self;
    [_configView registerClass:[HZGenerateIconTableViewCell class] forCellReuseIdentifier:kHZGenerateIconTableViewCellIdentifier];
    [self.view addSubview:_configView];
    
    CGFloat itemWith = self.view.hz_width - padding * 2;
    // 背景
    /// 背景圆角 0~itemWith一半
    [self.options addObject:[HZGenerateIconModel
                             modelWithTitle:@"圆角"
                             action:kUpdateSliderAction
                             minValue:0 maxValue:itemWith*0.5
                            tag:HZGenerateIconModelCornerRadius]];
    
    /// 背景颜色
    [self.options addObject:[HZGenerateIconModel modelWithTitle:@"背景R"
                                                         action:kUpdateSliderAction
                                                       minValue:0
                                                       maxValue:255.0
                                                            tag:HZGenerateIconModelBackgroundColorG]];
    [self.options addObject:[HZGenerateIconModel modelWithTitle:@"背景G"
                                                         action:kUpdateSliderAction
                                                       minValue:0
                                                       maxValue:255.0
                                                            tag:HZGenerateIconModelBackgroundColorG]];
    [self.options addObject:[HZGenerateIconModel modelWithTitle:@"背景B"
                                                         action:kUpdateSliderAction
                                                       minValue:0
                                                       maxValue:255.0
                                                            tag:HZGenerateIconModelBackgroundColorB]];
    
    // 字体
    // 字体颜色
    // 字体字号
    // 文本
}

- (void)viewDidLayoutSubviews {
    CGFloat itemWith = self.view.hz_width - padding * 2;
    
    __weak typeof(self) wself = self;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-padding);
        make.left.mas_equalTo(padding);
        make.size.mas_equalTo(CGSizeMake(itemWith, itemWith));
    }];
    
    [self.configView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.width.mas_equalTo(itemWith);
        make.topMargin.mas_equalTo(padding);
        make.bottom.mas_equalTo(wself.iconView.mas_top).offset(-padding);
    }];
}


- (void)saveIconAction {
    UIImage *icon = [self.iconView hz_generateImage];
    
    UIImageWriteToSavedPhotosAlbum(icon,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   (__bridge void *)self);
}

#pragma makr - Save image
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        HZShowHUD(error.description);
    } else {
        HZShowToast(@"保存成功");
    }
}

#pragma mark - Action
- (void)updateAction:(UISlider *)slider {
    
    CGFloat value = slider.value;
    switch (slider.tag) {
        case HZGenerateIconModelCornerRadius:
            [self.iconView updateValue:value];
            break;
            
        default:
            break;
    }
    
#if DEBUG
    NSLog(@"%@\n%lf", slider, slider.value);
#endif
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HZGenerateIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHZGenerateIconTableViewCellIdentifier];
    
    HZGenerateIconModel *model = self.options[indexPath.row];
    [cell setModel:model target:self];
    
    return cell;
}

#pragma mark - Lazy load
- (NSMutableArray<HZGenerateIconModel *> *)options {
    if (!_options) {
        _options = [NSMutableArray array];
    }
    
    return _options;
}
@end
