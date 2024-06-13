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
    [self ly_swizzleMethod:@selector(willMoveToSuperview:) withMethod:@selector(ly_willMoveToSuperview:) error:nil];
    [self ly_swizzleMethod:@selector(setHidden:) withMethod:@selector(ly_setHidden:) error:nil];
}

- (void)ly_willMoveToWindow:(UIWindow *)newWindow {
    [self ly_willMoveToWindow:newWindow];
    //加入或者移除监听
    if (self.ly_exposureBlock) {
        [[LYUIExposureManager sharedManager] listenExposureView:self];
    }

    self.ly_viewController = nil;

}

- (void)ly_willMoveToSuperview:(nullable UIView *)newSuperview {
    [self ly_willMoveToSuperview:newSuperview];
    
    self.ly_ignoreExposureFromSuperView = newSuperview.ly_ignoreExposure || newSuperview.ly_ignoreExposureFromSuperView;
    [self ly_followIgnoreExposureFromSuperView];
    
    self.ly_hiddenFromSuperView = newSuperview.isHidden || newSuperview.ly_hiddenFromSuperView;
    [self ly_followHiddenFromSuperView];
}

- (void)ly_setHidden:(BOOL)hidden {
    [self ly_setHidden:hidden];
    [self ly_followHiddenFromSuperView];
}

- (void)ly_setExposuerBlock:(void (^)(UIView *))ly_exposureBlock {
    self.ly_firstExposureTime = 0;
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_exposureBlock))];
    objc_setAssociatedObject(self, @selector(ly_exposureBlock), ly_exposureBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_exposureBlock))];
    //加入或者移除监听
    [[LYUIExposureManager sharedManager] listenExposureView:self];
}

- (void (^)(UIView *))ly_exposureBlock {
    return objc_getAssociatedObject(self, @selector(ly_exposureBlock));
}

- (void)ly_setECompensationSize:(CGSize)ly_ECompensationSize {
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_ECompensationSize))];
    if (CGSizeEqualToSize(ly_ECompensationSize, CGSizeZero)) {
        objc_setAssociatedObject(self, @selector(ly_ECompensationSize), nil, OBJC_ASSOCIATION_RETAIN);
    } else {
        objc_setAssociatedObject(self, @selector(ly_ECompensationSize), [NSValue valueWithCGSize:ly_ECompensationSize], OBJC_ASSOCIATION_COPY);
    }
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_ECompensationSize))];
}

- (CGSize)ly_ECompensationSize {
    NSValue *ECompensationSizeValue = objc_getAssociatedObject(self, @selector(ly_ECompensationSize));
    if (ECompensationSizeValue) {
        return ECompensationSizeValue.CGSizeValue;
    }
    return CGSizeZero;
}

- (BOOL)ly_ignoreExposure {
    NSNumber *ignoreExposureNum = objc_getAssociatedObject(self, @selector(ly_ignoreExposure));
    return ignoreExposureNum.boolValue;
}

- (void)ly_setIgnoreExposure:(BOOL)ly_ignoreExposure {
    if (self.ly_ignoreExposure == ly_ignoreExposure) {
        return;
    }
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_ignoreExposure))];
    if (!ly_ignoreExposure) {
        objc_setAssociatedObject(self, @selector(ly_ignoreExposure), nil, OBJC_ASSOCIATION_RETAIN);
    } else {
        objc_setAssociatedObject(self, @selector(ly_ignoreExposure), @(ly_ignoreExposure), OBJC_ASSOCIATION_RETAIN);
    }
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_ignoreExposure))];
    [self ly_followIgnoreExposureFromSuperView];
}

- (BOOL)ly_ignoreExposureFromSuperView {
    NSNumber *ignoreExposureFromSuperViewNum = objc_getAssociatedObject(self, @selector(ly_ignoreExposureFromSuperView));
    return ignoreExposureFromSuperViewNum.boolValue;
}

