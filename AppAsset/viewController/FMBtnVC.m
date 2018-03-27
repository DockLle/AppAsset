//
//  FMBtnVC.m
//  AppAsset
//
//  Created by Wp on 2018/3/26.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "FMBtnVC.h"
#import "FMButton.h"

@interface FMBtnVC ()

@end

@implementation FMBtnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    FMButton *btn = [[FMButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 80)];
//    [btn setIsTrailingImage:YES];
    [btn setText:@"流水落花春去也，天上人间"];
    [btn setFont:20];
    btn.contentAligment = FMContentAligmentRight;
    [btn setImage:[UIImage imageNamed:@"sound"]];
    btn.textColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(noSmo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)noSmo:(FMButton *)btn
{
    NSLog(@"我的爱也曾经深深温暖你的心灵");
    
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
