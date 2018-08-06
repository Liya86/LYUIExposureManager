//
//  UIView+LYExposure.m
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import "UIView+LYExposure.h"
#import <objc/runtime.h>
#import "LYUIExposureManager_.h"
#import "NSObject+LYSwizzle.h"
#import "UIView+LYExtend.h"
#import "UIView+LYExposure.h"

@implementation UIView (LYExposure)

+ (void)load {
    [self ly_swizzleMethod:@selector(willMoveToWindow:) withMethod:@selector(ly_willMoveToWindow:) error:nil];
}

- (void)ly_willMoveToWindow:(UIWindow *)newWindow {
    [self ly_willMoveToWindow:newWindow];
    //加入或者移除监听
    if (self.ly_exposureBlock) {
        [[LYUIExposureManager sharedManager] listenExposureView:self];
    }
    if (!newWindow) {
        self.ly_viewController = nil;
    }
}

- (void)ly_setExposuerBlock:(void (^)(UIView *))ly_exposureBlock {
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_exposureBlock))];
    objc_setAssociatedObject(self, @selector(ly_exposureBlock), ly_exposureBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_exposureBlock))];
    //加入或者移除监听
    [[LYUIExposureManager sharedManager] listenExposureView:self];
}

- (void (^)(UIView *))ly_exposureBlock {
    return objc_getAssociatedObject(self, @selector(ly_exposureBlock));
}

@end
