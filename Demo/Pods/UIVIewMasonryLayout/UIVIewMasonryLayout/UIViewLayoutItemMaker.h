//
//  UIViewLayoutItemMaker.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/9.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewLayoutItem.h"

#define Equal(object)                         [UIViewLayoutItemMaker layoutEqualWithObject:object]
#define Great(object)                         [UIViewLayoutItemMaker layoutGreatWithObject:object]
#define Less(object)                          [UIViewLayoutItemMaker layoutLessWithObject:object]

#define EqualOffset(object, offset)           [UIViewLayoutItemMaker layoutEqualWithObject:object Offset:offset]
#define GreatOffset(object, offset)           [UIViewLayoutItemMaker layoutGreatWithObject:object Offset:offset]
#define LessOffset(object, offset)            [UIViewLayoutItemMaker layoutLessWithObject:object Offset:offset]

#define EqualInsert(object, insert)           [UIViewLayoutItemMaker layoutInsertEqualWithObject:object Insert:insert]
#define GreatInsert(object, insert)           [UIViewLayoutItemMaker layoutInsertGreatWithObject:object Insert:insert]
#define LessInsert(object, insert)            [UIViewLayoutItemMaker layoutInsertLessWithObject:object Insert:insert]

#define EqualMutil(object, mutil)             [UIViewLayoutItemMaker layoutMutilEqualWithObject:object Mutil:mutil]
#define GreatMutil(object, mutil)             [UIViewLayoutItemMaker layoutMutilGreatWithObject:object Mutil:mutil]
#define LessMutil(object, mutil)              [UIViewLayoutItemMaker layoutMutilLessWithObject:object Mutil:mutil]

#define EqualSize(size)                       [UIViewLayoutItemMaker layoutSizeEqualWithSize:size]
#define GreatSize(size)                       [UIViewLayoutItemMaker layoutSizeGreatWithSize:size]
#define LessSize(size)                        [UIViewLayoutItemMaker layoutSizeLessWithSize:size]

#define EqualValue(value)                     [UIViewLayoutItemMaker layoutValueEqualWithValue:value]
#define GreatValue(value)                     [UIViewLayoutItemMaker layoutValueGreatWithValue:value]
#define LessValue(value)                      [UIViewLayoutItemMaker layoutValueLessWithValue:value]


@interface UIViewLayoutItemMaker : NSObject

+ (UIViewLayoutItem *)layoutEqualWithObject:(id)object;
+ (UIViewLayoutItem *)layoutGreatWithObject:(id)object;
+ (UIViewLayoutItem *)layoutLessWithObject:(id)object;

+ (UIViewLayoutItem *)layoutEqualWithObject:(id)object
                                     Offset:(CGFloat)offset;
+ (UIViewLayoutItem *)layoutGreatWithObject:(id)object
                                     Offset:(CGFloat)offset;
+ (UIViewLayoutItem *)layoutLessWithObject:(id)object
                                    Offset:(CGFloat)offset;



+ (UIViewLayoutItem *)layoutInsertEqualWithObject:(id)object
                                           Insert:(UIEdgeInsets)insert;
+ (UIViewLayoutItem *)layoutInsertGreatWithObject:(id)object
                                           Insert:(UIEdgeInsets)insert;
+ (UIViewLayoutItem *)layoutInsertLessWithObject:(id)object
                                          Insert:(UIEdgeInsets)insert;



+ (UIViewLayoutItem *)layoutMutilEqualWithObject:(id)object
                                           Mutil:(CGFloat)mutil;
+ (UIViewLayoutItem *)layoutMutilGreatWithObject:(id)object
                                           Mutil:(CGFloat)mutil;
+ (UIViewLayoutItem *)layoutMutilLessWithObject:(id)object
                                          Mutil:(CGFloat)mutil;



+ (UIViewLayoutItem *)layoutSizeEqualWithSize:(CGSize)size;
+ (UIViewLayoutItem *)layoutSizeGreatWithSize:(CGSize)size;
+ (UIViewLayoutItem *)layoutSizeLessWithSize:(CGSize)size;



+ (UIViewLayoutItem *)layoutValueEqualWithValue:(CGFloat)value;
+ (UIViewLayoutItem *)layoutValueGreatWithValue:(CGFloat)value;
+ (UIViewLayoutItem *)layoutValueLessWithValue:(CGFloat)value;

@end

