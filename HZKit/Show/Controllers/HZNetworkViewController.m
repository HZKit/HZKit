//
//  HZNetworkViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/9/29.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZNetworkViewController.h"

#import "HZBaseModel.h"
#import "HZNetworkModel.h"

#define HZ_NETWORK_ADD_LOG(log) \
    self.logTextView.text = [NSString stringWithFormat:@"%@%@\n", self.logTextView.text, log];

NSString *kTempServerURL = @"http://api.douban.com/v2/";
NSString *kTempApiName = @"movie/nowplaying";
NSString *kTempKey = @"apikey";
NSString *kTempValue = @"0df993c66c0c636e29ecbb5344252a4a";

// http://api.douban.com/v2/movie/nowplaying?apikey=0df993c66c0c636e29ecbb5344252a4a

typedef NS_ENUM(NSUInteger, HZNetworkRequestType) {
    HZNetworkRequestPOST,
    HZNetworkRequestGET,
};

@interface HZNetworkViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *serverURLTF; // 服务器地址
@property (nonatomic, strong) UITextField *apiTF; // API名称
@property (nonatomic, strong) UIButton *requestBtn; // 请求按钮
@property (nonatomic, strong) UITableView *paramsList; // 参数列表
@property (nonatomic, strong) UISegmentedControl *requestTypeSegmented; // POST/GET
@property (nonatomic, strong) UITextView *logTextView; // log视图
@property (nonatomic, strong) NSMutableArray<HZBaseModel *> *paramsArray; // 参数

@end

@interface HZNetworkViewController ()

@end

@implementation HZNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = HZShowLocalizedString("networkViewTitle");
    
    [self initView];
}

- (void)viewDidLayoutSubviews {
    
    CGFloat margin = 30.0;
    CGFloat padding = margin * 0.5;
    CGFloat itemHeight = 44.0;
    __weak typeof(self) wself = self;
    
    [_requestTypeSegmented mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.mas_equalTo(margin);
        make.centerX.mas_equalTo(wself.view.mas_centerX);
    }];
    
    [_serverURLTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.mas_equalTo(wself.requestTypeSegmented.mas_bottom).offset(padding);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(itemHeight);
    }];
    
    [_requestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.serverURLTF.mas_bottom).offset(padding);
        make.right.mas_equalTo(wself.serverURLTF.mas_right);
        make.size.mas_equalTo(CGSizeMake(itemHeight * 1.5, itemHeight));
    }];
    
    [_apiTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.serverURLTF.mas_left);
        make.top.mas_equalTo(wself.requestBtn.mas_top);
        make.right.mas_equalTo(wself.requestBtn.mas_left).offset(-padding);
        make.height.mas_equalTo(wself.serverURLTF.mas_height);
    }];
    
    [_paramsList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.serverURLTF.mas_left);
        make.top.mas_equalTo(wself.apiTF.mas_bottom).offset(padding);
        make.right.mas_equalTo(wself.serverURLTF.mas_right);
        make.height.mas_equalTo(itemHeight * 3);
    }];
    
    [_logTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.serverURLTF.mas_left);
        make.top.mas_equalTo(wself.paramsList.mas_bottom).offset(padding);
        make.right.mas_equalTo(wself.serverURLTF.mas_right);
        make.bottomMargin.mas_equalTo(-margin);
    }];
}

