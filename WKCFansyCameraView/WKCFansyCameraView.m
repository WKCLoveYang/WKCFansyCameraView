//
//  WKCFansyCameraView.m
//  BBC
//
//  Created by wkcloveYang on 2019/8/23.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCFansyCameraView.h"
#import "WKCFansyCameraRecordEncoder.h"
#import "WKCFansyCameraLightView.h"

#define WKCWeakSelf __weak typeof(self)weakSelf = self;

CGFloat WKCFansyCameraAnimationDuration = 0.3;

typedef NS_ENUM(NSInteger, WKCFansyCameraRunMode) {
    WKCFansyCameraRunModeCommon         = 0,
    WKCFansyCameraRunModeTakePhoto      = 1,
    WKCFansyCameraRunModeVideoRecord    = 2,
    WKCFansyCameraRunModeVideoRecordEnd = 3
};

@interface WKCFansyCameraView()
<AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureAudioDataOutputSampleBufferDelegate,
UIGestureRecognizerDelegate>
{
    WKCFansyCameraRunMode _runMode;
    CGFloat _startLocationY;
    CGFloat _startValue;
    CGFloat _currentZoomFactor;
}

@property (nonatomic, assign) WKCFansyCameraMode mode;
@property (nonatomic, assign) AVCaptureDevicePosition position;
@property (nonatomic, strong) AVCaptureDevice * captureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput * deviceInput;
@property (nonatomic, strong) AVCaptureSession * captureSession;
@property (nonatomic, strong) AVCaptureVideoDataOutput * captureOutput;
@property (nonatomic, strong) AVCaptureConnection * videoConnection;
@property (nonatomic, strong) AVCaptureDeviceInput * audioInput;
@property (nonatomic, strong) AVCaptureAudioDataOutput * audioOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;

@property (nonatomic, strong) dispatch_queue_t videoCaptureQueue;
@property (nonatomic, strong) dispatch_queue_t audioCaptureQueue;

@property (nonatomic, strong) WKCFansyCameraRecordEncoder * recordEncoder;
@property (nonatomic, strong) NSString * videoPath;

@property (nonatomic, assign) CGPoint focusPoint;
@property (nonatomic, assign) CGPoint exposurePoint;
@property (nonatomic, assign) CGFloat exposureValue;

@property (nonatomic, strong) UIVisualEffectView * blurView;
@property (nonatomic, strong) UIImageView * focusImageView;
@property (nonatomic, strong) NSTimer * focusTimer;
@property (nonatomic, strong) WKCFansyCameraLightView * lightView;

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer * pinGesture;

@end

@implementation WKCFansyCameraView

- (instancetype)initWithFrame:(CGRect)frame
                   cameraMode:(WKCFansyCameraMode)mode
                    position:(AVCaptureDevicePosition)position
{
    if (self = [super initWithFrame:frame]) {
        
        _mode = mode;
        _position = position;
        
        // 相机权限判断
        [WKCFansyCameraView askCameraPremission:^(BOOL isAgreed) {
            if (!isAgreed) {
                if (self.premissionDeniedHandle) {
                    self.premissionDeniedHandle();
                }
            } else {
                [self setupSubviews];
            }
        }];
    }
    
    return self;
}

+ (void)askCameraPremission:(void(^)(BOOL isAgreed))handle
{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        if (handle) {
            handle(NO);
        }
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                             completionHandler:^(BOOL granted) {
                                 if (handle) {
                                     handle(granted);
                                 }
                             }];
}

- (void)setupSubviews
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.shouldExposureEnable = YES;
        
        [self.layer addSublayer:self.previewLayer];
        [self addSubview:self.blurView];
        [self addSubview:self.focusImageView];
        [self addSubview:self.lightView];
        [self setupLightLayout];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.tapGesture];

        [self startCapture];
    });
}

