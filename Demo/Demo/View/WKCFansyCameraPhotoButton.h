//
//  WKCFansyCameraPhotoButton.h
//  Demo
//
//  Created by wkcloveYang on 2019/8/27.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCFansyCameraPhotoButton : UIView

@property (nonatomic, copy) void(^takePhotoBlock)(void);
@property (nonatomic, copy) void(^startRecordBlock)(void);
@property (nonatomic, copy) void(^endRecordBlock)(void);

@end

