//
//  AudioPlayer.h
//  AppAsset
//
//  Created by Wp on 2018/3/28.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AudioPlayer : NSObject

@property (nonatomic) BOOL isPlaying;

@property (nonatomic,unsafe_unretained) NSTimeInterval duration;

@property (nonatomic,unsafe_unretained) NSTimeInterval currentTime;

- (instancetype)initWithFilePath:(NSString *)path;
- (void)startWork;
- (void)play;
- (void)pause;
- (void)stop;


@end

