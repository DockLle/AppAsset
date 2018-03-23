//
//  VedioToolBoxVC.m
//  AppAsset
//
//  Created by Wp on 2018/3/23.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "VedioToolBoxVC.h"
@import VideoToolbox;

@interface VedioToolBoxVC ()

@end

@implementation VedioToolBoxVC

//- (void)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    VTCompressionSessionRef *session;
    int32_t width = 320;
    int32_t height = 640;
    
//    VTCompressionSessionCreate(kCFAllocatorDefault, width, height, kCMVideoCodecType_H264, <#CFDictionaryRef  _Nullable encoderSpecification#>, <#CFDictionaryRef  _Nullable sourceImageBufferAttributes#>, <#CFAllocatorRef  _Nullable compressedDataAllocator#>, <#VTCompressionOutputCallback  _Nullable outputCallback#>, <#void * _Nullable outputCallbackRefCon#>, <#VTCompressionSessionRef  _Nullable * _Nonnull compressionSessionOut#>)
    
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
