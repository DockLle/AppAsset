//
//  BallViewController.m
//  AppAssert
//
//  Created by 方益民 on 2018/3/19.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "BallViewController.h"
@import CoreMotion;

static double timeInterval = 1 / 60.0;

@interface BallViewController ()

@property (nonatomic,strong) CMMotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UIImageView *ball;

@end

@implementation BallViewController

- (void)updateLocation
{
    
}

#pragma mark - getter

- (CMMotionManager *)motionManager
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = timeInterval;
    }
    return _motionManager;
}

#pragma mark - vc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:self.gtitle];
    
    
    // gt^2
    
    if ([self.motionManager isDeviceMotionAvailable]) {
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
//            NSLog(@"==%f",motion.gravity.y);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CGPoint rect = self.ball.center;
                rect.y += ( -motion.gravity.y * pow(timeInterval, 2) * 50000);
                rect.x += ( motion.gravity.x * pow(timeInterval, 2) * 50000);
                self.ball.center = rect;
            });
            
        }];
    }
    
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
