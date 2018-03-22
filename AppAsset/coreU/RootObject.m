//
//  RootObject.m
//  AppAssert
//
//  Created by 方益民 on 2018/3/19.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "RootObject.h"
#import "CommonTool.h"
#import "ContactsController.h"

@import StoreKit;
@import LocalAuthentication;
@import CallKit;

static RootObject *defaultObject;

@interface RootObject()<SKStoreProductViewControllerDelegate,CXProviderDelegate>

@property (nonatomic,strong) CXProvider *provider NS_AVAILABLE_IOS(10.0);

@end

@implementation RootObject

+ (RootObject *)shareRootObject
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!defaultObject) {
            defaultObject = [[RootObject alloc] init];
        }
    });
    return defaultObject;
}


#pragma mark - abount Store

- (void)ShowStoreView
{
    SKStoreProductViewController *productView = [[SKStoreProductViewController alloc] init];
    productView.delegate = self;
    [productView loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@(1053012308)} completionBlock:^(BOOL result, NSError * _Nullable error) {
        if (result) {
            NSLog(@"加载完成");
        }
        else
        {
            if (error.code == SKErrorPaymentCancelled) {
                NSLog(@"用户取消了");
            }
        }
    }];
    
    [[[CommonTool shareTool] getCurrentVC] presentViewController:productView animated:YES completion:nil];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [[[CommonTool shareTool] getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}

- (void)showStoreEvaluation NS_AVAILABLE_IOS(10.3)
{
    [SKStoreReviewController requestReview];
}


#pragma mark - 本地权限验证

- (void)openLocalAuthentication
{
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"need U";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"你的小迷妹想让你开" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"你帮小迷妹开了");
            }
            else
            {
                if (error.code == LAErrorUserCancel) {
                    NSLog(@"你取消了，小迷妹不开森");
                }
            }
        }];
    }
}


#pragma mark - 调起系统通话界面

#ifdef __IPHONE_10_0
- (void)openSystemCallView NS_AVAILABLE_IOS(10.0)
{
    
    
    UIBackgroundTaskIdentifier btID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self receivedCallWithName:@"伍佰" andBTID:btID];
    });
    
}

- (void)receivedCallWithName:(NSString *)name andBTID:(UIBackgroundTaskIdentifier)btID NS_AVAILABLE_IOS(10.0)
{
    NSString *remoteNick = name;
    CXHandle *callHandle = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:remoteNick];
    
    CXCallUpdate *update = [[CXCallUpdate alloc] init];
    [update setRemoteHandle:callHandle];
    [update setHasVideo:NO];
    
    
    if (!remoteNick) {
        remoteNick = @"未知号码";
    }
    
    [update setLocalizedCallerName:remoteNick];
    
    NSUUID *uuid = [NSUUID UUID];
    
    [self.provider reportNewIncomingCallWithUUID:uuid update:update completion:^(NSError * _Nullable error) {
        [[UIApplication sharedApplication] endBackgroundTask:btID];
    }];
    
}

- (CXProvider *)provider
{
    if (!_provider) {
        CXProviderConfiguration *config = [[CXProviderConfiguration alloc] initWithLocalizedName:@"opop"];
        config.supportsVideo = NO;
        config.maximumCallsPerCallGroup = 1;
        config.supportedHandleTypes = [NSSet setWithObject:[NSNumber numberWithInt:CXHandleTypePhoneNumber]];
        
        _provider = [[CXProvider alloc] initWithConfiguration:config];
        [_provider setDelegate:self queue:nil];
    }
    
    return _provider;
}

- (void)providerDidReset:(CXProvider *)provider NS_AVAILABLE_IOS(10.0)
{
    NSLog(@"98977");
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action NS_AVAILABLE_IOS(10.0)
{
    NSLog(@"挂掉");
    [action fulfillWithDateEnded:[NSDate date]];
}

- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action NS_AVAILABLE_IOS(10.0)
{
    NSLog(@"接通");
}
#endif

#pragma mark - 画板

- (void)openBrushBoard
{
    UIViewController *vc = [[NSClassFromString(@"BrushBoardVC") alloc] init];
    [[[CommonTool shareTool] getCurrentVC] showViewController:vc sender:nil];
}


#pragma mark - 获取通讯录

- (void)openContacts
{
    ContactsController *vc = [[ContactsController alloc] init];
    [[[CommonTool shareTool] getCurrentVC] showViewController:vc sender:nil];
}
@end
