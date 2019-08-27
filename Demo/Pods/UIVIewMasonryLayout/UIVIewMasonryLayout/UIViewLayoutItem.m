//
//  UIViewLayoutItem.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/9.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "UIViewLayoutItem.h"

@implementation UIViewLayoutItem

- (instancetype)init
{
    if (self = [super init]) {
        _offSet = 0;
        _insert = UIEdgeInsetsZero;
        _mutil = 0;
        _size = CGSizeZero;
        _value = 0;
    }
    
    return self;
}


@end
