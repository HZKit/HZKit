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
    UIBarButtonItem *authorizationBtn = [[UIBarButtonItem alloc] initWithTitle:HZShowLocalizedString("authorizationJumpButtonTitle") style:UIBarButtonItemStylePlain target:self action:@selector(jumpAction)];
    self.navigationItem.rightBarButtonItem = authorizationBtn;
}


- (void)showWithGrandted:(BOOL)grandted description:(NSString *)description {
    
    NSString *status = HZAlertLocalizedString("unauthorized");
    if (grandted) {
        status = HZAlertLocalizedString("authorized");
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
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    HZAuthorizationModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subtitle;
    
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
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSMutableArray<HZAuthorizationModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationNFC") subtitle:@"Settings Info.plist, open Capabilities" action:@"authorizationNFCAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationMediaLibrary") subtitle:@"Unfinished" action:@"authorizationMediaLibraryAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationBluetooth") subtitle:@"Unfinished" action:@"authorizationBluetoothAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationCalendars") subtitle:@"Unfinished" action:@"authorizationCalendarsAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationCamera") subtitle:@"Setting Info.plist" action:@"authorizationCameraAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationContacts") subtitle:@"Unfinished" action:@"authorizationContactsAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationFaceID") subtitle:@"Unfinished" action:@"authorizationFaceIDAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationHealth") subtitle:@"Unfinished" action:@"authorizationHealthAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationHomeKit") subtitle:@"Unfinished" action:@"authorizationHomeKitAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationLocation") subtitle:@"Unfinished" action:@"authorizationLocationAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationMicrophone") subtitle:@"Unfinished" action:@"authorizationMicrophoneAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationMotion") subtitle:@"Unfinished" action:@"authorizationMotionAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationPhotoLibrary") subtitle:@"Unfinished" action:@"authorizationPhotoLibraryAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationReminders") subtitle:@"Unfinished" action:@"authorizationRemindersAction"],
                      [HZAuthorizationModel modelWithTitle:HZShowLocalizedString("authorizationTV") subtitle:@"Unfinished" action:@"authorizationTVAction"],
                      nil];
    }
    
    return _dataArray;
}

@end
