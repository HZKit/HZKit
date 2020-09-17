//
//  HZScanViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/8/10.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZScanViewController.h"
#import <AVFoundation/AVFoundation.h>

#ifndef HLog
    #if DEBUG
        #define HLog(fmt, ...) NSLog((@"%@ [line %u]: " fmt), NSStringFromClass(self.class), __LINE__, ##__VA_ARGS__)
    #else
        #define HLog(...)
    #endif
#endif

NSString *const kHZScanPhotoLibraryUnknown = @"No QR code found";

#define kHZScanAnimationTimeInterval 3.0f

@interface HZScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, assign) CGRect scanArea; // Scan the effective area
@property (nonatomic, strong) UIView *focusScopeView; // 对焦范围view // 对焦范围view
@property (nonatomic, strong) UIView *focusView; // 对焦效果view
@property (nonatomic, strong) UIButton *flashlightBtn; // 手电筒
@property (nonatomic, strong) UIButton *photoLibraryBtn; // 从相册选择
@property (nonatomic, strong) UIView *scanAnimationView; // 扫一扫
@property (nonatomic, strong) UIImageView *scanAnimationLayer; // 扫一扫动画图层
@property (nonatomic, strong) NSTimer *scanAnimationTimer; // 动画计时器

@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) BOOL tabBarHidden;
@property (nonatomic, assign) BOOL navigationBarHidden;

@property (nonatomic, assign) BOOL usageDelegate;

@end

@implementation HZScanViewController

+ (instancetype)scanViewWithArea:(CGRect)scanArea completion:(HZScanViewStringValueBlock)stringValueBlock {
    HZScanViewController *viewController = [[HZScanViewController alloc] init];
    viewController.scanArea = scanArea;
    viewController.stringValueBlock = stringValueBlock;
    viewController.hidesBottomBarWhenPushed = YES;
    
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
        
    HZScanMaskView *maskView = [HZScanMaskView maskViewWithFrame:self.view.bounds transparentFrame:_scanArea];
    [self.view addSubview:maskView];
    [self.view addSubview:self.scanAnimationView];
    [self.view addSubview:self.focusScopeView];
    [self.view addSubview:self.flashlightBtn];
    [self.view addSubview:self.photoLibraryBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_session) {
        [self.session startRunning];
        self.output.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:self.scanArea];
        
        [self.scanAnimationTimer setFireDate:[NSDate date]];
    }
    
    self.statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    if (self.tabBarController) {
        self.tabBarHidden = self.tabBarController.tabBar.hidden;
        self.tabBarController.tabBar.hidden = YES;
    }
    
//    if (self.navigationController) {
//        self.navigationBarHidden = self.navigationController.navigationBar.hidden;
//        self.navigationController.navigationBar.hidden = YES;
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_session) {
        [self.session stopRunning];
    }
    
    if (_scanAnimationTimer) {
        [_scanAnimationTimer invalidate];
        _scanAnimationTimer = nil;
    }
    
    [UIApplication sharedApplication].statusBarHidden = self.statusBarHidden;
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = self.tabBarHidden;
    }
    
//    if (self.navigationController) {
//        self.navigationController.navigationBar.hidden = self.navigationBarHidden;
//    }
}

#pragma mark - Private
- (void)setDelegate:(id<HZScanViewControllerDelegate>)delegate {
    if (!_delegate || _delegate != delegate) {
        _delegate = delegate;
        
        if ([delegate respondsToSelector:@selector(scanViewController:stringValue:)]) {
            _usageDelegate = YES;
        }
    }
}

- (void)scanAnimation {
    self.scanAnimationLayer.hidden = NO;
    // TODO: 优化，使用 layer
    CGSize imageSize = self.scanAnimationLayer.bounds.size;
    CGRect endFrame = CGRectMake(0, CGRectGetHeight(self.scanAnimationView.bounds) + imageSize.height,
                                 imageSize.width, imageSize.height);
    
    CGRect startFrame = CGRectMake(0, 0 - imageSize.height, imageSize.width, imageSize.height);
    
    [UIView animateWithDuration:kHZScanAnimationTimeInterval * 0.5
                     animations:^{
                         self.scanAnimationLayer.frame = endFrame;
                     }
                     completion:^(BOOL finished) {
                         self.scanAnimationLayer.hidden = YES;
                         
                         self.scanAnimationLayer.frame = startFrame;
                     }];
}

