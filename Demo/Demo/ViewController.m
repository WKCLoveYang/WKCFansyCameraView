//
//  ViewController.m
//  Demo
//
//  Created by wkcloveYang on 2019/8/26.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "ViewController.h"
#import <WKCFansyCameraView.h>
#import <UIView+MansonryLayout.h>
#import "UIDevice+Common.h"
#import "HUD.h"
#import "WKCFansyCameraPhotoButton.h"

#define SCREEN_WIDTH UIScreen.mainScreen.bounds.size.width
#define SCREEN_HEIGHT UIScreen.mainScreen.bounds.size.height

typedef NS_ENUM(NSInteger, WKCFansyCameraFrameMode) {
    WKCFansyCameraFrameModeFull = 0,
    WKCFansyCameraFrameMode11   = 1,
    WKCFansyCameraFrameMode43   = 2
};

@interface ViewController ()
<WKCFansyCameraViewDelegate>
{
    WKCFansyCameraFrameMode _frameMode;
}

@property (nonatomic, strong) WKCFansyCameraView * cameraView;
@property (nonatomic, strong) UIButton * flashButton;
@property (nonatomic, strong) UIButton * frameButton;
@property (nonatomic, strong) UIButton * switchButton;
@property (nonatomic, strong) WKCFansyCameraPhotoButton * photoButton;
@property (nonatomic, strong) UILabel * tipLabel;

@end

@implementation ViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.cameraView];
    [self.view addSubview:self.flashButton];
    [self.view addSubview:self.frameButton];
    [self.view addSubview:self.switchButton];
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.tipLabel];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    CGFloat magin = (SCREEN_WIDTH - 40 * 3) / 4.0;
    
    self.flashButton.wkc_left = EqualOffset(self.view, magin);
    self.flashButton.wkc_top = EqualOffset(self.view, UIDevice.statusBarHeight);
    self.flashButton.wkc_size = EqualSize(CGSizeMake(40, 40));
    
    self.frameButton.wkc_top = Equal(self.flashButton);
    self.frameButton.wkc_size = EqualSize(CGSizeMake(40, 40));
    self.frameButton.wkc_left = EqualOffset(self.flashButton.mas_trailing, magin);
    
    self.switchButton.wkc_top = Equal(self.flashButton);
    self.switchButton.wkc_size = EqualSize(CGSizeMake(40, 40));
    self.switchButton.wkc_left = EqualOffset(self.frameButton.mas_trailing, magin);
    
    self.photoButton.wkc_centerX = Equal(self.view);
    self.photoButton.wkc_bottom = EqualOffset(self.view, -40);
    self.photoButton.wkc_size = EqualSize(CGSizeMake(90, 90));
    
    self.tipLabel.wkc_bottom = EqualOffset(self.photoButton.mas_top, -8);
    self.tipLabel.wkc_centerX = Equal(self.view);
    
    [self.flashButton  wkc_makeLayout];
    [self.frameButton  wkc_makeLayout];
    [self.switchButton wkc_makeLayout];
    [self.photoButton  wkc_makeLayout];
    [self.tipLabel     wkc_makeLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender == _flashButton) {
        if (self.cameraView.position == AVCaptureDevicePositionFront) {
            [HUD showIndicatorWithTitle:@"前置摄像头不能使用闪光灯"];
            return;
        }
        
        [self.cameraView switchFlash];
        [sender setBackgroundImage:self.flashImage
                          forState:UIControlStateNormal];
    } else if (sender == _frameButton) {
        _frameMode ++;
        if (_frameMode == 3) {
            _frameMode = WKCFansyCameraFrameModeFull;
        }
        CGRect frame = [self frameWithMode];
        [self.cameraView resetCameraFrame:frame];
        [sender setBackgroundImage:self.frameImageMode
                          forState:UIControlStateNormal];
    } else if (sender == _switchButton) {
        [self.cameraView switchCamera];
        [_flashButton setBackgroundImage:self.flashImage
                          forState:UIControlStateNormal];
    }
}

