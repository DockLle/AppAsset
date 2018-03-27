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

@property (nonatomic,strong) AVURLAsset *asset;
@property (nonatomic,strong) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn;

@end

@implementation BackgroundAudioVC

- (IBAction)playAudio:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        NSLog(@"播放中");
        [self.player play];
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
    NSMutableDictionary *dic = [self MusicInfoArray];
    NSMutableDictionary *songDict=[NSMutableDictionary dictionary];
    //歌名
    [songDict setObject:@"Let Her Go" forKey:MPMediaItemPropertyTitle];
    //歌手名
    [songDict setObject:dic[@"artist"] forKey:MPMediaItemPropertyArtist];
    //歌曲的总时间
    [songDict setObject:[NSNumber numberWithDouble:self.asset.duration.value / self.asset.duration.timescale] forKeyedSubscript:MPMediaItemPropertyPlaybackDuration];
    //设置歌曲图片
    MPMediaItemArtwork *imageItem=[[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:@"dog"]];
    [songDict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    //设置控制中心歌曲信息
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
}

- (NSMutableDictionary *)MusicInfoArray
{
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
    for (NSString *format in [self.asset availableMetadataFormats]) {
        
//        [infoDict setObject:MusicName forKey:@"MusicName"];
        NSLog(@"format type = %@",format);
        for (AVMetadataItem *metadataItem in [self.asset metadataForFormat:format]) {
            NSLog(@"commonKey = %@",metadataItem.commonKey);
            
            if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                NSString *mime = [(NSDictionary *)metadataItem.value objectForKey:@"MIME"];
                NSLog(@"mime: %@",mime);
                
                [infoDict setObject:mime forKey:@"artwork"];
            }
            else if([metadataItem.commonKey isEqualToString:@"title"])
            {
                NSString *title = (NSString *)metadataItem.value;
                NSLog(@"title: %@",title);
                
                [infoDict setObject:title forKey:@"title"];
            }
            else if([metadataItem.commonKey isEqualToString:@"artist"])
            {
                NSString *artist = (NSString *)metadataItem.value;
                NSLog(@"artist: %@",artist);
                
                [infoDict setObject:artist forKey:@"artist"];
            }
            else if([metadataItem.commonKey isEqualToString:@"albumName"])
            {
                NSString *albumName = (NSString *)metadataItem.value;
                NSLog(@"albumName: %@",albumName);
                
                [infoDict setObject:albumName forKey:@"albumName"];
            }
        }
        
    }
    
    return infoDict;
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

- (AVURLAsset *)asset
{
    if (!_asset) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Let Her Go" ofType:@"mp3"];
        _asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
        
    }
    return _asset;
}

- (AVPlayer *)player
{
    if (!_player) {
        
        _player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem playerItemWithAsset:self.asset]];
        _player.volume = 1.0;
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
