
#import "BWQRScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import "BWQRScanMaskView.h"
#import "GTMBase64.h"


@interface BWQRScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) QRCodeResult scanCodeResult;

/** 相机 */
@property (nonatomic, strong) AVCaptureDevice *device;
/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 相机图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
/** 扫描支持的编码格式的数组 */
@property (nonatomic, strong) NSMutableArray *metadataObjectTypes;
/** 遮罩层 */
@property (nonatomic, strong) BWQRScanMaskView *maskView;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *prctureBoxBtn;
@property (nonatomic, strong) UIButton *torchBtn;

@end

@implementation BWQRScanViewController

- (NSMutableArray *)metadataObjectTypes{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil];
        
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
        }
    }
    
    return _metadataObjectTypes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _navTitle;
    [self capture];
    [self addUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.session startRunning];
    [self.maskView startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (BOOL)shouldAutorotate {
    return NO;
}
/**
 *  添加遮罩层
 */
- (void)addUI {
    self.maskView = [[BWQRScanMaskView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.maskView.alpha = 0.9;
    if (self.descString) {
        self.maskView.descString = self.descString;
    }
    [self.view addSubview:self.maskView];
    
    
    //手电筒开关
    self.torchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.torchBtn.frame = CGRectMake(kScreenW/2 - 8, kScreenH/2, 18, 18);
//    [torchBtn setTitle:@"flash" forState:UIControlStateNormal];
//    torchBtn.backgroundColor = [UIColor redColor];
    [self.torchBtn setImage:[UIImage imageNamed:@"light_icon"] forState:0];
//    [torchBtn setImageEdgeInsets:UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)];
    

    [self.torchBtn addTarget:self action:@selector(torchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.torchBtn];
    
    //取消按钮
    CGFloat cancel_width = 80;
    CGFloat cancel_height = 35;

    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame = CGRectMake(0, 25, cancel_width, cancel_height);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTintColor:[UIColor whiteColor]];
    self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
//    [self.cancelButton setTintColor:[UIColor colorWithDisplayP3Red:0.00 green:0.47 blue:0.80 alpha:1.00]];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:self.cancelButton];
    
    
    self.prctureBoxBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.prctureBoxBtn.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - cancel_width, 25, cancel_width, cancel_height);
    
    [self.prctureBoxBtn setTitle:@"相册" forState:UIControlStateNormal];
    [self.prctureBoxBtn setTintColor:[UIColor colorWithDisplayP3Red:0.00 green:0.47 blue:0.80 alpha:1.00]];
    self.prctureBoxBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.prctureBoxBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
    [self.prctureBoxBtn addTarget:self action:@selector(callPhotoBox) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:self.prctureBoxBtn];
    //横屏
//    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
//        
//        self.cancelButton.center = CGPointMake(kScreenW - (self.view.center.x - kScreenH * scanRatio * 0.5) * 0.5, self.view.center.y);
//    
//    //竖屏
//    }else{
//        self.cancelButton.frame = CGRectMake((CGRectGetWidth(self.maskView.frame) - cancel_width) / 2, CGRectGetHeight(self.maskView.frame) - cancel_height - 64, cancel_width, cancel_height);
//        
//    }
}

/**
 *  扫描初始化
 */
- (void)capture{
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    self.device = device;
    
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    if (input == nil) {
        NSLog(@"没有权限");
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到系统设置打开相机权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
        return;
    }
    
    [self.session addInput:input];
    [self.session addOutput:output];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:self.previewLayer];
    
    //设置扫描支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = self.metadataObjectTypes;
    
    //开始捕获
    [self.session startRunning];
}

- (void)qrCodeScanResult:(QRCodeResult)result {
    if (result) {
        self.scanCodeResult = result;
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        
        [self.maskView removeAnimation];
        [self.session stopRunning];
        
        //扫描结果
        [self scanResult:metadataObject.stringValue];
        
    }
}

#pragma mark -扫描结果处理

- (void)scanResult:(NSString *)result {
    
    //使用的block传递扫描结果
    if (self.scanCodeResult) {
        self.scanCodeResult(self, result);
    }
}

#pragma mark - 取消事件
/**
 * 手电筒开关
 */
- (void)torchAction:(UIButton *)button {
    button.selected = !button.selected;
    
    if (self.device.isTorchAvailable) {
        [self.device lockForConfiguration:nil];
        if (button.selected) {
            self.device.torchMode = AVCaptureTorchModeOn;
            [self.torchBtn setImage:[UIImage imageNamed:@"drak_icon"] forState:0];
        } else {
            self.device.torchMode = AVCaptureTorchModeOff;
            [self.torchBtn setImage:[UIImage imageNamed:@"light_icon"] forState:0];
        }
        [self.device unlockForConfiguration];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"手电筒不可用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

// call photo
- (void)callPhotoBox {
    NSLog(@"callPhotoBox");
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    //2.创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    //选中之后大图编辑模式
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}
//相册获取的照片进行处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 1.取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    //转成Data格式
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    //2.从选中的图片中读取二维码数据
    //2.1创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    // 2.2利用探测器探测数据
    NSArray *feature = [detector featuresInImage:ciImage];
    
    // 2.3取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        [self scanResult:result.messageString];
    }
    if (feature.count == 0) {
        [self scanResult:@"没有扫描到有效二维码"];
    }
}
/**
 * 取消事件
 */
- (void)cancelAction{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 横竖屏适配

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    self.maskView.frame = CGRectMake(0, 0, size.width, size.height);
    self.previewLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [self.maskView resetFrame];
    
    //横屏
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
 
      self.cancelButton.frame = CGRectMake((CGRectGetWidth(self.maskView.frame) - CGRectGetWidth(self.cancelButton.frame)) / 2, CGRectGetHeight(self.maskView.frame) - CGRectGetHeight(self.cancelButton.frame) - 30, CGRectGetWidth(self.cancelButton.frame), CGRectGetHeight(self.cancelButton.frame));
    
    //竖屏
    }else{
        self.cancelButton.center = CGPointMake(kScreenH - (self.view.center.y - kScreenW * scanRatio * 0.5) * 0.5, self.view.center.x);
    }
}

@end