- (void)setupLightLayout
{
    self.lightView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:self.lightView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20];
    NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem:self.lightView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:self.lightView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:[WKCFansyCameraLightView itemSize].width];
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:self.lightView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:[WKCFansyCameraLightView itemSize].height];
    
    [self addConstraint:right];
    [self addConstraint:centerY];
    [self addConstraint:width];
    [self addConstraint:height];
}

- (void)startCapture
{
    if (!self.captureSession.isRunning) {
        [self.captureSession startRunning];
    }
}

- (void)stopCapture
{
    if (self.captureSession.isRunning) {
        [self.captureSession stopRunning];
    }
}

- (void)switchCamera
{
    [self.captureSession stopRunning];
    
    AVCaptureDevicePosition newPosition = _position == AVCaptureDevicePositionFront ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    _position = newPosition;
    
    // 如果前置,自动关闭闪光灯
    if (newPosition == AVCaptureDevicePositionFront) {
        [self.captureDevice lockForConfiguration:nil];
        self.captureDevice.torchMode = AVCaptureTorchModeOff;
        [self.captureDevice unlockForConfiguration];
    }
    
    [self.captureSession removeInput:self.deviceInput];
    self.captureDevice = nil;
    self.deviceInput = nil;
    
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput:self.deviceInput];
    }
    
    [self.captureSession beginConfiguration];
    if ([self.captureDevice lockForConfiguration:nil]) {
        [self.captureDevice setActiveVideoMinFrameDuration:CMTimeMake(1, 30)];
        [self.captureDevice unlockForConfiguration];
    }
    [self.captureSession commitConfiguration];
    
    self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    if (self.videoConnection.supportsVideoMirroring) {
        self.videoConnection.videoMirrored = _position == AVCaptureDevicePositionFront;
    }
    [self.captureSession startRunning];
    
    self.blurView.hidden = NO;
    WKCWeakSelf
    [UIView transitionWithView:self duration:WKCFansyCameraAnimationDuration options:_position == AVCaptureDevicePositionFront ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        NSLog(@"切换摄像头...........");
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.blurView.hidden = YES;
        }
    }];
}

- (void)takePhoto
{
    _runMode = WKCFansyCameraRunModeTakePhoto;
    
    if (_position == AVCaptureDevicePositionFront) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow * window = UIApplication.sharedApplication.windows.firstObject;
            UIView * whiteView = [[UIView alloc] initWithFrame:window.bounds];
            whiteView.backgroundColor = UIColor.whiteColor;
            whiteView.alpha = 0.3;
            [window addSubview:whiteView];
            CGFloat duration = WKCFansyCameraAnimationDuration / 2.0;
            [UIView animateWithDuration:duration
                             animations:^{
                                 whiteView.alpha = 1.0;
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:duration
                                                  animations:^{
                                                      whiteView.alpha = 0;
                                                  }
                                                  completion:^(BOOL finished) {
                                                      [whiteView removeFromSuperview];
                                                  }];
                             }];
        });
    }
}

- (void)switchFlash
{
    AVCaptureTorchMode newMode = AVCaptureTorchModeOff;
    if (self.captureDevice.torchMode == AVCaptureTorchModeOff) {
        newMode = AVCaptureTorchModeAuto;
    } else if (self.captureDevice.torchMode == AVCaptureTorchModeAuto) {
        newMode = AVCaptureTorchModeOn;
    } else {
        newMode = AVCaptureTorchModeOff;
    }
    
    [self.captureDevice lockForConfiguration:nil];
    self.captureDevice.torchMode = newMode;
    [self.captureDevice unlockForConfiguration];
}

- (void)startRecord
{
    _runMode = WKCFansyCameraRunModeVideoRecord;
}

- (void)stopRecord
{
   _runMode = WKCFansyCameraRunModeVideoRecordEnd;
}

- (void)resetCameraFrame:(CGRect)frame
{
    self.blurView.hidden = NO;
    
    [UIView animateWithDuration:WKCFansyCameraAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frame = frame;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             self.blurView.hidden = YES;
                         }
                     }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.previewLayer.frame = self.bounds;
    self.focusImageView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
}

