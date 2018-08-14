//
//  HZScanViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/8/10.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface HZScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, assign) CGRect scanArea; // Scan the effective area

@property (nonatomic, assign) BOOL tabBarHidden;
@property (nonatomic, assign) BOOL navigationBarHidden;

@end

@implementation HZScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    

    _scanArea = CGRectMake(100, 100, 200, 200); // TODO: 调整
    HZScanMaskView *maskView = [HZScanMaskView maskViewWithFrame:self.view.bounds transparentFrame:_scanArea];
    [self.view addSubview:maskView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_session) {
        [self.session startRunning];
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.output.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:self.scanArea];
    });
    
    if (self.tabBarController) {
        self.tabBarHidden = self.tabBarController.tabBar.hidden;
        self.tabBarController.tabBar.hidden = YES;
    }
    
    if (self.navigationController) {
        self.navigationBarHidden = self.navigationController.navigationBar.hidden;
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_session) {
        [self.session stopRunning];
    }
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = self.tabBarHidden;
    }
    
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden = self.navigationBarHidden;
    }
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
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
