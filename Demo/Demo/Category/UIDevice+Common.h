//
//  UIDevice+Common.h
//  abab
//
//  Created by 魏昆超 on 2019/2/18.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -通用部分
@interface UIDevice (Common)

@property (class, nonatomic, copy, readonly) NSString * appVersion;
@property (class, nonatomic, copy, readonly) NSString * appName;
@property (class, nonatomic, copy, readonly) NSString * appBuild;

@property (class, nonatomic, copy, readonly) NSString * genarateUuidString;
@property (class, nonatomic, copy, readonly) NSString * idfaString;
@property (class, nonatomic, copy, readonly) NSString * deviceUUID;
@property (class, nonatomic, copy, readonly) NSString * anonymousUserId;
@property (class, nonatomic, copy, readonly) NSString * deviceId;

@end







#pragma mark -UI
@interface UIDevice (UI)

@property (class, nonatomic, assign, readonly) BOOL is5OrSE;
@property (class, nonatomic, assign, readonly) BOOL is6;
@property (class, nonatomic, assign, readonly) BOOL is6P;
@property (class, nonatomic, assign, readonly) BOOL isPad;
@property (class, nonatomic, assign, readonly) BOOL isX;

@property (class, nonatomic, assign, readonly) CGFloat XTopSpace;
@property (class, nonatomic, assign, readonly) CGFloat XBottomSpace;
@property (class, nonatomic, assign, readonly) CGFloat statusBarHeight;
@property (class, nonatomic, assign, readonly) CGFloat tabBarHeight;
@property (class, nonatomic, assign, readonly) CGFloat navigationBarHeight;
@property (class, nonatomic, assign, readonly) CGFloat navigationHeight;

@end