- (void)stringFromImage:(UIImage *)image {
    NSString *stringValue = [self stringValueFromImage:image];
    if (!stringValue) {
        stringValue = kHZScanPhotoLibraryUnknown;
    }
    
    if (_usageDelegate) {
        [_delegate scanViewController:self stringValue:stringValue];
    }
    
    if (_stringValueBlock) {
        _stringValueBlock(stringValue);
    }
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        NSString *stringValue = metadataObject.stringValue;
        if (_usageDelegate) {
            [_delegate scanViewController:self stringValue:stringValue];
        }
        
        if (_stringValueBlock) {
            _stringValueBlock(stringValue);
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // TODO: 优化，压缩
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self stringFromImage:image];
    HLog(@"%@", info);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action
/**
 开灯/关灯

 @param btn 按钮
 */
- (void)switchFlashlightAction:(UIButton *)btn {
    if ([self.device hasTorch] && [self.device hasFlash]) {
        btn.selected = !btn.selected;
        
        [self.device lockForConfiguration:nil];
        if (btn.selected) {
            // 打开
            [self.device setTorchMode:AVCaptureTorchModeOn];
            [self.device setFlashMode:AVCaptureFlashModeOn];
        } else {
            // 关闭
            [self.device setTorchMode:AVCaptureTorchModeOff];
            [self.device setFlashMode:AVCaptureFlashModeOff];
        }
        [self.device unlockForConfiguration];
    }
}

/**
 打开相册，从照片中获取信息

 @param btn 按钮
 */
- (void)openPhotoLibraryAction:(UIButton *)btn {
    // TODO: 打开相册优化，优先使用已封装的类访问，未 import 再使用 UIImagePickerController
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UITapGestureRecognizer
- (void)focusGesture:(UITapGestureRecognizer*)gesture {

    [self.focusView.layer removeAllAnimations]; // 移除动画
    
    CGPoint point = [gesture locationInView:gesture.view];
    CGSize size = self.view.bounds.size;
    
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        [self.device unlockForConfiguration];
    }
    
    // 手触碰屏幕后对焦的效果
    _focusView.center = point;
    _focusView.hidden = NO;
    
    self.focusView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [UIView animateWithDuration:0.3 animations:^{
        self.focusView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.focusView.hidden = YES;
    }];
}

#pragma mark - Lazy load
- (AVCaptureDevice *)device {
    if (!_device) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        _device = device;
    }
    
    return _device;
}

- (AVCaptureDeviceInput *)input {
    if (!_input) {
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil]; // TODO: error 处理
        
        _input = input;
    }
    
    return _input;
}

- (AVCaptureMetadataOutput *)output {
    if (!_output) {
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        _output = output;
    }
    
    return _output;
}

- (AVCaptureSession *)session {
    if (!_session) {
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([session canAddInput:self.input]) {
            [session addInput:self.input];
        }
        
        if ([session canAddOutput:self.output]) {
            [session addOutput:self.output];
            
            self.output.metadataObjectTypes = @[
                                           AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeAztecCode,
                                           AVMetadataObjectTypePDF417Code,
                                           AVMetadataObjectTypeCode128Code,
                                           AVMetadataObjectTypeCode93Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeCode39Mod43Code,
                                           AVMetadataObjectTypeCode39Code,
                                           AVMetadataObjectTypeUPCECode,
                                           AVMetadataObjectTypeDataMatrixCode
                                           ];

        }
        
        _session = session;
    }
    
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.frame = self.view.layer.bounds;
        
        _previewLayer = previewLayer;
    }
    
    return _previewLayer;
}

- (UIView *)focusScopeView {
    if (!_focusScopeView) {
        UIView *view = [[UIView alloc] initWithFrame:self.scanArea];
        view.backgroundColor = nil;
        
        // 对焦手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
        [view addGestureRecognizer:tapGesture];
        
        [view addSubview:self.focusView];
        
        _focusScopeView = view;
    }
    
    return _focusScopeView;
}

- (UIView *)focusView {
    if (!_focusView) {
        // 对焦效果view
        _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor = [UIColor greenColor].CGColor;
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.hidden = YES;
    }
    
    return _focusView;
}

- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        CGPoint origin = CGPointMake(self.view.center.x, CGRectGetMaxY(self.scanArea) + 30);
        CGRect frame = CGRectMake(0, 0, 80, 30);
        _flashlightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashlightBtn.frame = frame;
        _flashlightBtn.center = origin;
        _flashlightBtn.backgroundColor = nil;
        _flashlightBtn.selected = NO;
        [_flashlightBtn setTitle:@"点击照明" forState:UIControlStateNormal];
        [_flashlightBtn setTitle:@"关闭照明" forState:UIControlStateSelected];
        _flashlightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_flashlightBtn addTarget:self action:@selector(switchFlashlightAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _flashlightBtn.layer.cornerRadius = 5;
        _flashlightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _flashlightBtn.layer.borderWidth = 0.8;
        _flashlightBtn.layer.masksToBounds = YES;
    }
    
    return _flashlightBtn;
}