- (void)setVideoZoom:(CGFloat)zoom
{
    if (self.captureDevice.activeFormat.videoMaxZoomFactor > zoom && zoom >= 1.0) {
        [self.captureDevice lockForConfiguration:nil];
        [self.captureDevice rampToVideoZoomFactor:zoom withRate:4.0];
        [self.captureDevice unlockForConfiguration];
    }
    
    if (zoom < 1.0 && self.captureDevice.videoZoomFactor >= 1) {
        [self.captureDevice lockForConfiguration:nil];
        [self.captureDevice rampToVideoZoomFactor:(self.captureDevice.videoZoomFactor - zoom) withRate:4.0];
        [self.captureDevice unlockForConfiguration];
    }
    
}

- (void)resetFocusAndExposure
{
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    BOOL canResetFocus = [self.captureDevice isFocusPointOfInterestSupported] && [self.captureDevice isFocusModeSupported:focusMode];
    
    AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    BOOL canResetExposure = [self.captureDevice isExposurePointOfInterestSupported] && [self.captureDevice isExposureModeSupported:exposureMode];
    
    CGPoint centerPoint = CGPointMake(0.5f, 0.5f);
    
    if (![self.captureDevice lockForConfiguration:nil]) return;
    if (canResetFocus) {
        self.captureDevice.focusMode = focusMode;
    }
    if (canResetExposure) {
        self.captureDevice.exposureMode = exposureMode;
        self.captureDevice.exposurePointOfInterest = centerPoint;
    }
    [self.captureDevice unlockForConfiguration];
}

- (void)actionTapGesture:(UITapGestureRecognizer *)sender
{
    self.focusImageView.hidden = NO;
    
    CGPoint center = [sender locationInView:sender.view];
    CGFloat xValue = center.y / self.bounds.size.height;
    CGFloat yValue = _position == AVCaptureDevicePositionFront ? (center.x / self.bounds.size.width) : (1 - center.x / self.bounds.size.width);
    self.focusPoint = CGPointMake(xValue,yValue);
    self.exposurePoint = CGPointMake(xValue,yValue);
    
    self.focusImageView.center = center;
    self.focusImageView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:WKCFansyCameraAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.focusImageView.transform = CGAffineTransformMakeScale(0.67, 0.67);
    } completion:nil];
    
    [self hidenFocusImageView];
}

- (void)hidenFocusImageView
{
    [self.focusTimer invalidate];
    
    self.focusTimer = [NSTimer timerWithTimeInterval:2.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.focusImageView.hidden = YES;
            self.lightView.hidden = YES;
            [timer invalidate];
        });
    }];
    
    [[NSRunLoop mainRunLoop] addTimer:self.focusTimer
                              forMode:NSDefaultRunLoopMode];
}

- (void)actionPinGesture:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        CGFloat currentZoomFactor = _currentZoomFactor * sender.scale;
        if (currentZoomFactor < self.captureDevice.activeFormat.videoMaxZoomFactor && currentZoomFactor > 1.0) {
            [self setVideoZoom:currentZoomFactor];
        }
    } 
}


- (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef
{
    CVPixelBufferLockBaseAddress(pixelBufferRef, 0);
    
    float width = CVPixelBufferGetWidth(pixelBufferRef);
    float height = CVPixelBufferGetHeight(pixelBufferRef);
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBufferRef];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 width,
                                                 height)];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    CVPixelBufferUnlockBaseAddress(pixelBufferRef, 0);
    
    return image;
}

