//
//  CommonTool.h
//  AppAssert
//
//  Created by 方益民 on 2018/3/19.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface CommonTool : NSObject

+ (CommonTool *)shareTool;

- (UIViewController *)getCurrentVC;

@end
