//
//  WKCFansyCameraRecordEncoder.h
//  WKCFansyCameraDemo
//
//  Created by 魏昆超 on 2019/2/20.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
/**
 写入并编码视频的类
 */
@interface WKCFansyCameraRecordEncoder : NSObject

@property (nonatomic, readonly) NSString *path;
@property (nonatomic, strong) AVAssetWriter *writer;//媒体写入对象

/**
 *  WKCFansyCameraRecordEncoder遍历构造器的
 *
 *  @param path 媒体存发路径
 *  @param cy   视频分辨率的高
 *  @param cx   视频分辨率的宽
 *  @param ch   音频通道
 *  @param rate 音频的采样比率
 *
 *  @return WKCFansyCameraRecordEncoder的实体
 */
+ (WKCFansyCameraRecordEncoder *)encoderForPath:(NSString*)path
                                         Height:(NSInteger)cy
                                          width:(NSInteger)cx
                                       channels:(int)ch
                                        samples:(Float64)rate;

/**
 *  初始化方法
 *
 *  @param path 媒体存发路径
 *  @param cy   视频分辨率的高
 *  @param cx   视频分辨率的宽
 *  @param ch   音频通道
 *  @param rate 音频的采样率
 *
 *  @return WCLRecordEncoder的实体
 */
- (instancetype)initPath:(NSString*)path
                  Height:(NSInteger)cy
                   width:(NSInteger)cx
                channels:(int)ch
                 samples:(Float64)rate;

/**
 *  完成视频录制时调用
 *
 *  @param handler 完成的回掉block
 */
- (void)finishWithCompletionHandler:(void (^)(void))handler;

/**
 *  通过这个方法写入数据
 *
 *  @param sampleBuffer 写入的数据
 *  @param isRecord      是否写入的是视频
 *
 *  @return 写入是否成功
 */
- (BOOL)encodeFrame:(CMSampleBufferRef)sampleBuffer
        pixelBuffer:(CVPixelBufferRef)buffer
           isRecord:(BOOL)isRecord;

- (void)initAudioInputChannels:(int)ch
                       samples:(Float64)rate;

@end