- (UIImage*)crop:(CGRect)rect image:(UIImage *)image
{
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    UIImage *img = nil;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    [image drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)cutoutImage:(UIImage *)image
{
    CGSize size = self.frame.size;
    CGFloat rWidth = size.width;
    CGFloat rHeight = size.height;
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat oWidth;
    CGFloat oHeight;
    CGRect rect;
    if (rWidth/rHeight > imageWidth/imageHeight) {
        oWidth = imageWidth;
        oHeight = imageWidth*rHeight/rWidth;
        rect = CGRectMake(0, floor((imageHeight-oHeight)/2.0), floor(oWidth), floor(oHeight));
    } else {
        oHeight = imageHeight;
        oWidth = imageHeight*rWidth/rHeight;
        rect = CGRectMake(floor((imageWidth-oWidth)/2.0), 0, floor(oWidth), floor(oHeight));
    }
    UIImage *cropImage = [self crop:rect image:image];
    return cropImage;
}

#pragma mark -Lazy
- (AVCaptureDevice *)captureDevice
{
    if (!_captureDevice) {
        _captureDevice = [self captureDeviceWithPosition:_position];
    }
    
    return _captureDevice;
}

- (AVCaptureDeviceInput *)deviceInput
{
    if (!_deviceInput) {
        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:nil];
    }
    
    return _deviceInput;
}

- (AVCaptureSession *)captureSession
{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        if ([_captureSession canAddInput:self.deviceInput]) {
            [_captureSession addInput:self.deviceInput];
        }
        if ([_captureSession canAddOutput:self.captureOutput]) {
            [_captureSession addOutput:self.captureOutput];
        }
        // 拍视频模式加入
        if (_mode == WKCFansyCameraModeImageAndVideo) {
            if ([_captureSession canAddInput:self.audioInput]) {
                [_captureSession addInput:self.audioInput];
            }
            if ([_captureSession canAddOutput:self.audioOutput]) {
                [_captureSession addOutput:self.audioOutput];
            }
        }
        self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        if (self.videoConnection.supportsVideoMirroring && _position == AVCaptureDevicePositionFront) {
            self.videoConnection.videoMirrored = YES;
        }
        [_captureSession beginConfiguration];
        if ([self.captureDevice lockForConfiguration:nil]) {
            [self.captureDevice setActiveVideoMinFrameDuration:CMTimeMake(1, 30)];
            [self.captureDevice unlockForConfiguration];
        }
        [_captureSession commitConfiguration];
    }
    
    return _captureSession;
}

- (AVCaptureVideoDataOutput *)captureOutput
{
    if (!_captureOutput) {
        _captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        _captureOutput.alwaysDiscardsLateVideoFrames = YES;
        _captureOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
        [_captureOutput setSampleBufferDelegate:self queue:self.videoCaptureQueue];
    }
    
    return _captureOutput;
}



- (AVCaptureConnection *)videoConnection
{
    if (!_videoConnection) {
        _videoConnection = [self.captureOutput connectionWithMediaType:AVMediaTypeVideo];
        _videoConnection.automaticallyAdjustsVideoMirroring = NO;
    }
    
    return _videoConnection;
}

- (AVCaptureDeviceInput *)audioInput
{
    if (!_audioInput) {
        AVCaptureDevice *mic = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error;
        _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:mic error:&error];
    }
    
    return _audioInput;
}

- (AVCaptureAudioDataOutput *)audioOutput
{
    if (!_audioOutput) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioOutput setSampleBufferDelegate:self queue:self.audioCaptureQueue];
    }
    
    return _audioOutput;
}

- (dispatch_queue_t)videoCaptureQueue
{
    if (!_videoCaptureQueue) {
        _videoCaptureQueue = dispatch_queue_create("com.fansyCamera.videoCaptureQueue", NULL);
    }
    return _videoCaptureQueue;
}

- (dispatch_queue_t)audioCaptureQueue
{
    if (!_audioCaptureQueue) {
        _audioCaptureQueue = dispatch_queue_create("com.fansyCamera.audioCaptureQueue", NULL);
    }
    return _audioCaptureQueue;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        _previewLayer.frame = self.bounds;
    }
    
    return _previewLayer;
}

- (AVCaptureDevice *)captureDeviceWithPosition:(AVCaptureDevicePosition)position
{
    AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    NSArray *devices  = deviceDiscoverySession.devices;
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (NSString *)videoPath
{
    if (!_videoPath) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYYMMddhhmmssSS"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        _videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",dateString]];
    }
    
    return _videoPath;
}

