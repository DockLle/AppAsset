//
//  AudioToolBoxVC.m
//  AppAsset
//
//  Created by Wp on 2018/3/28.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "AudioToolBoxVC.h"
#import "AudioPlayer.h"
#import "HJBufferSlider.h"
@interface AudioToolBoxVC ()

@property (nonatomic,strong) AudioPlayer *player;
@property (nonatomic,strong) HJBufferSlider *slider;

@property (nonatomic,strong) UILabel *currentTimeLab;
@property (nonatomic,strong) UILabel *totalTimeLab;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation AudioToolBoxVC

- (void)dealloc
{
    DLog(@"释放");
}

- (IBAction)playAudio:(UIButton *)sender {
    
    if (self.player.isPlaying) {
        [self.player pause];
    }
    else
    {
        [self.player play];
    }
    
    
}

- (IBAction)startW:(UIButton *)sender {
    [self startProgress];
}


- (void)startProgress
{
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(abProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)abProgress
{
    self.slider.progressValue = self.player.currentTime;
    self.currentTimeLab.text = [self convertToStringFromTime:self.player.currentTime];
}


#pragma mark - getter

- (AudioPlayer *)player
{
    if (!_player) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Let Her Go" ofType:@"mp3"];
        _player = [[AudioPlayer alloc] initWithFilePath:path];
    }
    return _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.player startWork];
    
    [self setupUI];
    [self startProgress];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    
    [self.player stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    self.currentTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREEN_H - 100, 40, 50)];
    _currentTimeLab.text = @"00:00";
    _currentTimeLab.font = [UIFont systemFontOfSize:12];
    _currentTimeLab.textAlignment = NSTextAlignmentCenter;
    _currentTimeLab.textColor = [UIColor grayColor];
    [self.view addSubview:_currentTimeLab];
    
    self.slider = [[HJBufferSlider alloc] initWithFrame:CGRectMake(50, SCREEN_H - 100, SCREEN_W - 100, 50)];
    _slider.maximumValue = self.player.duration;
    _slider.minimumValue = 0;
    _slider.progressTrackColor = [UIColor yellowColor];
    
    [self.view addSubview:_slider];
    
    self.totalTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_slider.frame), SCREEN_H - 100, 40, 50)];
    _totalTimeLab.text = [self convertToStringFromTime:self.player.duration];
    _totalTimeLab.font = [UIFont systemFontOfSize:12];
    _totalTimeLab.textAlignment = NSTextAlignmentCenter;
    _totalTimeLab.textColor = [UIColor grayColor];
    [self.view addSubview:_totalTimeLab];
    
}


- (NSString *)convertToStringFromTime:(NSTimeInterval)timeInterval
{
    NSInteger m = timeInterval / 60;
    NSString *mS;
    if (m < 10) {
        mS = [NSString stringWithFormat:@"0%zi",m];
    }
    else
    {
        mS = [NSString stringWithFormat:@"%zi",m];
    }
    
    double mod = fmod(timeInterval, 60);
    double integer = 0;
    modf(mod, &integer);
    
    NSInteger second = integer;
    
    NSString *sS;
    if (second < 10) {
        sS = [NSString stringWithFormat:@"0%zi",second];
    }
    else
    {
        sS = [NSString stringWithFormat:@"%zi",second];
    }
    
    return [NSString stringWithFormat:@"%@:%zi",mS,sS];
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
