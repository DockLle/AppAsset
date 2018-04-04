//
//  AudioPlayer.m
//  AppAsset
//
//  Created by Wp on 2018/3/28.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "AudioPlayer.h"

#import <AudioToolbox/AudioToolbox.h>

#define kNumberOfBuffers 3              //AudioQueueBuffer数量，一般指明为3
#define kAQBufSize 128 * 1024           //每个AudioQueueBuffer的大小
#define kAudioFileBufferSize 2048       //文件读取数据的缓冲区大小
#define kMaxPacketDesc 512              //最大的AudioStreamPacketDescription个数

@interface AudioPlayer()
{
    AudioFileStreamID _fileStreamID;
    AudioStreamBasicDescription _baseDescription;
    UInt32 _bitRate;
    
    AudioQueueRef _queue;
    AudioQueueBufferRef _bufferArr[kNumberOfBuffers];
    
    UInt32 _currentBufferFilledDataSize;//当前buffer已填充数据的大小
    UInt32 _currentBufferFilledPacketCount;//当前buffer已填充帧数
    
    
    BOOL isUsing[kNumberOfBuffers];
    
    AudioStreamPacketDescription _packetDescription[kMaxPacketDesc];
    
}
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSFileHandle *fileHandle;
@property (nonatomic,strong) NSLock *audioLock;


@property (nonatomic,unsafe_unretained) SInt64 dataOffset;//音频数据在文件中的偏移量

@property (nonatomic,unsafe_unretained) NSUInteger currentBufferIndex;


@end

@implementation AudioPlayer

- (instancetype)initWithFilePath:(NSString *)path
{
    self = [super init];
    if (self) {
//        self.url = url;
        self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
        self.audioLock = [[NSLock alloc] init];
    }
    return self;
}


- (void)startWork
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (_fileStreamID == NULL) {
            //        1. inClientData：用户指定的数据，用于传递给回调函数，这里我们指定self
            //        2. inPropertyListenerProc：当解析到一个音频信息时，将回调该方法
            //        3. inPacketsProc：当解析到一个音频帧时，将回调该方法
            //        4. inFileTypeHint：指明音频数据的格式，如果你不知道音频数据的格式，可以传0
            //        5. outAudioFileStream：AudioFileStreamID实例，需保存供后续使用
            AudioFileStreamOpen((__bridge void *)self, inPropertyListenerProc, inPacketsProc, 0, &_fileStreamID);
        }
        
        NSData *audioData;
        do {
            audioData = [self.fileHandle readDataOfLength:kAudioFileBufferSize];
            
            //        1. inAudioFileStream：AudioFileStreamID实例，由AudioFileStreamOpen打开
            //        2. inDataByteSize：此次解析的数据字节大小
            //        3. inData：此次解析的数据大小
            //        4. inFlags：本次解析与上一次解析是否是连续的，是的传0，不是传kAudioFileStreamParseFlag_Discontinuity。
            
            AudioFileStreamParseBytes(_fileStreamID, (UInt32)[audioData length], [audioData bytes], 0);
            
            
        } while (audioData.length == kAudioFileBufferSize);
        
        [self.fileHandle closeFile];
    });
    
}

- (void)play
{
    if (_queue && self.isPlaying == NO) {
        AudioQueueStart(_queue, NULL);
        self.isPlaying = YES;
    }
}

- (void)pause
{
    if (_queue && self.isPlaying) {
        AudioQueuePause(_queue);
        self.isPlaying = NO;
    }
}

- (void)stop
{
    if (_queue && self.isPlaying) {
        AudioQueueStop(_queue, true);
        self.isPlaying = NO;
    }
    
//    AudioQueueReset(_queue);
    
}

- (BOOL)createQueue
{
    OSStatus status = AudioQueueNewOutput(&_baseDescription, audioQueueOutputCallback, (__bridge void *)self, NULL, NULL, 0, &_queue);
    if (status == noErr) {
        for (int i = 0; i < kNumberOfBuffers; i ++) {
            AudioQueueAllocateBuffer(_queue, kAQBufSize, &_bufferArr[i]);
        }
        return YES;
    }
    
    return NO;
}

#pragma mark - 数据解析回调

//当一个缓冲区结束后
void audioQueueOutputCallback(
                                 void * __nullable       inUserData,
                                 AudioQueueRef           inAQ,
                                 AudioQueueBufferRef     inBuffer)
{
    NSLog(@"用一个人");
    AudioPlayer *audioPlayer = (__bridge AudioPlayer *)inUserData;
    for (int i = 0; i < kNumberOfBuffers; i ++) {
        if (inBuffer == audioPlayer->_bufferArr[i]) {
            [audioPlayer.audioLock lock];
            audioPlayer->isUsing[i] = NO;
            [audioPlayer.audioLock unlock];
        }
    }
}

