//
//  HZAauthorizationViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/8/7.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZAauthorizationViewController.h"
#import "HZAuthorizationModel.h"

#define kCellIdentifier @"authorizationCellIdentifier"

@interface HZAauthorizationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray<HZAuthorizationModel *> *> *dataArray;

@end

@implementation HZAauthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"应用授权";
    [self.view addSubview:self.tableView];
    UIBarButtonItem *authorizationBtn = [[UIBarButtonItem alloc] initWithTitle:@"授权" style:UIBarButtonItemStylePlain target:self action:@selector(jumpAction)];
    self.navigationItem.rightBarButtonItem = authorizationBtn;
}


- (void)showWithGrandted:(BOOL)grandted description:(NSString *)description {
    
    NSString *status = @"未授权";
    if (grandted) {
        status = @"已授权";
    }
    
    NSString *desc = @"";
    if (description && description.length > 0) {
        desc = [NSString stringWithFormat:@" - %@", description];
    }
    
    NSString *message = [NSString stringWithFormat:@"%@%@", status, desc];
    
    HZShowHUD(message);
}

#pragma mark - Action
- (void)jumpAction {
    [HZAuthorization toAuthorization];
}

- (void)authorizationNFCAction {
    [HZAuthorization authorizationType:HZAuthorizationNFC completionHandler:^(BOOL grandted, NSString *description) {
        [self showWithGrandted:grandted description:description];
    }];
}

- (void)authorizationMediaLibraryAction {
    
}

- (void)authorizationBluetoothAction {
    
}

- (void)authorizationCalendarsAction {
    
}

- (void)authorizationCameraAction {
    
    [HZAuthorization authorizationType:HZAuthorizationCamera completionHandler:^(BOOL grandted, NSString *description) {
        [self showWithGrandted:grandted description:description];
    }];
}

- (void)authorizationContactsAction {
    
}

- (void)authorizationFaceIDAction {
    
}

- (void)authorizationHealthAction {
    
}

- (void)authorizationHomeKitAction {
    
}

- (void)authorizationLocationAction {
    [HZAuthorization authorizationType:HZAuthorizationLocation completionHandler:^(BOOL grandted, NSString *description) {
        [self showWithGrandted:grandted description:description];
    }];
}

- (void)authorizationMicrophoneAction {
    
}

- (void)authorizationMotionAction {
    
}

- (void)authorizationPhotoLibraryAction {
    
}

- (void)authorizationRemindersAction {
    
}

- (void)authorizationTVAction {
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    HZAuthorizationModel *model = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subtitle;
    
    UIColor *textColor = [UIColor blackColor];
    if (model.clicked) {
        textColor = [UIColor grayColor];
    }
    
    cell.textLabel.textColor = textColor;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Hardware";
    } else if (section == 1) {
        return @"Software";
    } else {
        return @"Unknown";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HZAuthorizationModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (model.clicked == NO) {
        model.clicked = YES;
        [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    NSString *action = model.action;
    if (action) {
        SEL selector = NSSelectorFromString(action);
        if ([self respondsToSelector:selector]) {
            HLog(@"call %@", action);
            
            ((void (*)(id, SEL))objc_msgSend)(self, selector);
        }
    }
}

#pragma mark - Lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSMutableArray<NSArray<HZAuthorizationModel *> *> *)dataArray {
    if (!_dataArray) {
        // 共15个：相机、相册、位置、麦克风、运动与健康、通讯录、NFC、媒体库、蓝牙、日历、Face ID、健康、HomeKit、Reminders、TV
        // 硬件7个：相机、位置、麦克风、运动与健康、NFC、蓝牙、Face ID
        // 软件3个：相册、通讯录、日历
        // 未确定5个：媒体库、健康、HomeKit、Reminders、TV
        NSArray *hardwareArray = @[
                                   [HZAuthorizationModel modelWithTitle:@"Camera - 相机" subtitle:@"Setting Info.plist" action:@"authorizationCameraAction"],
                                   [HZAuthorizationModel modelWithTitle:@"Location - 位置" subtitle:@"Setting Info.plist" action:@"authorizationLocationAction"],
                                   [HZAuthorizationModel modelWithTitle:@"Microphone - 麦克风" subtitle:@"Unfinished" action:@"authorizationMicrophoneAction"],
                                   [HZAuthorizationModel modelWithTitle:@"Motion - 运动与健身" subtitle:@"Unfinished" action:@"authorizationMotionAction"],
                                   [HZAuthorizationModel modelWithTitle:@"NFC Reader" subtitle:@"Settings Info.plist, open Capabilities" action:@"authorizationNFCAction"],
                                   [HZAuthorizationModel modelWithTitle:@"Bluetooth Peripheral - 蓝牙外设" subtitle:@"Unfinished" action:@"authorizationBluetoothAction"],
                                    [HZAuthorizationModel modelWithTitle:@"Face ID" subtitle:@"Unfinished" action:@"authorizationFaceIDAction"]
                                   ];
        
        NSArray *softwareArray = @[
                                   [HZAuthorizationModel modelWithTitle:@"Photo Library - 照片" subtitle:@"Unfinished" action:@"authorizationPhotoLibraryAction"],
                                   [HZAuthorizationModel modelWithTitle:@"Contacts - 通讯录" subtitle:@"Unfinished" action:@"authorizationContactsAction"],
                                   [HZAuthorizationModel modelWithTitle:@"Calendars - 日历" subtitle:@"Unfinished" action:@"authorizationCalendarsAction"],
                                   
                                   ];
        NSArray *unknownArray = @[
                                 [HZAuthorizationModel modelWithTitle:@"Media Library - 媒体库" subtitle:@"Unfinished" action:@"authorizationMediaLibraryAction"],
                                 [HZAuthorizationModel modelWithTitle:@"Health Share - 健康" subtitle:@"Unfinished" action:@"authorizationHealthAction"],
                                 [HZAuthorizationModel modelWithTitle:@"HomeKit" subtitle:@"Unfinished" action:@"authorizationHomeKitAction"],
                                 [HZAuthorizationModel modelWithTitle:@"Reminders" subtitle:@"Unfinished" action:@"authorizationRemindersAction"],
                                 [HZAuthorizationModel modelWithTitle:@"TV Provider" subtitle:@"Unfinished" action:@"authorizationTVAction"]
                                 ];
        
        _dataArray = [NSMutableArray arrayWithObjects: hardwareArray, softwareArray, unknownArray, nil];
    }
    
    return _dataArray;
}

@end
