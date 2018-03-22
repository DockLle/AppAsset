//
//  BrushBoardVC.m
//  AppAssert
//
//  Created by 方益民 on 2018/3/20.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "BrushBoardVC.h"
#import "YMBrushBoard.h"

@interface BrushBoardVC ()

@end

@implementation BrushBoardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YMBrushBoard *board = [[YMBrushBoard alloc] initWithFrame:self.view.frame];
    [self.view addSubview:board];
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