- (void)initView {
    _requestTypeSegmented = [[UISegmentedControl alloc] initWithItems:@[@"POST", @"GET"]];
    _requestTypeSegmented.selectedSegmentIndex = HZNetworkRequestPOST;
    [self.view addSubview:_requestTypeSegmented];
    
    _serverURLTF = [[UITextField alloc] init];
    _serverURLTF.borderStyle = UITextBorderStyleBezel;
    _serverURLTF.text = kTempServerURL;
    _serverURLTF.placeholder = @"输入服务器地址";
    [self.view addSubview:_serverURLTF];
    
    _apiTF = [[UITextField alloc] init];
    _apiTF.borderStyle = UITextBorderStyleBezel;
    _apiTF.text = kTempApiName;
    _apiTF.placeholder = @"输入接口名称";
    [self.view addSubview:_apiTF];
    
    _requestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_requestBtn setTitle:HZShowLocalizedString("networkSend") forState:UIControlStateNormal];
    [_requestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_requestBtn addTarget:self action:@selector(sendRequestAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_requestBtn];
    
    _paramsList = [[UITableView alloc] init];
    _paramsList.backgroundColor = nil;
    _paramsList.delegate = self;
    _paramsList.dataSource = self;
    [self.view addSubview:_paramsList];
    
    _logTextView = [[UITextView alloc] init];
    _logTextView.editable = NO;
    _logTextView.backgroundColor = nil;
    _logTextView.textColor = [UIColor blackColor];
    _logTextView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_logTextView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:HZShowLocalizedString("networkClean")
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(cleanLogAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Action
- (void)cleanLogAction {
    self.logTextView.text = nil;
}

- (void)sendRequestAction:(UIButton *)sender {
    sender.enabled = NO;
    
    HZ_NETWORK_ADD_LOG(@"准备发起请求")
    NSString *serverURL = self.serverURLTF.text;
    NSString *apiName = self.apiTF.text;
    
    NSString *apiURL = [NSString stringWithFormat:@"%@%@", serverURL, apiName];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:self.paramsArray.count];
    for (HZBaseModel *model in self.paramsArray) {
        [parameters setObject:model.subtitle forKey:model.title];
    }
    
    if (self.requestTypeSegmented.selectedSegmentIndex == HZNetworkRequestPOST) {
        HZ_NETWORK_ADD_LOG(@"POST:")
        HZ_NETWORK_ADD_LOG(apiURL)
        HZ_NETWORK_ADD_LOG(parameters)
        [HZNetworkClient postURL:apiURL
                      parameters:parameters
                      modelClass:[HZNetworkModel class]
                      responseObject:^(HZDataResponse * _Nonnull response) {
                          sender.enabled = YES;
                          
                          if (response.error) {
                              HZ_NETWORK_ADD_LOG(@"请求失败")
                          } else {
                              HZ_NETWORK_ADD_LOG(@"请求成功")
                              HZNetworkModel *model = response.model;
                              if (model) {
                                  NSString *text = [NSString stringWithFormat:@"title:%@", model.title];
                                  HZ_NETWORK_ADD_LOG(text)
                              }
                          }
                          
                          HZ_NETWORK_ADD_LOG(@"====== end ======")
                      }];
    } else if (self.requestTypeSegmented.selectedSegmentIndex == HZNetworkRequestGET) {
        HZ_NETWORK_ADD_LOG(@"GET:")
        
        NSMutableString *getURL = [NSMutableString stringWithFormat:@"%@?", apiURL];
        for (HZBaseModel *model in self.paramsArray) {
            NSString *parmeter = [NSString stringWithFormat:@"%@=%@", model.title, model.subtitle];
            [getURL stringByAppendingString:parmeter];
        }
        
        HZ_NETWORK_ADD_LOG(getURL)
        [HZNetworkClient getURL:getURL
                     parameters:parameters
                     modelClass:[HZNetworkModel class]
                 responseObject:^(HZDataResponse * _Nonnull response) {
                     sender.enabled = YES;
                     
                     if (response.error) {
                         HZ_NETWORK_ADD_LOG(@"请求失败")
                     } else {
                         HZ_NETWORK_ADD_LOG(@"请求成功")
                         HZNetworkModel *model = response.model;
                         if (model) {
                             NSString *text = [NSString stringWithFormat:@"title:%@", model.title];
                             HZ_NETWORK_ADD_LOG(text)
                         }
                     }
                     
                     HZ_NETWORK_ADD_LOG(@"====== end ======")
                 }];
    }
    
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paramsArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // add
    if (indexPath.row == self.paramsArray.count) {
        static NSString *addCellIdentifier = @"addParamsCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCellIdentifier];
            cell.textLabel.frame = cell.bounds;
            cell.textLabel.text = @"Add";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.backgroundColor = nil;
        }
        
        return cell;
    }
    
    // common
    static NSString *cellIdentifier = @"paramsCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = nil;
    }
    
    HZBaseModel *model = self.paramsArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subtitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isAdd = (indexPath.row == self.paramsArray.count);
    
    HZBaseModel *tempModel = nil;
    NSString *alertTitle = @"添加参数";
    if (isAdd == NO) {
        alertTitle = @"更新参数";
        tempModel = self.paramsArray[indexPath.row];
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"参数"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"key";
        if (tempModel) {
            textField.text = tempModel.title;
        }
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"value";
        if (tempModel) {
            textField.text = tempModel.subtitle;
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *key = alert.textFields.firstObject.text;
        NSString *value = alert.textFields.lastObject.text;
        
        if (key && value && key.length > 0 && value.length > 0) {
           
            // TODO: add or update
            if (isAdd) {
                HZBaseModel *model = [[HZBaseModel alloc] init];
                model.title = key;
                model.subtitle = value;
                
                [self.paramsArray addObject:model];
                [self.paramsList insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                tempModel.title = key;
                tempModel.subtitle = value;
                [self.paramsList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return HZShowLocalizedString("networkParams");
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row != self.paramsArray.count);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.paramsArray removeObjectAtIndex:indexPath.row];
    [self.paramsList deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Lazy load
- (NSMutableArray<HZBaseModel *> *)paramsArray {
    if (!_paramsArray) {
        _paramsArray = [NSMutableArray array];
        
        HZBaseModel *model = [[HZBaseModel alloc] init];
        model.title = kTempKey;
        model.subtitle = kTempValue;
        
        [self.paramsArray addObject:model];
    }
    
    return _paramsArray;
}

@end