- (void)ly_setIgnoreExposureFromSuperView:(BOOL)ly_ignoreExposureFromSuperView {
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_ignoreExposureFromSuperView))];
    if (!ly_ignoreExposureFromSuperView) {
        objc_setAssociatedObject(self, @selector(ly_ignoreExposureFromSuperView), nil, OBJC_ASSOCIATION_RETAIN);
    } else {
        objc_setAssociatedObject(self, @selector(ly_ignoreExposureFromSuperView), @(ly_ignoreExposureFromSuperView), OBJC_ASSOCIATION_RETAIN);
    }
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_ignoreExposureFromSuperView))];
}

- (void)ly_followIgnoreExposureFromSuperView {
    NSArray *subViews = self.subviews;
    BOOL subView_ignoreExposureFromSuperView = self.ly_ignoreExposure || self.ly_ignoreExposureFromSuperView;
    for (UIView *subView in subViews) {
        subView.ly_ignoreExposureFromSuperView = subView_ignoreExposureFromSuperView;
        if (!subView.ly_ignoreExposure) {
            [subView ly_followIgnoreExposureFromSuperView];
        }
    }
}

- (BOOL)ly_hiddenFromSuperView {
    NSNumber *hiddenFromSuperViewNum = objc_getAssociatedObject(self, @selector(ly_hiddenFromSuperView));
    return hiddenFromSuperViewNum.boolValue;
}

- (void)ly_setHiddenFromSuperView:(BOOL)ly_hiddenFromSuperView {
    NSString *key = NSStringFromSelector(@selector(ly_hiddenFromSuperView));
    [self willChangeValueForKey:key];
    if (!ly_hiddenFromSuperView) {
        objc_setAssociatedObject(self, @selector(ly_hiddenFromSuperView), nil, OBJC_ASSOCIATION_RETAIN);
    } else {
        objc_setAssociatedObject(self, @selector(ly_hiddenFromSuperView), @(ly_hiddenFromSuperView), OBJC_ASSOCIATION_RETAIN);
    }
    [self didChangeValueForKey:key];
}

- (void)ly_followHiddenFromSuperView {
    NSArray *subViews = self.subviews;
    BOOL subView_hiddenFromSuperView = self.isHidden || self.ly_hiddenFromSuperView;
    for (UIView *subView in subViews) {
        subView.ly_hiddenFromSuperView = subView_hiddenFromSuperView;
        if (!subView.isHidden) {
            [subView ly_followHiddenFromSuperView];
        }
    }
}

- (void)ly_setEffectiveExposureTime:(NSInteger)ly_EffectiveExposureTime {
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_EffectiveExposureTime))];
    objc_setAssociatedObject(self, @selector(ly_EffectiveExposureTime), @(ly_EffectiveExposureTime), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_EffectiveExposureTime))];
}

- (NSInteger)ly_EffectiveExposureTime {
    NSNumber *effectiveExposureTime = objc_getAssociatedObject(self, @selector(ly_EffectiveExposureTime));
    if (effectiveExposureTime == nil) {
        return kLYEffectiveExposureTime;
    }
    return effectiveExposureTime.integerValue;
}

- (void)ly_setEffectiveExposureRatio:(NSInteger)ly_EffectiveExposureRatio {
    NSInteger effectiveExposureRatio = ly_EffectiveExposureRatio;
    if (ly_EffectiveExposureRatio < 0) {
        effectiveExposureRatio = 0;
    } else if (ly_EffectiveExposureRatio > 100) {
        effectiveExposureRatio = 100;
    }
    if (effectiveExposureRatio == self.ly_EffectiveExposureRatio) {
        return;
    }
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_EffectiveExposureRatio))];
    if (effectiveExposureRatio == 0) {
        objc_setAssociatedObject(self, @selector(ly_EffectiveExposureRatio), nil, OBJC_ASSOCIATION_RETAIN);
    } else {
        objc_setAssociatedObject(self, @selector(ly_EffectiveExposureRatio), @(effectiveExposureRatio), OBJC_ASSOCIATION_RETAIN);
    }
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_EffectiveExposureRatio))];
}

- (NSInteger)ly_EffectiveExposureRatio {
    NSNumber *effectiveExposureRatioNum = objc_getAssociatedObject(self, @selector(ly_EffectiveExposureRatio));
    if (effectiveExposureRatioNum == nil) {
        return kLYEffectiveExposureRatio;
    }
    return effectiveExposureRatioNum.integerValue;
}
@end
