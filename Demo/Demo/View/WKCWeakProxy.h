//
//  WKCWeakProxy.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/8.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>

// 应用场景
// NSTimer或者CADisplayLink 添加target self, 强引用;
// _timer = [NSTimer timerWithTimeInterval:0.1 target:[WKCWeakProxy proxyWithTarget:self] selector:@selector(tick:) userInfo:nil repeats:YES];

@interface WKCWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;

@end