- (UIImage *)flashImage
{
    if (self.cameraView.flashMode == AVCaptureTorchModeOn) {
        return [UIImage imageNamed:@"camera_flash_on"];
    } else if (self.cameraView.flashMode == AVCaptureTorchModeOff) {
        return [UIImage imageNamed:@"camera_flash_off"];
    } else {
        return [UIImage imageNamed:@"camera_flash_auto"];
    }
}

- (CGRect)frameWithMode
{
    CGFloat x = 0, y = 0, width = SCREEN_WIDTH, height = SCREEN_HEIGHT;
    switch (_frameMode) {
        case WKCFansyCameraFrameModeFull:
            break;
            
        case WKCFansyCameraFrameMode11:
        {
            height = SCREEN_WIDTH;
            y = (SCREEN_HEIGHT - height) / 2.0;
        }
            break;
        
        case WKCFansyCameraFrameMode43:
        {
            height = SCREEN_WIDTH * 4.0 / 3.0;
            y = (SCREEN_HEIGHT - height) / 2.0;
        }
            break;
            
        default:
            break;
    }
    
    return CGRectMake(x, y, width, height);
}

- (UIImage *)frameImageMode
{
    UIImage * image = nil;
    
    switch (_frameMode) {
        case WKCFansyCameraFrameModeFull:
            image = [UIImage imageNamed:@"camera_frame_full"];
            break;
            
        case WKCFansyCameraFrameMode11:
        {
            image = [UIImage imageNamed:@"camera_frame_11"];
        }
            break;
            
        case WKCFansyCameraFrameMode43:
        {
            image = [UIImage imageNamed:@"camera_frame_43"];
        }
            break;
            
        default:
            break;
    }
    
    return image;
}

#pragma mark -Lazy
- (WKCFansyCameraView *)cameraView
{
    if (!_cameraView) {
        _cameraView = [[WKCFansyCameraView alloc] initWithFrame:self.view.bounds cameraMode:WKCFansyCameraModeImageAndVideo position:AVCaptureDevicePositionFront];
        _cameraView.delegate = self;
    }
    
    return _cameraView;
}

- (UIButton *)flashButton
{
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_flashButton setBackgroundImage:self.flashImage  forState:UIControlStateNormal];
        _flashButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_flashButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _flashButton;
}

- (UIButton *)frameButton
{
    if (!_frameButton) {
        _frameButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_frameButton setBackgroundImage:[UIImage imageNamed:@"camera_frame_full"]  forState:UIControlStateNormal];
        _frameButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_frameButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _frameButton;
}

- (UIButton *)switchButton
{
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_switchButton setBackgroundImage:[UIImage imageNamed:@"camrea_swicth"]  forState:UIControlStateNormal];
        _switchButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_switchButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _switchButton;
}

- (WKCFansyCameraPhotoButton *)photoButton
{
    if (!_photoButton) {
        _photoButton = [[WKCFansyCameraPhotoButton alloc] init];
        __weak typeof(self)weakSelf = self;
        _photoButton.takePhotoBlock = ^{
            [weakSelf.cameraView takePhoto];
        };
        _photoButton.startRecordBlock = ^{
            [weakSelf.cameraView startRecord];
        };
        _photoButton.endRecordBlock = ^{
            [weakSelf.cameraView stopRecord];
        };
    }
    
    return _photoButton;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"长按录制";
    }
    
    return _tipLabel;
}


#pragma mark - WKCFansyCameraViewDelegate
- (void)fansyCamera:(WKCFansyCameraView *)fansyCamera didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    
}

- (void)fansyCamera:(WKCFansyCameraView *)fansyCamera didTakePhoto:(UIImage *)photo
{
   NSString * path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"photo.png"];
    BOOL isSuccess = [UIImagePNGRepresentation(photo) writeToFile:path atomically:YES];
    if (isSuccess) {
        NSLog(@"保存成功 : %@", path);
    }
}

- (void)fansyCamera:(WKCFansyCameraView *)fansyCamera didTakeVideo:(NSString *)videoPath
{
    NSLog(@"视频地址: %@", videoPath);
}

@end
