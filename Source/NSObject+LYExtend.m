//
//  NSObject+LYExtend.m
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import "NSObject+LYExtend.h"
#import <UIKit/UIKit.h>
@implementation NSObject (LYExtend)

- (UIViewController *)ly_topViewController {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return [self ly_topViewController:window.rootViewController];
}

- (UIViewController *)ly_topViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self ly_topViewController:navigationController.topViewController];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self ly_topViewController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self ly_topViewController:rootViewController.presentedViewController];
    }
    return rootViewController;
}

@end
