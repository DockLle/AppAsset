//
//  FMButton.h
//  AppAsset
//
//  Created by Wp on 2018/3/26.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FMContentAligment) {
    FMContentAligmentLeft = 0,
    FMContentAligmentCenter = 1,
    FMContentAligmentRight = 2
};

IB_DESIGNABLE
@interface FMButton : UIControl

@property (nonatomic,unsafe_unretained) IBInspectable BOOL isTrailingImage;//图片是否后置，默认前置
@property (nonatomic) IBInspectable NSInteger contentAligment;

@property (nonatomic,strong) IBInspectable UIImage *image;

@property (nonatomic,copy) IBInspectable NSString *text;

@property (nonatomic,unsafe_unretained) IBInspectable CGFloat font;

@property (nonatomic,strong) IBInspectable UIColor *textColor;

@end
