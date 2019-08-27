//
//  UIView+MansonryLayout.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/9.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "UIView+MansonryLayout.h"
#import <objc/runtime.h>

static NSString * const UIViewLayoutLeftKey = @"layout.left";
static NSString * const UIViewLayoutRightKey = @"layout.right";
static NSString * const UIViewLayoutTopKey = @"layout.top";
static NSString * const UIViewLayoutBottomKey = @"layout.bottom";
static NSString * const UIViewLayoutCenterKey = @"layout.center";
static NSString * const UIViewLayoutCenterXKey = @"layout.centerX";
static NSString * const UIViewLayoutCenterYKey = @"layout.centerY";
static NSString * const UIViewLayoutWidthKey = @"layout.width";
static NSString * const UIViewLayoutHeightKey = @"layout.height";
static NSString * const UIViewLayoutSizeKey = @"layout.size";
static NSString * const UIViewLayoutEdgeKey = @"layout.edge";


@implementation UIView (MansonryLayout)

- (void)setWkc_left:(UIViewLayoutItem *)wkc_left
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutLeftKey,
                             wkc_left,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_left
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutLeftKey);
}

- (void)setWkc_right:(UIViewLayoutItem *)wkc_right
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutRightKey,
                             wkc_right,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_right
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutRightKey);
}

- (void)setWkc_top:(UIViewLayoutItem *)wkc_top
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutTopKey,
                             wkc_top,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_top
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutTopKey);
}

- (void)setWkc_bottom:(UIViewLayoutItem *)wkc_bottom
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutBottomKey,
                             wkc_bottom,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_bottom
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutBottomKey);
}

- (void)setWkc_center:(UIViewLayoutItem *)wkc_center
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutCenterKey,
                             wkc_center,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_center
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutCenterKey);
}

- (void)setWkc_centerX:(UIViewLayoutItem *)wkc_centerX
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutCenterXKey,
                             wkc_centerX,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_centerX
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutCenterXKey);
}

- (void)setWkc_centerY:(UIViewLayoutItem *)wkc_centerY
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutCenterYKey,
                             wkc_centerY,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_centerY
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutCenterYKey);
}

- (void)setWkc_width:(UIViewLayoutItem *)wkc_width
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutWidthKey,
                             wkc_width,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_width
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutWidthKey);
}

- (void)setWkc_height:(UIViewLayoutItem *)wkc_height
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutHeightKey,
                             wkc_height,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_height
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutHeightKey);
}

- (void)setWkc_size:(UIViewLayoutItem *)wkc_size
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutSizeKey,
                             wkc_size,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_size
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutSizeKey);
}

- (void)setWkc_edge:(UIViewLayoutItem *)wkc_edge
{
    objc_setAssociatedObject(self,
                             &UIViewLayoutEdgeKey,
                             wkc_edge,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewLayoutItem *)wkc_edge
{
    return objc_getAssociatedObject(self,
                                    &UIViewLayoutEdgeKey);
}






- (void)wkc_makeLayout
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        [self layoutWithMake:make];
    }];
}

- (void)wkc_updateLayout
{
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        [self layoutWithMake:make];
    }];
}

- (void)wkc_removeLayout
{
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        [self layoutWithMake:make];
    }];
}

- (void)layoutWithMake:(MASConstraintMaker *)make
{
    if (self.wkc_edge) {
        [self layoutEdgeWithMake:make];
        return;
    }
    
    [self layoutLeftWithMake:make];
    [self layoutRightWithMake:make];
    [self layoutTopWithMake:make];
    [self layoutBottomWithMake:make];
    [self layoutCenterWithMake:make];
    [self layoutCenterXWithMake:make];
    [self layoutCenterYWithMake:make];
    [self layoutWidthWithMake:make];
    [self layoutHeightWithMake:make];
    [self layoutSizeWithMake:make];
    
    [self removeAllProperty];
}

- (void)layoutEdgeWithMake:(MASConstraintMaker *)make
{
    if (self.wkc_edge.layoutType == LayoutTypeEqual) {
    make.edges.mas_equalTo(self.wkc_edge.object).insets(self.wkc_edge.insert);
    } else if (self.wkc_edge.layoutType == LayoutTypeGreat) {
    make.edges.mas_greaterThanOrEqualTo(self.wkc_edge.object).insets(self.wkc_edge.insert);
    } else if (self.wkc_edge.layoutType == LayoutTypeLess) {
    make.edges.mas_lessThanOrEqualTo(self.wkc_edge.object).insets(self.wkc_edge.insert);
    }
}

