//
//  UIViewLayoutItemMaker.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/9.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "UIViewLayoutItemMaker.h"

@implementation UIViewLayoutItemMaker

+ (UIViewLayoutItem *)layoutEqualWithObject:(id)object
{
    return [self layoutEqualWithObject:object
                                Offset:0];
}

+ (UIViewLayoutItem *)layoutGreatWithObject:(id)object
{
    return [self layoutGreatWithObject:object
                                Offset:0];
}

+ (UIViewLayoutItem *)layoutLessWithObject:(id)object
{
    return [self layoutLessWithObject:object
                               Offset:0];
}

+ (UIViewLayoutItem *)layoutEqualWithObject:(id)object
                                     Offset:(CGFloat)offset
{
    return [self layoutOffsetWithType:LayoutTypeEqual
                               object:object
                               offset:offset];
}

+ (UIViewLayoutItem *)layoutGreatWithObject:(id)object
                                     Offset:(CGFloat)offset
{
    return [self layoutOffsetWithType:LayoutTypeGreat
                               object:object
                               offset:offset];
}

+ (UIViewLayoutItem *)layoutLessWithObject:(id)object
                                    Offset:(CGFloat)offset
{
    return [self layoutOffsetWithType:LayoutTypeLess
                               object:object
                               offset:offset];
}


+ (UIViewLayoutItem *)layoutOffsetWithType:(LayoutType)type
                                    object:(id)object
                                    offset:(CGFloat)offset
{
    UIViewLayoutItem * item = [[UIViewLayoutItem alloc] init];
    item.layoutType = type;
    item.object = object;
    item.offSet = offset;
    return item;
}









+ (UIViewLayoutItem *)layoutInsertEqualWithObject:(id)object
                                           Insert:(UIEdgeInsets)insert
{
    return [self layoutInsertWithType:LayoutTypeEqual
                               object:object
                               insert:insert];
}

+ (UIViewLayoutItem *)layoutInsertGreatWithObject:(id)object
                                           Insert:(UIEdgeInsets)insert
{
    return [self layoutInsertWithType:LayoutTypeGreat
                               object:object
                               insert:insert];
}

+ (UIViewLayoutItem *)layoutInsertLessWithObject:(id)object
                                          Insert:(UIEdgeInsets)insert
{
    return [self layoutInsertWithType:LayoutTypeLess
                               object:object
                               insert:insert];
}

+ (UIViewLayoutItem *)layoutInsertWithType:(LayoutType)type
                                    object:(id)object
                                    insert:(UIEdgeInsets)insert
{
    UIViewLayoutItem * item = [[UIViewLayoutItem alloc] init];
    item.layoutType = type;
    item.object = object;
    item.insert = insert;
    return item;
}














+ (UIViewLayoutItem *)layoutMutilEqualWithObject:(id)object
                                           Mutil:(CGFloat)mutil
{
    return [self layoutMutilWithType:LayoutTypeEqual
                              object:object
                               mutil:mutil];
}

+ (UIViewLayoutItem *)layoutMutilGreatWithObject:(id)object
                                           Mutil:(CGFloat)mutil
{
    return [self layoutMutilWithType:LayoutTypeGreat
                              object:object
                               mutil:mutil];
}

+ (UIViewLayoutItem *)layoutMutilLessWithObject:(id)object
                                          Mutil:(CGFloat)mutil
{
    return [self layoutMutilWithType:LayoutTypeLess
                              object:object
                               mutil:mutil];
}

+ (UIViewLayoutItem *)layoutMutilWithType:(LayoutType)type
                                   object:(id)object
                                    mutil:(CGFloat)mutil
{
    UIViewLayoutItem * item = [[UIViewLayoutItem alloc] init];
    item.layoutType = type;
    item.object = object;
    item.mutil = mutil;
    return item;
}




+ (UIViewLayoutItem *)layoutSizeEqualWithSize:(CGSize)size
{
    return [self layoutSizeWithType:LayoutTypeEqual
                               size:size];
}

+ (UIViewLayoutItem *)layoutSizeGreatWithSize:(CGSize)size
{
    return [self layoutSizeWithType:LayoutTypeGreat
                               size:size];
}

+ (UIViewLayoutItem *)layoutSizeLessWithSize:(CGSize)size
{
    return [self layoutSizeWithType:LayoutTypeLess
                               size:size];
}

+ (UIViewLayoutItem *)layoutSizeWithType:(LayoutType)type
                                    size:(CGSize)size
{
    UIViewLayoutItem * item = [[UIViewLayoutItem alloc] init];
    item.layoutType = type;
    item.size = size;
    return item;
}








+ (UIViewLayoutItem *)layoutValueEqualWithValue:(CGFloat)value
{
    return [self layoutValueWithType:LayoutTypeEqual
                               value:value];
}

+ (UIViewLayoutItem *)layoutValueGreatWithValue:(CGFloat)value
{
    return [self layoutValueWithType:LayoutTypeGreat
                               value:value];
}

+ (UIViewLayoutItem *)layoutValueLessWithValue:(CGFloat)value
{
    return [self layoutValueWithType:LayoutTypeLess
                               value:value];
}

+ (UIViewLayoutItem *)layoutValueWithType:(LayoutType)type
                                     value:(CGFloat)value
{
    UIViewLayoutItem * item = [[UIViewLayoutItem alloc] init];
    item.layoutType = type;
    item.value = value;
    return item;
}



@end
