//
//  NSRunLoop+LYObserver.h
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRunLoop (LYObserver)

- (CFRunLoopObserverRef)ly_addObserverWith:(CFOptionFlags)activities repeats:(BOOL)repeats mode:(CFRunLoopMode)mode observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)ly_addObserverForOnceWith:(CFOptionFlags)activities mode:(CFRunLoopMode)mode observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)ly_addObserverWith:(CFOptionFlags)activities mode:(CFRunLoopMode)mode observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)ly_addObserverWith:(CFOptionFlags)activities observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)ly_addObserverForCommonModesWith:(CFOptionFlags)activities observerBlock:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)ly_addObserverWith:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;
- (CFRunLoopObserverRef)ly_addObserverForCommonModesWith:(void (^) (CFRunLoopObserverRef observer, CFRunLoopActivity activity))observerBlock;

- (void)ly_removeObserverWith:(CFRunLoopObserverRef)observer mode:(CFRunLoopMode)mode;
- (void)ly_removeObserverForCommonModesWith:(CFRunLoopObserverRef)observer;
@end