- (void)layoutLeftWithMake:(MASConstraintMaker *)make
{
    if (!self.wkc_left) return;
    
    if (self.wkc_left.layoutType == LayoutTypeEqual) {
        if (self.wkc_left.mutil) {
            make.leading.mas_equalTo(self.wkc_left.object).multipliedBy(self.wkc_left.mutil);
        } else {
            make.leading.mas_equalTo(self.wkc_left.object).offset(self.wkc_left.offSet);
        }
    } else if (self.wkc_left.layoutType == LayoutTypeGreat) {
        if (self.wkc_left.mutil) {
            make.leading.mas_greaterThanOrEqualTo(self.wkc_left.object).multipliedBy(self.wkc_left.mutil);
        } else {
            make.leading.mas_greaterThanOrEqualTo(self.wkc_left.object).offset(self.wkc_left.offSet);
        }
    } else if (self.wkc_left.layoutType == LayoutTypeLess) {
        if (self.wkc_left.mutil) {
            make.leading.mas_lessThanOrEqualTo(self.wkc_left.object).multipliedBy(self.wkc_left.mutil);
        } else {
            make.leading.mas_lessThanOrEqualTo(self.wkc_left.object).offset(self.wkc_left.offSet);
        }
    }
}

- (void)layoutRightWithMake:(MASConstraintMaker *)make
{
    if (!self.wkc_right) return;
    
    if (self.wkc_right.layoutType == LayoutTypeEqual) {
        if (self.wkc_right.mutil) {
            make.trailing.mas_equalTo(self.wkc_right.object).multipliedBy(self.wkc_right.mutil);
        } else {
            make.trailing.mas_equalTo(self.wkc_right.object).offset(self.wkc_right.offSet);
        }
    } else if (self.wkc_right.layoutType == LayoutTypeGreat) {
        if (self.wkc_right.mutil) {
            make.trailing.mas_greaterThanOrEqualTo(self.wkc_right.object).multipliedBy(self.wkc_right.mutil);
        } else {
            make.trailing.mas_greaterThanOrEqualTo(self.wkc_right.object).offset(self.wkc_right.offSet);
        }
    } else if (self.wkc_right.layoutType == LayoutTypeLess) {
        if (self.wkc_right.mutil) {
            make.trailing.mas_lessThanOrEqualTo(self.wkc_right.object).multipliedBy(self.wkc_right.mutil);
        } else {
            make.trailing.mas_lessThanOrEqualTo(self.wkc_right.object).offset(self.wkc_right.offSet);
        }
    }
}

- (void)layoutTopWithMake:(MASConstraintMaker *)make
{
    if (!self.wkc_top) return;
    
    if (self.wkc_top.layoutType == LayoutTypeEqual) {
        if (self.wkc_top.mutil) {
            make.top.mas_equalTo(self.wkc_top.object).multipliedBy(self.wkc_top.mutil);
        } else {
            make.top.mas_equalTo(self.wkc_top.object).offset(self.wkc_top.offSet);
        }
    } else if (self.wkc_top.layoutType == LayoutTypeGreat) {
        if (self.wkc_top.mutil) {
            make.top.mas_greaterThanOrEqualTo(self.wkc_top.object).multipliedBy(self.wkc_top.mutil);
        } else {
            make.top.mas_greaterThanOrEqualTo(self.wkc_top.object).offset(self.wkc_top.offSet);
        }
    } else if (self.wkc_top.layoutType == LayoutTypeLess) {
        if (self.wkc_top.mutil) {
            make.top.mas_lessThanOrEqualTo(self.wkc_top.object).multipliedBy(self.wkc_top.mutil);
        } else {
            make.top.mas_lessThanOrEqualTo(self.wkc_top.object).offset(self.wkc_top.offSet);
        }
    }
}

