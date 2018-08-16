//
//  HZScanViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/8/10.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZScanViewController.h"
#import <AVFoundation/AVFoundation.h>

NSString *const HZScanViewStringValueBlockKey = @"scanViewStringValueBlock";

#define kHZScanAnimationTimeInterval 3.0f

@interface HZScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, assign) CGRect scanArea; // Scan the effective area
@property (nonatomic, strong) UIView *focusScopeView; // 对焦范围view // 对焦范围view
@property (nonatomic, strong) UIView *focusView; // 对焦效果view
@property (nonatomic, strong) UIButton *flashlightBtn; // 手电筒
@property (nonatomic, strong) UIView *scanAnimationView; // 扫一扫
@property (nonatomic, strong) UIImageView *scanAnimationLayer; // 扫一扫动画图层
@property (nonatomic, strong) NSTimer *scanAnimationTimer; // 动画计时器

@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) BOOL tabBarHidden;
@property (nonatomic, assign) BOOL navigationBarHidden;

@property (nonatomic, assign) BOOL usageDelegate;

@end

@implementation HZScanViewController

- (instancetype)initWithArgs:(NSDictionary *)args {
    self = [super init];
    if (self) {
        HZScanViewStringValueBlock stringValueBlock = args[HZScanViewStringValueBlockKey];
        if (stringValueBlock) {
            _stringValueBlock = [stringValueBlock copy];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    CGPoint origin = self.view.center;
    CGFloat areaWidth = 200;
    CGFloat areaHeight = 200;
    _scanArea = CGRectMake(origin.x - areaWidth * 0.5,
                           origin.y - areaHeight * 0.5,
                           areaWidth, areaHeight); // TODO: 调整
    HZScanMaskView *maskView = [HZScanMaskView maskViewWithFrame:self.view.bounds transparentFrame:_scanArea];
    [self.view addSubview:maskView];
    [self.view addSubview:self.scanAnimationView];
    [self.view addSubview:self.focusScopeView];
    [self.view addSubview:self.flashlightBtn];
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

#pragma mark - Action
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

#pragma mark - UITapGestureRecognizer
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
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
    
    [UIView animateWithDuration:0.3 animations:^{
        self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.focusView.hidden = YES;
        }];
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
    
    return maskView;
}

// TODO: 绘图
//- (void)drawRect:(CGRect)rect {
//    // 背景
//
//    // 四个角
//}

@end
