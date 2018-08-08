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
@property (nonatomic, strong) NSMutableArray<HZAuthorizationModel *> *dataArray;

@end

@implementation HZAauthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = HZShowLocalizedString("authorizationViewTitle");
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)authorizationNFCAction {
    
}

- (void)authorizationMediaLibraryAction {
    
}

- (void)authorizationBluetoothAction {
    
}

- (void)authorizationCalendarsAction {
    
}

- (void)authorizationCameraAction {
    
    [HZAuthorization authorizationType:HZAuthorizationCamera completionHandler:^(BOOL grandted, NSString *description) {
        
        NSString *message = @"未授权";
        if (grandted) {
            message = @"已授权";
        }
        
        HZShowHUD(message);
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    HZAuthorizationModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    
    UIColor *textColor = [UIColor blackColor];
    if (model.clicked) {
        textColor = [UIColor grayColor];
    }
    
    cell.textLabel.textColor = textColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HZAuthorizationModel *model = self.dataArray[indexPath.row];
    if (model.clicked == NO) {
        model.clicked = YES;
        [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    NSString *action = model.action;
    if (action) {
        SEL selector = NSSelectorFromString(action);
        if ([self respondsToSelector:selector]) {
#if DEBUG
            NSLog(@"call %@", action);
#endif
            objc_msgSend(self, selector);
        }
    }
}

#pragma mark - Lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSMutableArray<HZAuthorizationModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationNFC") subtitle:nil action:@"authorizationNFCAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationMediaLibrary") subtitle:nil action:@"authorizationMediaLibraryAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationBluetooth") subtitle:nil action:@"authorizationBluetoothAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationCalendars") subtitle:nil action:@"authorizationCalendarsAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationCamera") subtitle:nil action:@"authorizationCameraAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationContacts") subtitle:nil action:@"authorizationContactsAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationFaceID") subtitle:nil action:@"authorizationFaceIDAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationHealth") subtitle:nil action:@"authorizationHealthAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationHomeKit") subtitle:nil action:@"authorizationHomeKitAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationLocation") subtitle:nil action:@"authorizationLocationAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationMicrophone") subtitle:nil action:@"authorizationMicrophoneAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationMotion") subtitle:nil action:@"authorizationMotionAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationPhotoLibrary") subtitle:nil action:@"authorizationPhotoLibraryAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationReminders") subtitle:nil action:@"authorizationRemindersAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationTV") subtitle:nil action:@"authorizationTVAction"],
                      nil];
    }
    
    return _dataArray;
}

@end