- (void)layoutBottomWithMake:(MASConstraintMaker *)make
{
    if (!self.wkc_bottom) return;
    
    if (self.wkc_bottom.layoutType == LayoutTypeEqual) {
        if (self.wkc_bottom.mutil) {
            make.bottom.mas_equalTo(self.wkc_bottom.object).multipliedBy(self.wkc_bottom.mutil);
        } else {
            make.bottom.mas_equalTo(self.wkc_bottom.object).offset(self.wkc_bottom.offSet);
        }
    } else if (self.wkc_bottom.layoutType == LayoutTypeGreat) {
        if (self.wkc_bottom.mutil) {
            make.bottom.mas_greaterThanOrEqualTo(self.wkc_bottom.object).multipliedBy(self.wkc_bottom.mutil);
        } else {
            make.bottom.mas_greaterThanOrEqualTo(self.wkc_bottom.object).offset(self.wkc_bottom.offSet);
        }
    } else if (self.wkc_bottom.layoutType == LayoutTypeLess) {
        if (self.wkc_bottom.mutil) {
            make.bottom.mas_lessThanOrEqualTo(self.wkc_bottom.object).multipliedBy(self.wkc_bottom.mutil);
        } else {
            make.bottom.mas_lessThanOrEqualTo(self.wkc_bottom.object).offset(self.wkc_bottom.offSet);
        }
    }
}

- (void)layoutCenterWithMake:(MASConstraintMaker *)make
{
    if (!self.wkc_center) return;
    
    if (self.wkc_center.layoutType == LayoutTypeEqual) {
        make.center.mas_equalTo(self.wkc_center.object);
    } else if (self.wkc_center.layoutType == LayoutTypeGreat) {
        make.center.mas_greaterThanOrEqualTo(self.wkc_center.object);
    } else if (self.wkc_center.layoutType == LayoutTypeLess) {
        make.center.mas_lessThanOrEqualTo(self.wkc_center.object);
    }
}

- (void)layoutCenterXWithMake:(MASConstraintMaker *)make
{
    if (!self.wkc_centerX) return;
    
    if (self.wkc_centerX.layoutType == LayoutTypeEqual) {
        if (self.wkc_centerX.mutil) {
            make.centerX.mas_equalTo(self.wkc_centerX.object).multipliedBy(self.wkc_centerX.mutil);
        } else {
            make.centerX.mas_equalTo(self.wkc_centerX.object).offset(self.wkc_centerX.offSet);
        }
    } else if (self.wkc_centerX.layoutType == LayoutTypeGreat) {
        if (self.wkc_centerX.mutil) {
            make.centerX.mas_greaterThanOrEqualTo(self.wkc_centerX.object).multipliedBy(self.wkc_centerX.mutil);
        } else {
            make.centerX.mas_greaterThanOrEqualTo(self.wkc_centerX.object).offset(self.wkc_centerX.offSet);
        }
    } else if (self.wkc_centerX.layoutType == LayoutTypeLess) {
        if (self.wkc_centerX.mutil) {
            make.centerX.mas_lessThanOrEqualTo(self.wkc_centerX.object).multipliedBy(self.wkc_centerX.mutil);
        } else {
            make.centerX.mas_lessThanOrEqualTo(self.wkc_centerX.object).offset(self.wkc_centerX.offSet);
        }
    }
}

- (void)layoutCenterYWithMake:(MASConstraintMaker *)make
{
    if (!self.wkc_centerY) return;
    
    if (self.wkc_centerY.layoutType == LayoutTypeEqual) {
        if (self.wkc_centerY.mutil) {
            make.centerY.mas_equalTo(self.wkc_centerY.object).multipliedBy(self.wkc_centerY.mutil);
        } else {
            make.centerY.mas_equalTo(self.wkc_centerY.object).offset(self.wkc_centerY.offSet);
        }
    } else if (self.wkc_centerY.layoutType == LayoutTypeGreat) {
        if (self.wkc_centerY.mutil) {
            make.centerY.mas_greaterThanOrEqualTo(self.wkc_centerY.object).multipliedBy(self.wkc_centerY.mutil);
        } else {
            make.centerY.mas_greaterThanOrEqualTo(self.wkc_centerY.object).offset(self.wkc_centerY.offSet);
        }
    } else if (self.wkc_centerY.layoutType == LayoutTypeLess) {
        if (self.wkc_centerY.mutil) {
            make.centerY.mas_lessThanOrEqualTo(self.wkc_centerY.object).multipliedBy(self.wkc_centerY.mutil);
        } else {
            make.centerY.mas_lessThanOrEqualTo(self.wkc_centerY.object).offset(self.wkc_centerY.offSet);
        }
    }
}

