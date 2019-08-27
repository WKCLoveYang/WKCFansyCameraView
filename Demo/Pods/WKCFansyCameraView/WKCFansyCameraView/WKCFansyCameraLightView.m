//
//  FaceSDKLittleCameraLightView.m
//  PhotoFace
//
//  Created by wkcloveYang on 2019/7/13.
//  Copyright © 2019 PhotoFace. All rights reserved.
//

#import "WKCFansyCameraLightView.h"

@interface WKCFansyCameraLightView()

@property (nonatomic, strong) UIView * upView;
@property (nonatomic, strong) UIView * downView;
@property (nonatomic, strong) UIImageView * iconImageView;

@end

@implementation WKCFansyCameraLightView

+ (CGSize)itemSize
{
    return CGSizeMake(27, 145);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.opacity = 0.0;
        
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews
{
    [self addSubview:self.upView];
    [self addSubview:self.downView];
    [self addSubview:self.iconImageView];
}

#pragma mark - Proeprty
- (UIView *)upView
{
    if (!_upView) {
        _upView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 3, self.maxProgressHeight * 0.5)];
        _upView.backgroundColor = UIColor.whiteColor;
        _upView.layer.cornerRadius = 1.5;
        _upView.layer.masksToBounds = YES;
    }
    
    return _upView;
}

- (UIView *)downView
{
    if (!_downView) {
        _downView = [[UIView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(self.iconImageView.frame) + 6, 3, self.maxProgressHeight * 0.5)];
        _downView.backgroundColor = UIColor.whiteColor;
        _downView.layer.cornerRadius = 1.5;
        _downView.layer.masksToBounds = YES;
    }
    
    return _downView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_light"]];
        _iconImageView.frame = CGRectMake(0, CGRectGetMaxY(self.upView.frame) + 6, 27, 27);
    }
    
    return _iconImageView;
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    self.layer.opacity = 1.0;
    
    self.upView.frame = [self upFrameWithProgress:progress];
    self.iconImageView.frame = [self iconFrame];
    self.downView.frame = [self downFrame];
}


// progress为1时最大高度
- (CGFloat)maxProgressHeight
{
    return WKCFansyCameraLightView.itemSize.height - 27 - 12;
}

- (CGRect)upFrameWithProgress:(CGFloat)progress
{
    CGFloat x = 12, y = 0, width = 3, height = self.maxProgressHeight * progress;
    return CGRectMake(x, y, width, height);
}

- (CGRect)iconFrame
{
   return CGRectMake(0, CGRectGetMaxY(self.upView.frame) + 6, 27, 27);
}

- (CGRect)downFrame
{
    CGFloat x = 12, y = CGRectGetMaxY(self.iconImageView.frame) + 6, width = 3, height = WKCFansyCameraLightView.itemSize.height - y;
    return CGRectMake(x, y, width, height);
}

@end
