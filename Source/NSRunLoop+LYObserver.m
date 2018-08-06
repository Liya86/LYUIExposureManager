//
//  NSRunLoop+LYObserver.m
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import "NSRunLoop+LYObserver.h"

@implementation NSRunLoop (LYObserver)
- (CFRunLoopObserverRef)ly_addObserverWith:(CFOptionFlags)activities repeats:(BOOL)repeats mode:(CFRunLoopMode)mode observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock {
    // 1. 创建监听者
    /**
     *  创建监听者
     *  allocator    分配存储空间
     *  activities   要监听的状态
     *  repeats      是否持续监听
     *  order        优先级, 默认为0
     *  observer     观察者
     *  activity     监听回调的当前状态
     */
    
    /**
     activity
     
     kCFRunLoopEntry = (1UL << 0),          进入工作
     kCFRunLoopBeforeTimers = (1UL << 1),   即将处理Timers事件
     kCFRunLoopBeforeSources = (1UL << 2),  即将处理Source事件
     kCFRunLoopBeforeWaiting = (1UL << 5),  即将休眠
     kCFRunLoopAfterWaiting = (1UL << 6),   被唤醒
     kCFRunLoopExit = (1UL << 7),           退出RunLoop
     kCFRunLoopAllActivities = 0x0FFFFFFFU  监听所有事件
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, activities, repeats, 0, observerBlock);
    
    // 2. 添加监听者
    /**
     *  给指定的RunLoop添加监听者
     *
     *  @param rl#>       要添加监听者的RunLoop
     *  @param observer#> 监听者对象
     *  @param mode#>     RunLoop的运行模式, 填写默认模式即可
     */
    CFRunLoopAddObserver(self.getCFRunLoop, observer, mode);
    return observer;
}

//只监听一次
- (CFRunLoopObserverRef)ly_addObserverForOnceWith:(CFOptionFlags)activities mode:(CFRunLoopMode)mode observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock {
    return [self ly_addObserverWith:activities repeats:NO mode:mode observerBlock:observerBlock];
}

- (CFRunLoopObserverRef)ly_addObserverWith:(CFOptionFlags)activities mode:(CFRunLoopMode)mode observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock {
    return [self ly_addObserverWith:activities repeats:YES mode:mode observerBlock:observerBlock];
}

- (CFRunLoopObserverRef)ly_addObserverWith:(CFOptionFlags)activities observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock {
    return [self ly_addObserverWith:activities repeats:YES mode:kCFRunLoopDefaultMode observerBlock:observerBlock];
}

- (CFRunLoopObserverRef)ly_addObserverForCommonModesWith:(CFOptionFlags)activities observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock {
    return [self ly_addObserverWith:activities repeats:YES mode:kCFRunLoopCommonModes observerBlock:observerBlock];
}

- (CFRunLoopObserverRef)ly_addObserverWith:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock {
    return [self ly_addObserverWith:kCFRunLoopAllActivities repeats:YES mode:kCFRunLoopDefaultMode observerBlock:observerBlock];
}

- (CFRunLoopObserverRef)ly_addObserverForCommonModesWith:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock {
    return [self ly_addObserverWith:kCFRunLoopAllActivities repeats:YES mode:kCFRunLoopCommonModes observerBlock:observerBlock];
}

- (void)ly_removeObserverWith:(CFRunLoopObserverRef)observer mode:(CFRunLoopMode)mode {
    if (observer) {
        CFRunLoopRemoveObserver(self.getCFRunLoop, observer, mode);
    }
}

- (void)ly_removeObserverForCommonModesWith:(CFRunLoopObserverRef)observer  {
    [self ly_removeObserverWith:observer mode:kCFRunLoopCommonModes];
}
@end