void audioQueueIsRuning(
                                       void * __nullable       inUserData,
                                       AudioQueueRef           inAQ,
                                       AudioQueuePropertyID    inID)
{
    AudioPlayer *audioPlayer = (__bridge AudioPlayer *)inUserData;
    NSLog(@"光伏你能");
    UInt32 isRuning;
    UInt32 ioDataSize = sizeof(isRuning);
    OSStatus status = AudioQueueGetProperty(inAQ, inID, &isRuning, &ioDataSize);
    
    if (status == noErr) {
        NSLog(@"破剑式==%u",isRuning);
        if (isRuning == 0) {
            AudioQueueReset(inAQ);
            
            for (int i = 0; i < kNumberOfBuffers; i ++) {
                AudioQueueFreeBuffer(inAQ, audioPlayer->_bufferArr[i]);
            }
            
            AudioQueueDispose(inAQ, true);
            
            AudioFileStreamClose(audioPlayer->_fileStreamID);
        }
    }
}

void inPropertyListenerProc(void *inClientData,
                            AudioFileStreamID inAudioFileStream,
                            AudioFileStreamPropertyID inPropertyID,
                            AudioFileStreamPropertyFlags *ioFlags)
{
    AudioPlayer *audioPlayer = (__bridge AudioPlayer *)inClientData;
    switch (inPropertyID) {
        
        case kAudioFileStreamProperty_BitRate://该属性可获取到音频的比特率，可用于计算音频时长
        {
            NSLog(@"BitRate");
            UInt32 bitRate;
            UInt32 propertyDataSize = sizeof(bitRate);
            
            AudioFileStreamGetProperty(inAudioFileStream, inPropertyID, &propertyDataSize, &bitRate);
            
            if (bitRate != 0) audioPlayer -> _bitRate = bitRate;
        }
            break;
        case kAudioFileStreamProperty_AudioDataByteCount://该属性可获取到音频数据的长度，可用于计算音频时长，计算公式为：时长 = (音频数据字节大小 * 8) / 比特率
        {
            NSLog(@"AudioDataByteCount");
            
            UInt64 dataByteCount;
            UInt32 propertyDataSize = sizeof(dataByteCount);
            
            AudioFileStreamGetProperty(inAudioFileStream, inPropertyID, &propertyDataSize, &dataByteCount);
            
            if (audioPlayer -> _bitRate != 0) {
                audioPlayer.duration = (dataByteCount * 8.0) / audioPlayer -> _bitRate;
            }
            
        }
            break;
        case kAudioFileStreamProperty_AudioDataPacketCount://该属性指明了音频文件中共有多少帧
        {
            NSLog(@"AudioDataPacketCount");
            UInt64 dataPacketCount;
            UInt32 propertyDataSize = sizeof(dataPacketCount);
            
            AudioFileStreamGetProperty(inAudioFileStream, inPropertyID, &propertyDataSize, &dataPacketCount);
            
            NSLog(@"packet 数量 == %zi",dataPacketCount);
        }
            break;
        case kAudioFileStreamProperty_FileFormat://该属性指明了音频数据的编码格式，如MPEG等
        {
            NSLog(@"FileFormat");
            UInt32 fileFormat, propertyDataSize = sizeof(fileFormat);
            AudioFileStreamGetProperty(inAudioFileStream, inPropertyID, &propertyDataSize, &fileFormat);
        }
            break;
        case kAudioFileStreamProperty_DataFormat://该属性指明了音频数据的格式信息，返回的数据是一个AudioStreamBasicDescription结构。需保存用于AudioQueue的使用
        {
            NSLog(@"dateFormat");
            
            UInt32 propertyDataSize = sizeof(audioPlayer -> _baseDescription);
            AudioFileStreamGetProperty(inAudioFileStream, inPropertyID, &propertyDataSize, &audioPlayer->_baseDescription);
            
        }
            break;
        case kAudioFileStreamProperty_DataOffset://该属性指明了音频数据在整个音频文件中的偏移量：音频文件总大小 = 偏移量 + 音频数据字节大小
        {
            NSLog(@"DataOffset");
            SInt64 dataOffset;
            UInt32 propertyDataSize = sizeof(dataOffset);
            
            AudioFileStreamGetProperty(inAudioFileStream, inPropertyID, &propertyDataSize, &dataOffset);
            audioPlayer.dataOffset = dataOffset;
            NSLog(@"音频数据在文件中偏移量==%zi",dataOffset);
            
            
        }
            break;
        case kAudioFileStreamProperty_ReadyToProducePackets://该属性告诉我们，已经解析到完整的音频帧数据，准备产生音频帧，之后会调用到另外一个回调函数，我们在这里创建音频队列AudioQueue，如果音频数据中有Magic Cookie Data，则先调用AudioFileStreamGetPropertyInfo，获取该数据是否可写，如果可写再取出该属性值，并写入到AudioQueue。之后便是音频数据帧的解析
        {
            NSLog(@"ReadyToProducePackets");
            
            UInt32 packetCount;
            UInt32 propertyDataSize = sizeof(packetCount);
            
            AudioFileStreamGetProperty(inAudioFileStream, inPropertyID, &propertyDataSize, &packetCount);
            
            NSLog(@"packet 数量 == %u",packetCount);
            
            if (![audioPlayer createQueue]) {
                return;
            }
            
            UInt32 cookieSize;
            Boolean writable;
            AudioFileStreamGetPropertyInfo(inAudioFileStream, kAudioFileStreamProperty_MagicCookieData, &cookieSize, &writable);
            
            void * cookieData = calloc(1, cookieSize);
            AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_MagicCookieData, &cookieSize, cookieData);
            
            AudioQueueSetProperty(audioPlayer -> _queue, kAudioQueueProperty_MagicCookie, cookieData, cookieSize);
            
            AudioQueueAddPropertyListener(audioPlayer -> _queue, kAudioQueueProperty_IsRunning, audioQueueIsRuning, inClientData);
            
            
        }
            break;
            
        default:
            break;
    }
    
}

