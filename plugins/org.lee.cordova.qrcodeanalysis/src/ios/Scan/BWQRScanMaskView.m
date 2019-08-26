
#import "BWQRScanMaskView.h"

@interface BWQRScanMaskView()

@property (nonatomic, strong) UIImageView *scanLineImg;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UIImageView *topLeftImg;
@property (nonatomic, strong) UIImageView *topRightImg;
@property (nonatomic, strong) UIImageView *bottomLeftImg;
@property (nonatomic, strong) UIImageView *bottomRightImg;

@property (nonatomic, strong) UIBezierPath *bezier;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

/** 第一次旋转 */
@property (nonatomic, assign) CGFloat isFirstTransition;
@property (nonatomic, assign) double pointY;

@end

@implementation BWQRScanMaskView

- (void)commonInit{
    _isFirstTransition = NO;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
//        [self addUI];
        [self addQRCodeLayer];
    }
    
    return self;
}

//创建二维码界面
- (void)addQRCodeLayer{
    _pointY = kScreenH/2 - kScreenWR*375/2 - 76;
    //顶部灰色透明背景条
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, _pointY)]; //(kScreenH-370*kScreenWR)/2-64
    topImageView.image = [UIImage imageNamed:@"translucentBar"];
//    topImageView.image = [UIImage imageNamed:@"translucentBar"];
    [self addSubview:topImageView];
    
    //扫描框 (kScreenH-370*kScreenWR)/2-64
    //扫码框是用image画的。 图片定位在哪儿就是哪儿
    UIImageView *scanFrameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _pointY, kScreenW, kScreenWR*375)];
    scanFrameImageView.image = [UIImage imageNamed:@"scanWindow"];
    [self addSubview:scanFrameImageView];
    
    //扫描线
    UIImageView *scanLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70*kScreenWR, 210*kScreenWR, 235*kScreenWR, 1)];
    scanLineImageView.image = [UIImage imageNamed:@"scanLine"];
    [self addSubview:scanLineImageView];
    self.scanLineImg = scanLineImageView;
    [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
    
    //底部部灰色背景条
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scanFrameImageView.frame), kScreenW, kScreenH)];
    bottomImageView.image = [UIImage imageNamed:@"translucentBar"];
    [self addSubview:bottomImageView];
//
    //提示框
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scanFrameImageView.frame) - 60, self.frame.size.width, 30*kScreenWR)];
    self.hintLabel.text = @"【将二维码放入框内，即可自动扫描】";
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.numberOfLines = 0;
    self.hintLabel.font = [UIFont systemFontOfSize:15];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.hintLabel];
    
    //说明文本
    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*kScreenWR, CGRectGetMaxY(scanFrameImageView.frame) - 20*kScreenWR, (self.frame.size.width -40)*kScreenWR, 140)];
    self.noteLabel.textColor = [UIColor whiteColor];
    self.noteLabel.numberOfLines = 0;
    [self addSubview:self.noteLabel];
}

/**
 *  添加UI
 */
- (void)addUI{
    //遮罩层
//    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
//    self.maskView.backgroundColor = [UIColor blueColor];
//    self.maskView.alpha = 0.7;
//    self.maskView.layer.mask = [self maskLayer];
//    [self addSubview:self.maskView];
    
    //提示框
//    self.hintLabel = [[UILabel alloc] init];
//    self.hintLabel.text = @"【将 二维码放入框内，即可自动扫描】";
//    self.hintLabel.textColor = [UIColor whiteColor];
//    self.hintLabel.numberOfLines = 0;
//    self.hintLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:self.hintLabel];
//
//    //边框
//    UIImage *topLeftImage = [UIImage imageNamed:@"ScanQR1"];
//    UIImage *topRightImage = [UIImage imageNamed:@"ScanQR2"];
//    UIImage *bottomLeftImage = [UIImage imageNamed:@"ScanQR3"];
//    UIImage *bottomRightImage = [UIImage imageNamed:@"ScanQR4"];
//
//    //左上
//    self.topLeftImg = [[UIImageView alloc] init];
//    self.topLeftImg.image = topLeftImage;
//    [self addSubview:self.topLeftImg];
//
//    //右上
//    self.topRightImg = [[UIImageView alloc] init];
//    self.topRightImg.image = topRightImage;
//    [self addSubview:self.topRightImg];
//
//    //左下
//    self.bottomLeftImg = [[UIImageView alloc] init];
//    self.bottomLeftImg.image = bottomLeftImage;
//    [self addSubview:self.bottomLeftImg];
//
//    //右下
//    self.bottomRightImg = [[UIImageView alloc] init];
//    self.bottomRightImg.image = bottomRightImage;
//    [self addSubview:self.bottomRightImg];
//
//    //扫描线
//    UIImage * scanLineImage = [UIImage imageNamed:@"scanLine"];
//    self.scanLineImg = [[UIImageView alloc] init];
//    self.scanLineImg.image = scanLineImage;
//    self.scanLineImg.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:self.scanLineImg];
//    [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
}

/**
 *  动画
 */
- (CABasicAnimation *)animation {
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = MAXFLOAT;
    
//    控制扫码的线
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, kScreenH/2 - kScreenWR*375/2 - 32 + 80)];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, _pointY + 80)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, _pointY + 300)];
    return animation;
}

/**
 *  遮罩层bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)maskPath{
    self.bezier = nil;
    self.bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenW, kScreenH)];
    
    
    return self.bezier;
}

/**
 *  遮罩层ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)maskLayer{
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = [self maskPath].CGPath;
    
    return self.shapeLayer;
}

#pragma mark - public method

/**
 *  重设UI的frame
 */
- (void)resetFrame{
    NSLog(@"reset");
}


/**
 开始动画
 */
- (void)startAnimation {
    [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
}

/**
 移除动画
 */
- (void)removeAnimation{
    [self.scanLineImg.layer removeAllAnimations];
}

#pragma mark setter
- (void)setDescString:(NSString *)descString {
    if (_descString != descString) {
        _descString = descString;
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 3;
        paraStyle.paragraphSpacing = 10;
        
        NSDictionary *dic = @{
                              NSFontAttributeName:[UIFont systemFontOfSize:14],
                              NSParagraphStyleAttributeName:paraStyle,
                              NSKernAttributeName:@0
                              };
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:descString attributes:dic];
        self.noteLabel.attributedText = attributeStr;
    }
}

@end
