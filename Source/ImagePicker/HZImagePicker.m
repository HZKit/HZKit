//
//  HZImagePicker.m
//  HZKitExample
//
//  Created by Wang, Haizhou on 2020/9/27.
//  Copyright © 2020 Hertz Wang. All rights reserved.
//

#import "HZImagePicker.h"

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface HZImagePicker () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

API_AVAILABLE(ios(14))
@interface HZImagePicker () <PHPickerViewControllerDelegate>

@property (nonatomic, strong) PHPickerViewController *picker;

@end

@implementation HZImagePicker

- (instancetype)init {
    self = [super init];
    if (self) {
        _allowsVideo = NO;
        _allowsEditing = NO;
        _allowsLivePhotos = NO;
        _selectionLimit = 1;
    }
    return self;
}

#pragma mark - Public

- (void)show {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet)];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self _cameraAction];
        }];
        [actionSheet addAction:cameraAction];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self _photoLibraryAction];
        }];
        [actionSheet addAction:photoLibraryAction];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self _presentViewController:actionSheet];
}

#pragma mark - Private

- (void)_presentViewController:(UIViewController *)viewController {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewController animated:YES completion:nil];
}

/// 相册选择
- (void)_photoLibraryAction {
    if (@available(iOS 14.0, *)) {
        self.picker.configuration.selectionLimit = self.selectionLimit;
        NSMutableArray *filterArray = @[[PHPickerFilter imagesFilter]].mutableCopy;
        if (self.allowsLivePhotos) {
            [filterArray addObject:[PHPickerFilter livePhotosFilter]];
        }
        if (self.allowsVideo) {
            [filterArray addObject:[PHPickerFilter videosFilter]];
        }
        self.picker.configuration.filter = [PHPickerFilter anyFilterMatchingSubfilters:filterArray];
        [self _presentViewController:self.picker];
    } else {
        self.imagePicker.allowsEditing = self.allowsEditing;
        [self _presentViewController:self.imagePicker];
    }
}

#pragma mark - PHPickerViewControllerDelegate

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)){
    if (results.count > 0) {
        
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
            [self.delegate imagePickerDidCancel:self];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Lazyload

- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

- (PHPickerViewController *)picker API_AVAILABLE(ios(14)){
    if (_picker == nil) {
        PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] initWithPhotoLibrary:[PHPhotoLibrary sharedPhotoLibrary]];
        _picker = [[PHPickerViewController alloc] initWithConfiguration:configuration];
        _picker.modalPresentationStyle = UIModalPresentationFullScreen;
        _picker.delegate = self;
    }
    return _picker;
}

@end