void inPacketsProc(void * inClientData,
                   UInt32 inNumberBytes,
                   UInt32 inNumberPackets,
                   const void * inInputData,
                   AudioStreamPacketDescription *inPacketDescriptions)
{
//    NSLog(@"田中角荣");
//
    AudioPlayer *audioPlayer = (__bridge AudioPlayer *)inClientData;
    
    for (int i = 0; i < inNumberPackets; i ++) {
        SInt64 mStartOffset = inPacketDescriptions[i].mStartOffset;
        UInt32 mDataByteSize = inPacketDescriptions[i].mDataByteSize;
        
        if (mDataByteSize > kAQBufSize - audioPlayer -> _currentBufferFilledDataSize) {
            //如果此帧数据大小大于当前buffer剩余空间，将当前buffer送入queue，将此帧开始放入下一个buffer
            
            OSStatus status = AudioQueueEnqueueBuffer(audioPlayer -> _queue, audioPlayer -> _bufferArr[audioPlayer.currentBufferIndex], audioPlayer->_currentBufferFilledPacketCount, audioPlayer->_packetDescription);
            
            audioPlayer.currentBufferIndex = (++ audioPlayer.currentBufferIndex) % kNumberOfBuffers;
            audioPlayer->_currentBufferFilledPacketCount = 0;
            audioPlayer->_currentBufferFilledDataSize = 0;
            
            
            if (!audioPlayer.isPlaying) {
                
                OSStatus status = AudioQueueStart(audioPlayer -> _queue, NULL);
                
                audioPlayer.isPlaying = YES;
            }
            
            
//            NSLog(@"道可道，非恒道==%@",[NSThread currentThread]);
            while (audioPlayer->isUsing[audioPlayer->_currentBufferIndex]);
//            while (1) ;
            
//            dispatch_semaphore_wait(audioPlayer.st, DISPATCH_TIME_FOREVER);
            
        }
        
        AudioQueueBufferRef currentBuffer = audioPlayer -> _bufferArr[audioPlayer.currentBufferIndex];
        
        audioPlayer->isUsing[audioPlayer->_currentBufferIndex] = YES;
        
        currentBuffer -> mAudioDataByteSize = audioPlayer->_currentBufferFilledDataSize + mDataByteSize;
        memcpy(currentBuffer->mAudioData + audioPlayer->_currentBufferFilledDataSize, inInputData + mStartOffset, mDataByteSize);
        
        audioPlayer->_packetDescription[audioPlayer->_currentBufferFilledPacketCount] = inPacketDescriptions[i];
        audioPlayer->_packetDescription[audioPlayer->_currentBufferFilledPacketCount].mStartOffset = audioPlayer->_currentBufferFilledDataSize;
        audioPlayer->_currentBufferFilledDataSize += mDataByteSize;
        audioPlayer->_currentBufferFilledPacketCount += 1;
    }
    
}

- (NSTimeInterval)currentTime
{
    AudioTimeStamp outTimeStamp;
    Boolean discontinuity;
    
    OSStatus status = AudioQueueGetCurrentTime(_queue, NULL, &outTimeStamp, &discontinuity);
    
    if (status != noErr) {
        NSLog(@"获取进度发生错误");
    }
    
    return outTimeStamp.mSampleTime / _baseDescription.mSampleRate;
}

@end