- (UIVisualEffectView *)blurView
{
    if (!_blurView) {
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _blurView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        _blurView.hidden = YES;
    }
    
    return _blurView;
}

- (UIImageView *)focusImageView
{
    if (!_focusImageView) {
        _focusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_focus"]];
        _focusImageView.contentMode = UIViewContentModeScaleAspectFit;
        _focusImageView.frame = CGRectMake(0, 0, 70, 70);
        _focusImageView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        _focusImageView.hidden = YES;
    }
    
    return _focusImageView;
}

- (WKCFansyCameraLightView *)lightView
{
    if (!_lightView) {
        _lightView = [[WKCFansyCameraLightView alloc] init];
        _lightView.progress = self.captureDevice.exposureTargetBias;
        _lightView.hidden = YES;
    }
    
    return _lightView;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    }
    
    return _tapGesture;
}

- (UIPinchGestureRecognizer *)pinGesture
{
    if (!_pinGesture) {
        _pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(actionPinGesture:)];
        _pinGesture.delegate = self;
    }
    
    return _pinGesture;
}

#pragma mark -Gesture
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.pinGesture) {
        _currentZoomFactor = self.captureDevice.videoZoomFactor;
    }
    return YES;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // _shouldExposureEnable NO时不处理
    if (!_shouldExposureEnable) return;
    
    CGPoint center = [touches.allObjects.lastObject locationInView:self];
    
    _startLocationY = center.y;
    _startValue = self.lightView.progress;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // _shouldExposureEnable NO时不处理
    if (!_shouldExposureEnable) return;
    
    self.lightView.hidden = NO;
    
    CGPoint movePoint = [touches.allObjects.lastObject locationInView:self];
    CGFloat movePointY = movePoint.y - _startLocationY;
    CGFloat height = CGRectGetHeight(self.bounds) / 2.0;
    CGFloat scale = movePointY / height;
    CGFloat value = _startValue + scale;
    if (value <= 0 ) value = 0;
    if (value >= 1) value = 1;
    
    self.lightView.progress = value;
    
    // 0 - 1的范围改成 (-2, 2)
    CGFloat exposureValue = value - 1;
    if (value < 0.5) {
        exposureValue = (0.5 - value) * -4;
    } else {
        exposureValue = (value - 0.5) * 4;
    }
    
    self.exposureValue = exposureValue;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // _shouldExposureEnable NO时不处理
    if (!_shouldExposureEnable) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lightView.hidden = YES;
    });
}