- (void)layoutWidthWithMake:(MASConstraintMaker *)make
{
    if (!self.wkc_width) return;
    
    if (self.wkc_width.layoutType == LayoutTypeEqual) {
        if (self.wkc_width.value) {
            make.width.mas_equalTo(self.wkc_width.value);
        } else if (self.wkc_width.mutil) {
            make.width.mas_equalTo(self.wkc_width.object).multipliedBy(self.wkc_width.mutil);
        } else {
            make.width.mas_equalTo(self.wkc_width.object).offset(self.wkc_width.offSet);
        }
    } else if (self.wkc_width.layoutType == LayoutTypeGreat) {
        if (self.wkc_width.value) {
            make.width.mas_greaterThanOrEqualTo(self.wkc_width.value);
        } else if (self.wkc_width.mutil) {
            make.width.mas_greaterThanOrEqualTo(self.wkc_width.object).multipliedBy(self.wkc_width.mutil);
        } else {
            make.width.mas_greaterThanOrEqualTo(self.wkc_width.object).offset(self.wkc_width.offSet);
        }
    } else if (self.wkc_width.layoutType == LayoutTypeLess) {
        if (self.wkc_width.value) {
            make.width.mas_lessThanOrEqualTo(self.wkc_width.value);
        } else if (self.wkc_width.mutil) {
            make.width.mas_lessThanOrEqualTo(self.wkc_width.object).multipliedBy(self.wkc_width.mutil);
        } else {
            make.width.mas_lessThanOrEqualTo(self.wkc_width.object).offset(self.wkc_width.offSet);
        }
    }
}

- (void)layoutHeightWithMake:(MASConstraintMaker *)make
{
    if (!self.wkc_height) return;
    
    if (self.wkc_height.layoutType == LayoutTypeEqual) {
        if (self.wkc_height.value) {
            make.height.mas_equalTo(self.wkc_height.value);
        } else if (self.wkc_height.mutil) {
            make.height.mas_equalTo(self.wkc_height.object).multipliedBy(self.wkc_height.mutil);
        } else {
            make.height.mas_equalTo(self.wkc_height.object).offset(self.wkc_height.offSet);
        }
    } else if (self.wkc_height.layoutType == LayoutTypeGreat) {
        if (self.wkc_height.value) {
            make.height.mas_greaterThanOrEqualTo(self.wkc_height.value);
        } else if (self.wkc_height.mutil) {
            make.height.mas_greaterThanOrEqualTo(self.wkc_height.object).multipliedBy(self.wkc_height.mutil);
        } else {
            make.height.mas_greaterThanOrEqualTo(self.wkc_height.object).offset(self.wkc_height.offSet);
        }
    } else if (self.wkc_height.layoutType == LayoutTypeLess) {
        if (self.wkc_height.value) {
            make.height.mas_lessThanOrEqualTo(self.wkc_height.value);
        } else if (self.wkc_height.mutil) {
            make.height.mas_lessThanOrEqualTo(self.wkc_height.object).multipliedBy(self.wkc_height.mutil);
        } else {
            make.height.mas_lessThanOrEqualTo(self.wkc_height.object).offset(self.wkc_height.offSet);
        }
    }
}

- (void)layoutSizeWithMake:(MASConstraintMaker *)make
{
    if (!self.wkc_size) return;
    
    if (self.wkc_size.layoutType == LayoutTypeEqual) {
        if (self.wkc_size.object) {
            make.size.mas_equalTo(self.wkc_size.object);
        } else {
           make.size.mas_equalTo(self.wkc_size.size);
        }
    } else if (self.wkc_size.layoutType == LayoutTypeGreat) {
        if (self.wkc_size.object) {
            make.size.mas_greaterThanOrEqualTo(self.wkc_size.object);
        } else {
            make.size.mas_greaterThanOrEqualTo(self.wkc_size.size);
        }
    } else if (self.wkc_size.layoutType == LayoutTypeLess) {
        if (self.wkc_size.object) {
            make.size.mas_lessThanOrEqualTo(self.wkc_size.object);
        } else {
            make.size.mas_lessThanOrEqualTo(self.wkc_size.size);
        }
    }
}


- (void)removeAllProperty
{
    self.wkc_left = nil;
    self.wkc_right = nil;
    self.wkc_top = nil;
    self.wkc_bottom = nil;
    self.wkc_width = nil;
    self.wkc_height = nil;
    self.wkc_center = nil;
    self.wkc_centerX = nil;
    self.wkc_centerY = nil;
    self.wkc_size = nil;
    self.wkc_edge = nil;
}

@end
