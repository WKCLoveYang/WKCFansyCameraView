//
//  WKCFansyCameraPhotoButton.m
//  Demo
//
//  Created by wkcloveYang on 2019/8/27.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCFansyCameraPhotoButton.h"
#import <UIView+MansonryLayout.h>
#import "WKCCircleProgressView.h"
#import "WKCWeakProxy.h"

@interface WKCFansyCameraPhotoButton()
{
    NSTimer * timer;
    NSInteger time;
}

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) WKCCircleProgressView * progressView;
@property  (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation WKCFansyCameraPhotoButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.contentView];
        [self addSubview:self.progressView];
        
        self.contentView.wkc_center = Equal(self);
        self.contentView.wkc_size = EqualSize(CGSizeMake(70, 70));
        
        self.progressView.wkc_edge = Equal(self);
        
        [self.contentView wkc_makeLayout];
        [self.progressView wkc_makeLayout];
        
        self.userInteractionEnabled = YES;
        
        [self addGestureRecognizer:self.longPress];
        
    }
    
    return self;
}

- (void)actionLongGesture:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        timer = [NSTimer timerWithTimeInterval:0.1 target:[WKCWeakProxy proxyWithTarget:self] selector:@selector(updateTime) userInfo:nil repeats:YES];
        [timer fire];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (timer) {
            if (time <= 3) {
                if (self.takePhotoBlock) {
                    self.takePhotoBlock();
                }
            } else {
                if (self.endRecordBlock) {
                    self.endRecordBlock();
                }
            }
            
            [timer invalidate];
            timer = nil;
            time = 0;
            self.progressView.percent = 0;
        }
    }
}

- (void)updateTime
{
    time ++;
    
    if (time - 4 >= 0) {
        if (time - 4 == 0) {
            if (self.startRecordBlock) {
                self.startRecordBlock();
            }
        }
        self.progressView.percent += 0.01;
    }
    
    if (time - 4 >= 100) {
        if (self.endRecordBlock) {
            self.endRecordBlock();
        }
        
        [timer invalidate];
        timer = nil;
        time = 0;
        self.progressView.percent = 0;
    }
}

#pragma mark -Lazy
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 35;
        _contentView.layer.masksToBounds = YES;
    }
    
    return _contentView;
}

- (WKCCircleProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[WKCCircleProgressView alloc] init];
    }
    
    return _progressView;
}

- (UILongPressGestureRecognizer *)longPress
{
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionLongGesture:)];
        _longPress.minimumPressDuration = 0;
    }
    
    return _longPress;
}

@end
