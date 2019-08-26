//
//  WKCFansyCameraView.h
//  BBC
//
//  Created by wkcloveYang on 2019/8/23.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class WKCFansyCameraView;

@protocol WKCFansyCameraViewDelegate <NSObject>

@optional
/**
  相机采集流
  @parma fansyCamera 当前对象
  @param sampleBuffer 流
 */
- (void)fansyCamera:(WKCFansyCameraView *)fansyCamera didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
  拍照回调
  @param fansyCamera 当前对象
  @param photo 照片
 */
- (void)fansyCamera:(WKCFansyCameraView *)fansyCamera didTakePhoto:(UIImage *)photo;

/**
  拍视频
  @param fansyCamera 当前对象
  @param videoPath 视频缓存地址
 */
- (void)fansyCamera:(WKCFansyCameraView *)fansyCamera didTakeVideo:(NSString *)videoPath;

@end

/**
 相机模式
 @enum WKCFansyCameraModeImage         拍照
 @enum WKCFansyCameraModeImageAndVideo 拍照和拍视频
 */
typedef NS_ENUM(NSInteger, WKCFansyCameraMode) {
    WKCFansyCameraModeImage         = 0,
    WKCFansyCameraModeImageAndVideo = 1
};

typedef void(^WKCFansyCameraBlock)(void);

// 1.初始化时会自动请求相机权限, 同意权限后自动开始捕捉画面
// 2.如果需要没开权限时做一些处理, 可以使用premissionDeniedHandle回调
// 3.Info.plist需要填入 Privacy - Camera Usage Description键
// 4.如果使用拍视频,还需 Privacy - Microphone Usage Description 键

@interface WKCFansyCameraView : UIView

/**
  代理
 */
@property (nonatomic, weak) id<WKCFansyCameraViewDelegate> delegate;

/**
  权限没开时回调
 */
@property (nonatomic, copy) WKCFansyCameraBlock premissionDeniedHandle;

/**
  闪光灯模式
 */
@property (nonatomic, assign, readonly) AVCaptureTorchMode flashMode;

/**
  摄像头位置
 */
@property (nonatomic, assign, readonly) AVCaptureDevicePosition position;

/**
  捕捉方向
 */
@property (nonatomic, assign) AVCaptureVideoOrientation captureOrientation;

/**
 是否捏合缩放,默认NO
 */
@property (nonatomic, assign) BOOL shouldScaleEnable;

/**
 是否点击为聚焦点, 默认YES
 */
@property (nonatomic, assign) BOOL shouldFocusEnable;

/**
 是否上下滑修改曝光值, 默认YES
 */
@property (nonatomic, assign) BOOL shouldExposureEnable;


/**
  聚焦点图片, 如果需要设置的赋值, 否则使用默认
 */
@property (nonatomic, strong) UIImage * focusImage;


/**
  初始化
  @param frame 坐标
  @param mode 相机模式
  @param position 摄像头方向
 */
- (instancetype)initWithFrame:(CGRect)frame
                   cameraMode:(WKCFansyCameraMode)mode
                     position:(AVCaptureDevicePosition)position;

/**
  开始捕捉
 */
- (void)startCapture;

/**
 停止捕捉
 */
- (void)stopCapture;

/**
 开始拍摄(WKCFansyCameraModeImageAndVideo模式有效)
 */
- (void)startRecord;

/**
 停止拍摄(WKCFansyCameraModeImageAndVideo模式有效)
 */
- (void)stopRecord;

/**
 点击拍照
 */
- (void)takePhoto;

/**
 转换摄像头
 */
- (void)switchCamera;

/**
 切换闪光灯
 */
- (void)switchFlash;

/**
  重置坐标
  重置时有动画, 并且有蒙层过度坐标转换
 */
- (void)resetCameraFrame:(CGRect)frame;


@end

