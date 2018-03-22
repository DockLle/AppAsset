//
//  CommonTool.m
//  AppAssert
//
//  Created by 方益民 on 2018/3/19.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "CommonTool.h"

static CommonTool *tool;
@implementation CommonTool

+ (CommonTool *)shareTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!tool) {
            tool = [[CommonTool alloc] init];
        }
    });
    return tool;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;

    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的

        rootVC = [rootVC presentedViewController];
    }

    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController

        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];

    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController

        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];

    } else {
        // 根视图为非导航类

        currentVC = rootVC;
    }

    return currentVC;
}

@end