#pragma mark -AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (_mode == WKCFansyCameraModeImageAndVideo) {
        if (output == self.audioOutput ) {
            if (_runMode == WKCFansyCameraRunModeVideoRecord) {
                if (!self.recordEncoder) return;
                CFRetain(sampleBuffer);
                [self.recordEncoder encodeFrame:sampleBuffer
                                    pixelBuffer:nil
                                       isRecord:NO];
                CFRelease(sampleBuffer);
            }
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fansyCamera:didOutputVideoSampleBuffer:)]) {
        [self.delegate fansyCamera:self didOutputVideoSampleBuffer:sampleBuffer];
    }
    
    switch (_runMode) {
        case WKCFansyCameraRunModeCommon:
        {
            
        }
            break;
            
        case WKCFansyCameraRunModeTakePhoto:
        {
            _runMode = WKCFansyCameraRunModeCommon;
            
            CVPixelBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            UIImage * image = [self imageFromPixelBuffer:buffer];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage * photo = [self cutoutImage:image]; //按当前视图裁剪
                if (self.delegate && [self.delegate respondsToSelector:@selector(fansyCamera:didTakePhoto:)]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(WKCFansyCameraAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.delegate fansyCamera:self didTakePhoto:photo];
                    });
                }
            });
        }
            break;
            
        case WKCFansyCameraRunModeVideoRecord:
        {
            //Image模式不处理
            if (_mode == WKCFansyCameraModeImage) {
                _runMode = WKCFansyCameraRunModeCommon;
                break;
            }
            
            if (!self.recordEncoder) {
                CVPixelBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                float frameWidth = CVPixelBufferGetWidth(buffer);
                float frameHeight = CVPixelBufferGetHeight(buffer);
                if (frameWidth != 0 && frameHeight != 0) {
                    self.recordEncoder = [WKCFansyCameraRecordEncoder encoderForPath:self.videoPath Height:frameHeight width:frameWidth channels:1 samples:44100];
                }
            }
            CFRetain(sampleBuffer);
            [self.recordEncoder encodeFrame:sampleBuffer pixelBuffer:CMSampleBufferGetImageBuffer(sampleBuffer) isRecord:YES];
            CFRelease(sampleBuffer);
        }
            break;
            
        case WKCFansyCameraRunModeVideoRecordEnd:
        {
            _runMode = WKCFansyCameraRunModeCommon;
            
            //Image模式不处理
            if (_mode == WKCFansyCameraModeImage) {
                break;
            }
            
            if (self.recordEncoder.writer.status == AVAssetWriterStatusUnknown) {
                self.videoPath = nil;
                self.recordEncoder = nil;
            } else {
                WKCWeakSelf
                [self.recordEncoder finishWithCompletionHandler:^{
                    NSString * path = weakSelf.recordEncoder.path;
                    weakSelf.videoPath = nil;
                    weakSelf.recordEncoder = nil;
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(fansyCamera:didTakeVideo:)]) {
                        [weakSelf.delegate fansyCamera:weakSelf didTakeVideo:path];
                    }
                }];
            }
        }
            break;
            
        default:
            break;
    }
}



#pragma mark -Setter
- (void)setCaptureOrientation:(AVCaptureVideoOrientation)captureOrientation
{
    _captureOrientation = captureOrientation;
    self.videoConnection.videoOrientation = captureOrientation;
}

- (void)setFocusPoint:(CGPoint)focusPoint
{
    _focusPoint = focusPoint;
    
    if (!self.captureDevice.focusPointOfInterestSupported) return;
    if (![self.captureDevice lockForConfiguration:nil]) return;
    self.captureDevice.focusPointOfInterest = focusPoint;
    self.captureDevice.focusMode = AVCaptureFocusModeAutoFocus;
    [self.captureDevice unlockForConfiguration];
}

- (void)setExposurePoint:(CGPoint)exposurePoint
{
    _exposurePoint = exposurePoint;
    
    if (!self.captureDevice.exposurePointOfInterestSupported) return;
    if (!self.captureDevice.focusPointOfInterestSupported) return;
    self.captureDevice.exposureMode = AVCaptureExposureModeLocked;
    self.captureDevice.exposurePointOfInterest = exposurePoint;
    self.captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    [self.captureDevice unlockForConfiguration];
}

- (void)setExposureValue:(CGFloat)exposureValue
{
    _exposureValue = exposureValue;
    
    if (![self.captureDevice lockForConfiguration:nil]) return;
    self.captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    [self.captureDevice setExposureTargetBias:exposureValue completionHandler:nil];
    [self.captureDevice unlockForConfiguration];
}

- (void)setFocusImage:(UIImage *)focusImage
{
    _focusImage = focusImage;
    self.focusImageView.image = focusImage;
}

- (void)setShouldScaleEnable:(BOOL)shouldScaleEnable
{
    _shouldScaleEnable = shouldScaleEnable;
    
    if (shouldScaleEnable) {
        [self addGestureRecognizer:self.pinGesture];
    } else {
        [self removeGestureRecognizer:self.pinGesture];
    }
}

- (void)setShouldFocusEnable:(BOOL)shouldFocusEnable
{
    _shouldFocusEnable = shouldFocusEnable;
    
    if (shouldFocusEnable) {
        [self addGestureRecognizer:self.tapGesture];
    } else {
        [self removeGestureRecognizer:self.tapGesture];
    }
}

- (AVCaptureTorchMode)flashMode
{
    return self.captureDevice.torchMode;
}

@end
