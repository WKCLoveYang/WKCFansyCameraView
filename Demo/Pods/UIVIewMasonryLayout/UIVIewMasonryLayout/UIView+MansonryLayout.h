//
//  UIView+MansonryLayout.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/9.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UIViewLayoutItemMaker.h"

@interface UIView (MansonryLayout)

@property (nonatomic, weak) UIViewLayoutItem * wkc_left;
@property (nonatomic, weak) UIViewLayoutItem * wkc_right;
@property (nonatomic, weak) UIViewLayoutItem * wkc_top;
@property (nonatomic, weak) UIViewLayoutItem * wkc_bottom;
@property (nonatomic, weak) UIViewLayoutItem * wkc_center;
@property (nonatomic, weak) UIViewLayoutItem * wkc_centerX;
@property (nonatomic, weak) UIViewLayoutItem * wkc_centerY;
@property (nonatomic, weak) UIViewLayoutItem * wkc_width;
@property (nonatomic, weak) UIViewLayoutItem * wkc_height;
@property (nonatomic, weak) UIViewLayoutItem * wkc_size;
@property (nonatomic, weak) UIViewLayoutItem * wkc_edge;


- (void)wkc_makeLayout;
- (void)wkc_updateLayout;
- (void)wkc_removeLayout;

@end

