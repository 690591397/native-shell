
#import <UIKit/UIKit.h>

@class BWQRScanViewController;
typedef void(^QRCodeResult)(BWQRScanViewController *controller, NSString *result);

@interface BWQRScanViewController : UIViewController

@property (copy, nonatomic) NSString *navTitle; //扫码控制器title
@property (copy, nonatomic) NSString *descString; //辅助说明文字

/** 扫描结果 */
- (void)qrCodeScanResult:(QRCodeResult)result;

@end
