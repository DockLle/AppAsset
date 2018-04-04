//
//  CornerVC.m
//  AppAssert
//
//  Created by 方益民 on 2018/3/22.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "CornerVC.h"
#import "UIImageView+CornerRadius.h"

@interface CornerVC ()
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@end

@implementation CornerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.image1 zy_cornerRadiusRoundingRect];
//    [self.image1 setImage:[UIImage imageNamed:@"dog"]];
    
    [self.image2 zy_cornerRadiusAdvance:0.f rectCornerType:UIRectCornerTopLeft | UIRectCornerBottomRight];
    [self.image2 zy_attachBorderWidth:5.f color:[UIColor blackColor]];
    [self.image2 setImage:[UIImage imageNamed:@"dog"]];
    
//    [self.image3 zy_cornerRadiusAdvance:40.f rectCornerType:UIRectCornerTopLeft | UIRectCornerTopRight];
//    [self.image3 setImage:[UIImage imageNamed:@"dog"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
