//
//  HUD.m
//  Demo
//
//  Created by wkcloveYang on 2019/8/27.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "HUD.h"
#import <JGProgressHUD.h>
#import <UIKit/UIKit.h>

@implementation HUD

+ (void)showIndicatorWithTitle:(NSString *)title
{
    [self showIndicatorWithTitle:title
                        duration:2.0];
}

+ (void)showIndicatorWithTitle:(NSString *)title
                      duration:(NSTimeInterval)duration
{
    JGProgressHUD * hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    hud.textLabel.text = title;
    UIWindow * window = UIApplication.sharedApplication.windows.firstObject;
    [hud showInView:window animated:YES];
    [hud dismissAfterDelay:duration animated:YES];
}

@end
