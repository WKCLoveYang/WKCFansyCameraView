//
//  WKCCircleProgressView.h
//  Demo
//
//  Created by wkcloveYang on 2019/8/27.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCCircleProgressView : UIView

/**
  进度条颜色 默认红色
 */
@property (nonatomic, strong) UIColor *progressColor;

/**
  进度条背景色 默认灰色
 */
@property (nonatomic, strong) UIColor *progressBackgroundColor;

/**
  进度条宽度 默认5
 */
@property (nonatomic, assign) CGFloat progressWidth;

/**
  进度条进度 0-1
 */
@property (nonatomic, assign) float percent;

/**
  0顺时针 1逆时针
 */
@property (nonatomic, assign) BOOL clockwise;

/**
  记录进度的Label
 */
@property (nonatomic, strong) UILabel *centerLabel;

/**
  Label的背景色 默认clearColor
 */
@property (nonatomic, strong) UIColor *labelbackgroundColor;

/**
  Label的字体颜色 默认黑色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
  Label的字体大小 默认15
 */
@property (nonatomic, strong) UIFont *textFont;

@end

