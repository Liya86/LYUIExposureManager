//
//  LYUIExposureManager_.m
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import "LYUIExposureManager_.h"
#import "NSRunLoop+LYObserver.h"
#import "UIView+LYExposure.h"
#import "UIView+LYExtend.h"
#import "NSObject+LYExtend.h"
#import "UIViewController+LYExtend.h"

@interface LYUIExposureManager() {
    CFRunLoopObserverRef observer;
}
@property (nonatomic, strong) NSHashTable *listeningViews; //监听中
@property (nonatomic, strong) NSHashTable *listenableViews; //不符合监听条件，但是在监听列表中
@end

@implementation LYUIExposureManager
+ (instancetype)sharedManager {
    static id manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark -
- (instancetype)init {
    if (self = [super init]) {
        _listeningViews = [NSHashTable weakObjectsHashTable];
        _listenableViews = [NSHashTable weakObjectsHashTable];
        [self addApplicationObserver];
    }
    return self;
}

#pragma mark - observer run loop
- (void)addObserverForMainRunloop {
    if (observer || [UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
    __weak typeof(self) wSelf = self;
    observer = [[NSRunLoop mainRunLoop] ly_addObserverForCommonModesWith:kCFRunLoopBeforeWaiting observerBlock:^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        if (activity == kCFRunLoopBeforeWaiting) {//即将休眠，开始计算
            __strong typeof(wSelf) sSelf = wSelf;
            [sSelf pivate_runloop];
        }
    }];
}

- (void)removeObserverForMainRunloop {
    [[NSRunLoop mainRunLoop] ly_removeObserverForCommonModesWith:observer];
    if (observer) {
        CFRelease(observer);
        observer = nil;
    }
}

//退到后台就不进行监听了
- (void)addApplicationObserver {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (self.listeningViews.count) {
            [self addObserverForMainRunloop];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self removeObserverForMainRunloop];
    }];
}
#pragma mark - public
- (void)listenExposureView:(UIView *)view {
    if (view == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!view.ly_exposureBlock) {
            [self pivate_removeExposureView:view];
        } else {
            [self pivate_listenExposureView:view];
        }
    });
}

- (void)listenExposureViewController:(UIViewController *)VC {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *listenables = self.listenableViews.allObjects;
        for (UIView *view in listenables) {
            if (view.ly_viewController == VC) {
                [self.listenableViews removeObject:view];
                [self.listeningViews addObject:view];
            }
        }
        if (self.listeningViews.count) {
            [self addObserverForMainRunloop];
        }
    });
}

- (void)dismissExposureViewController:(UIViewController *)VC {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *listenings = self.listeningViews.allObjects;
        for (UIView *view in listenings) {
            if (view.ly_viewController == VC) {
                view.ly_firstExposureTime = 0;
                [self.listeningViews removeObject:view];
                [self.listenableViews addObject:view];
            }
        }
        if (self.listeningViews.count == 0) {
            [self removeObserverForMainRunloop];
        }
    });
}

#pragma mark - private

- (BOOL)pivate_exposureView:(UIView *)view {
    if (view.ly_ignoreExposure || view.ly_ignoreExposureFromSuperView || view.ly_hiddenFromSuperView || !view.ly_exposureBlock) {
        return NO;
    }
    
    if (!view || !view.superview || view.isHidden || view.layer.isHidden || view.alpha < 0.01) {
        return NO;
    }
    
    // 获取父视图控制器,判断父视图是否是当前显示的控制器
    if (![view ly_displayedInViewController]) {
        return NO;
    }
    return view.ly_displayedInScreen;
}

- (void)pivate_listenExposureView:(UIView *)view_ {
//    到下一个runloop才加入曝光处理
    if (view_ == nil) {
        return;
    }
    UIView *listenView = view_;
    if ([self.listeningViews containsObject:listenView]) {
        if (!listenView.window || !listenView.ly_viewController.ly_viewDidAppeared) {
            [self.listeningViews removeObject:listenView];
        }
    }
    if ([self.listenableViews containsObject:listenView]) {
        if (listenView.window && listenView.ly_viewController.ly_viewDidAppeared) {
            [self.listenableViews removeObject:listenView];
        }
    }
    //      是否真的加入视图显示了
    if (listenView.window && listenView.ly_viewController.ly_viewDidAppeared) {
        [self.listeningViews addObject:listenView];
        if (self.listeningViews.count) {
            [self addObserverForMainRunloop];
        }
    } else { //将来被监听的视图
        listenView.ly_firstExposureTime = 0;
        [self.listenableViews addObject:listenView];
    }
}

- (void)pivate_removeExposureView:(UIView *)view_ {
    if (view_ == nil) {
        return;
    }
    view_.ly_firstExposureTime = 0;
    [self.listeningViews removeObject:view_];
    [self.listenableViews removeObject:view_];
    if (self.listeningViews.count == 0) {
        [self removeObserverForMainRunloop];
    }
}

#pragma mark - runloop
- (void)pivate_runloop {
    NSArray *listenings = self.listeningViews.allObjects;
    for (UIView *view in listenings) {
        if ([self pivate_exposureView:view]) {
            if (view.ly_EffectiveExposureTime > 0) {
                if (view.ly_firstExposureTime < 1) {
                    view.ly_firstExposureTime = [[NSDate date] timeIntervalSince1970];
                    return;
                }
                NSInteger exposuerTime = ([[NSDate date] timeIntervalSince1970] * 1000 - view.ly_firstExposureTime * 1000);
                if (exposuerTime < view.ly_EffectiveExposureTime) {
                    return;
                }
            }
            if (view.ly_exposureBlock) {
                view.ly_exposureBlock(view);
            }
            view.ly_exposureBlock = nil;
            [self pivate_removeExposureView:view];
        } else {
            view.ly_firstExposureTime = 0;
        }
    }
}
@end