- (UIButton *)photoLibraryBtn {
    if (!_photoLibraryBtn) {
        CGPoint origin = CGPointMake(self.view.center.x, CGRectGetMaxY(self.scanArea) + 70);
        CGRect frame = CGRectMake(0, 0, 80, 30);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.center = origin;
        button.backgroundColor = nil;
        button.selected = NO;
        [button setTitle:@"相 册" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(openPhotoLibraryAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 0.8;
        button.layer.masksToBounds = YES;
        
        _photoLibraryBtn = button;
    }
    
    return _photoLibraryBtn;
}

- (UIView *)scanAnimationView {
    if (!_scanAnimationView) {
        UIView *view = [[UIView alloc] initWithFrame:self.scanArea];
        view.backgroundColor = [UIColor clearColor];
        view.clipsToBounds = YES;
        [view addSubview:self.scanAnimationLayer];
        
        _scanAnimationView = view;
    }
    
    return _scanAnimationView;
}

- (UIImageView *)scanAnimationLayer {
    if (!_scanAnimationLayer) {
        
        // layer
        CAGradientLayer *layer = [CAGradientLayer layer];
        
        layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.scanArea), 3);
        layer.colors = @[(id)[[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor,
                         (id)[[UIColor greenColor] colorWithAlphaComponent:0.8].CGColor,
                         (id)[[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor];
        layer.locations = @[@(0.05), @(0.5), @(0.95)];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 0);
        
        // image
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
        [layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        CGRect frame = CGRectMake(0, 0 - CGRectGetHeight(layer.frame),
                                  CGRectGetWidth(layer.frame),
                                  CGRectGetHeight(layer.frame));
        UIImageView *scanAnimationLayer = [[UIImageView alloc] initWithFrame:frame];
        scanAnimationLayer.backgroundColor = [UIColor clearColor];
        scanAnimationLayer.image = image;
        scanAnimationLayer.hidden = YES;

        _scanAnimationLayer = scanAnimationLayer;
    }
    
    return _scanAnimationLayer;
}

- (NSTimer *)scanAnimationTimer {
    if (!_scanAnimationTimer) {
        _scanAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:kHZScanAnimationTimeInterval
                                                               target:self
                                                             selector:@selector(scanAnimation) userInfo:nil
                                                              repeats:YES];
    }
    
    return _scanAnimationTimer;
}

#pragma mark - Dealloc
- (void)dealloc {
    HLog(@"%@ dealloc", NSStringFromClass(self.class));
}

@end

@implementation HZScanViewController (Image)

- (NSString *)stringValueFromImage:(UIImage *)image {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{
                                                        CIDetectorAccuracy : CIDetectorAccuracyHigh
                                                        }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    CIQRCodeFeature *feature = features.firstObject;
    NSString *stringValue = [feature.messageString mutableCopy];
    return stringValue;
}

@end

#pragma mark - HZScanMaskView
@interface HZScanMaskView()


@end

@implementation HZScanMaskView

+ (instancetype)maskViewWithFrame:(CGRect)frame transparentFrame:(CGRect)transparentFrame {
    HZScanMaskView *maskView = [[HZScanMaskView alloc] initWithFrame:frame];
    maskView.backgroundColor = [UIColor clearColor];
    
    // 空心矩形
    CAShapeLayer *bgLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef bgLayerPath = CGPathCreateMutable();
    CGPathAddRect(bgLayerPath, nil, maskView.bounds);
    CGPathAddRect(bgLayerPath, nil, transparentFrame);
    [bgLayer setFillRule:kCAFillRuleEvenOdd];
    [bgLayer setPath:bgLayerPath];
    [bgLayer setFillColor:[UIColor colorWithWhite:0 alpha:0.2].CGColor];
    [maskView.layer addSublayer:bgLayer];
    
    // 白线
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = transparentFrame;
    lineLayer.borderWidth = 0.5;
    lineLayer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    [maskView.layer addSublayer:lineLayer];
    
    // 四个角
    CGFloat lineLength = 20;
    CGFloat lineWidth = 2;
    
    CGFloat minX = CGRectGetMinX(transparentFrame);
    CGFloat maxX = CGRectGetMaxX(transparentFrame);
    CGFloat minY = CGRectGetMinY(transparentFrame);
    CGFloat maxY = CGRectGetMaxY(transparentFrame);
    
    /// 左上角
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(minX, minY + lineLength)];
    [linePath addLineToPoint:CGPointMake(minX, minY)];
    [linePath addLineToPoint:CGPointMake(minX + lineLength, minY)];
    /// 右上角
    [linePath moveToPoint:CGPointMake(maxX - lineLength, minY)];
    [linePath addLineToPoint:CGPointMake(maxX, minY)];
    [linePath addLineToPoint:CGPointMake(maxX, minY + lineLength)];
    /// 右下角
    [linePath moveToPoint:CGPointMake(maxX, maxY - lineLength)];
    [linePath addLineToPoint:CGPointMake(maxX, maxY)];
    [linePath addLineToPoint:CGPointMake(maxX - lineLength, maxY)];
    /// 左下角
    [linePath moveToPoint:CGPointMake(minX + lineLength, maxY)];
    [linePath addLineToPoint:CGPointMake(minX, maxY)];
    [linePath addLineToPoint:CGPointMake(minX, maxY - lineLength)];
    
    CAShapeLayer *superscriptLayer = [CAShapeLayer layer];
    superscriptLayer.lineWidth = lineWidth;
    superscriptLayer.strokeColor = [UIColor greenColor].CGColor;
    superscriptLayer.path = linePath.CGPath;
    superscriptLayer.fillColor = nil;
    
    [maskView.layer addSublayer:superscriptLayer];
    
    return maskView;
}

// TODO: 绘图
//- (void)drawRect:(CGRect)rect {
//    // 背景
//
//    // 四个角
//}

@end
