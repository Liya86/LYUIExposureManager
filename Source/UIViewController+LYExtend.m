//
//  UIViewController+LYExtend.m
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import "UIViewController+LYExtend.h"
#import "NSObject+LYSwizzle.h"
#import <objc/runtime.h>
#import "LYUIExposureManager_.h"

@interface UIViewController()
@property (nonatomic, assign, setter=ly_setViewDidAppeared:) BOOL ly_viewDidAppeared;
@property (nonatomic, assign, setter=ly_setViewWillDisappeared:) BOOL ly_viewWillDisappeared;
@end
@implementation UIViewController (LYExtend)
+ (void)load {
    [self ly_swizzleMethod:@selector(viewWillDisappear:) withMethod:@selector(ly_viewWillDisappear:) error:nil];
    [self ly_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(ly_viewDidAppear:) error:nil];
    [self ly_swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(ly_viewWillAppear:) error:nil];
    [self ly_swizzleMethod:@selector(viewDidDisappear:) withMethod:@selector(ly_viewDidDisappear:) error:nil];
}

- (void)ly_viewWillAppear:(BOOL)animated {
    [self ly_viewWillAppear:animated];
    self.ly_viewWillDisappeared = NO;
}

- (void)ly_viewDidAppear:(BOOL)animated {
    [self ly_viewDidAppear:animated];
    self.ly_viewDidAppeared = YES;
    [[LYUIExposureManager sharedManager] listenExposureViewController:self];
}

- (void)ly_viewWillDisappear:(BOOL)animated {
    self.ly_viewWillDisappeared = YES;
    [self ly_viewWillDisappear:animated];
    [[LYUIExposureManager sharedManager] dismissExposureViewController:self];
}

- (void)ly_viewDidDisappear:(BOOL)animated {
    [self ly_viewDidDisappear:animated];
    self.ly_viewDidAppeared = NO;
}

- (BOOL)ly_viewWillDisappeared {
    return [objc_getAssociatedObject(self, @selector(ly_viewWillDisappeared)) boolValue];
}

- (void)ly_setViewWillDisappeared:(BOOL)ly_viewWillDisappeared {
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_viewWillDisappeared))];
    objc_setAssociatedObject(self, @selector(ly_viewWillDisappeared), @(ly_viewWillDisappeared), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_viewWillDisappeared))];
}

- (BOOL)ly_viewDidAppeared {
    return [objc_getAssociatedObject(self, @selector(ly_viewDidAppeared)) boolValue];
}

- (void)ly_setViewDidAppeared:(BOOL)ly_viewDidAppeared {
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_viewDidAppeared))];
    objc_setAssociatedObject(self, @selector(ly_viewDidAppeared), @(ly_viewDidAppeared), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_viewDidAppeared))];
}
@end
