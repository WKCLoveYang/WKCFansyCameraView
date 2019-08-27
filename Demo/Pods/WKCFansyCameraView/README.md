# WKCFansyCameraView
自定义相机视图


[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/WKCFansyCameraView?style=flat)](https://cocoapods.org/pods/WKCFansyCameraView) [![License: MIT](https://img.shields.io/cocoapods/l/WKCFansyCameraView?style=flat)](http://opensource.org/licenses/MIT)

# 属性
| 属性 | 含义 |
| ---- | ---- |
| delegate | 代理 |
| premissionDeniedHandle | 权限没开时回调 |
| flashMode | 闪光灯模式 |
| position | 摄像头位置 |
| captureOrientation | 捕捉方向 |
| shouldScaleEnable | 是否捏合缩放,默认NO |
| shouldFocusEnable | 是否点击为聚焦点, 默认YES |
| shouldExposureEnable | 是否上下滑修改曝光值, 默认YES |
| focusImage | 聚焦点图片, 如果需要设置的赋值, 否则使用默认 |

# 方法
```swift

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


```
