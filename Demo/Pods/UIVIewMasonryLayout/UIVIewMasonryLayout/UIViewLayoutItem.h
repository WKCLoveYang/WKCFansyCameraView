//
//  UIViewLayoutItem.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/9.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LayoutType) {
    LayoutTypeEqual = 0,
    LayoutTypeGreat = 1,
    LayoutTypeLess  = 2
};


@interface UIViewLayoutItem : NSObject

@property (nonatomic, strong) id object;
@property (nonatomic, assign) LayoutType layoutType;
@property (nonatomic, assign) CGFloat offSet;
@property (nonatomic, assign) UIEdgeInsets insert;
@property (nonatomic, assign) CGFloat mutil;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat value;

@end

