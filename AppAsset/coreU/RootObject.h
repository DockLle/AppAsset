//
//  RootObject.h
//  AppAssert
//
//  Created by 方益民 on 2018/3/19.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootObject : NSObject

+ (RootObject *)shareRootObject;


/**
 在应用里展示App Store的内容
 */
- (void)ShowStoreView;


/**
 应用内评价星级
 */
- (void)showStoreEvaluation;


/**
 打开本地权限验证（touch ID, face ID）
 */
- (void)openLocalAuthentication;


/**
 调起系统通话界面
 */
- (void)openSystemCallView;


/**
 打开画板
 */
- (void)openBrushBoard;


/**
 打开通讯录
 */
- (void)openContacts;


/**
 应用内打开safari
 */
- (void)openSafari;
@end
