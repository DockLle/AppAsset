//
//  BackgroundAudioVC.m
//  AppAssert
//
//  Created by 方益民 on 2018/3/20.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "BackgroundAudioVC.h"

@import AVFoundation;
@import MediaPlayer;
@interface BackgroundAudioVC ()

@property (nonatomic,strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn;

@end

@implementation BackgroundAudioVC

- (IBAction)playAudio:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        if ([self.player play]) {
            NSLog(@"播放中");
        }
    }
    else
    {
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [self.player pause];
    }
}


-(void)listeningRemoteControl:(NSNotification *)sender
{
    NSDictionary *dict=sender.userInfo;
    NSInteger order=[[dict objectForKey:@"order"] integerValue];
    switch (order) {
            //暂停
        case UIEventSubtypeRemoteControlPause:
        {
            [self setNowPlayingInfo];
            [self __pause];
            
            break;
        }
            //播放
        case UIEventSubtypeRemoteControlPlay:
        {
            [self setNowPlayingInfo];
            [self __play];
            break;
        }
            //暂停播放切换
        case UIEventSubtypeRemoteControlTogglePlayPause:
        {
            [self setNowPlayingInfo];
            
            NSLog(@"6666的");
            
            break;
        }
            //下一首
        case UIEventSubtypeRemoteControlNextTrack:
        {
            //            [self next];
            break;
        }
            //上一首
        case UIEventSubtypeRemoteControlPreviousTrack:
        {
            //            [self previous];
            break;
        }
        default:
            break;
    }
}

-(void)setNowPlayingInfo
{
    NSMutableDictionary *songDict=[NSMutableDictionary dictionary];
    //歌名
    [songDict setObject:@"再见" forKey:MPMediaItemPropertyTitle];
    //歌手名
    [songDict setObject:@"方一鸣" forKey:MPMediaItemPropertyArtist];
    //歌曲的总时间
    [songDict setObject:[NSNumber numberWithDouble:self.player.duration] forKeyedSubscript:MPMediaItemPropertyPlaybackDuration];
    //设置歌曲图片
    //    MPMediaItemArtwork *imageItem=[[MPMediaItemArtwork alloc]initWithImage:_singerImageView.image];
    //    [songDict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    //设置控制中心歌曲信息
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
}

- (void)__play
{
    [self.player play];
    self.controlBtn.selected = YES;
    [self.controlBtn setTitle:@"暂停" forState:UIControlStateNormal];
}

- (void)__pause
{
    [self.player pause];
    self.controlBtn.selected = NO;
    [self.controlBtn setTitle:@"播放" forState:UIControlStateNormal];
}

#pragma mark - getter

- (AVAudioPlayer *)player
{
    if (!_player) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"popo" ofType:@"mp3"];
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        //    [player prepareToPlay];
        [_player setVolume:1];
        _player.numberOfLoops = -1;
    }
    return _player;
}

#pragma mark - vc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:self.gTitle];
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self setNowPlayingInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listeningRemoteControl:) name:@"kAppDidReceiveRemoteControlNotification" object:nil];
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
