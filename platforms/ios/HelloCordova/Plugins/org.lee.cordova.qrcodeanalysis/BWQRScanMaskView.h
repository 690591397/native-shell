
#import <UIKit/UIKit.h>

#define scanRatio 0.68
#define kScreenWR ([UIScreen mainScreen].bounds.size.width + 0.0)/375
#define kScreenHR ([UIScreen mainScreen].bounds.size.height + 0.0)/667
#define kScreenW ([UIScreen mainScreen].bounds.size.width + 0.0)
#define kScreenH ([UIScreen mainScreen].bounds.size.height + 0.0)

@interface BWQRScanMaskView : UIView

@property (copy, nonatomic) NSString *descString; //提示文字

#pragma mark - public method

/**
 重设UI的frame
 */
- (void)resetFrame;


/**
 开始动画
 */
- (void)startAnimation;

/**
 移除动画
 */
- (void)removeAnimation;

@end
