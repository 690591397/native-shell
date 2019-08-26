/********* qrcodeanalysis.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <Cordova/CDVViewController.h>
#import "BWQRScanViewController.h"

@interface qrcodeanalysis : CDVPlugin {
  // Member variables go here.
    NSString* _eventsCallbackId;
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
@end

@implementation qrcodeanalysis

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)scan:(CDVInvokedUrlCommand*)command
{
    _eventsCallbackId = command.callbackId;
    
    BWQRScanViewController *qrScanVC = [[BWQRScanViewController alloc] init];
    qrScanVC.navTitle = @"发票查询";
    qrScanVC.descString = @"注：请扫描发票上的二维码";
    [qrScanVC qrCodeScanResult:^(BWQRScanViewController *controller, NSString *result) {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        
        CDVPluginResult* backString = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        [self.commandDelegate sendPluginResult:backString callbackId:_eventsCallbackId];
    }];
    [self.viewController presentViewController:qrScanVC animated:YES completion:nil];
}

@end
