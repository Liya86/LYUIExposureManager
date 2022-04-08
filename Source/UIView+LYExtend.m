//
//  UIView+LYExtend.m
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import "UIView+LYExtend.h"
#import <objc/runtime.h>
#import "UIView+LYExposure.h"
#import "NSObject+LYExtend.h"

@interface LYWeakObject : NSObject
@property (nonatomic, weak) id obj;

+ (id)ly_weakObject:(id)obj;
@end

@implementation UIView (LYExtend)
- (UIViewController *)ly_viewController {
    // 响应链里的第一个uiviewcontroller
    LYWeakObject *weakObj = objc_getAssociatedObject(self, @"ly_viewController");
    UIViewController *vc = weakObj.obj;
    if (vc == nil) {
        UIResponder *responder = self;
        while ((responder = [responder nextResponder])) {
            if ([responder isKindOfClass: [UIViewController class]]) {
                vc = (UIViewController *)responder;
                [self ly_setViewController:vc];
                break;
            }
        }
    }
    // 若没有，则返回nil
    return vc;
}

- (void)ly_setViewController:(UIViewController *)ly_viewController {
    LYWeakObject *weakObj = [LYWeakObject ly_weakObject:ly_viewController];
    objc_setAssociatedObject(self, @"ly_viewController", weakObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)ly_firstExposureTime {
    NSNumber *firstExposureTime = objc_getAssociatedObject(self, @"ly_firstExposureTime");
    return [firstExposureTime doubleValue];
}

- (void)ly_setFirstExposureTime:(NSTimeInterval)ly_firstExposureTime {
    objc_setAssociatedObject(self, @"ly_firstExposureTime", @(ly_firstExposureTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ly_displayedInScreen {
    UIWindow *window = self.window;
    if (!window || self.isHidden || self.alpha < 0.01) {
        return NO;
    }
    CGRect frame = self.frame;
    frame.origin.x -= self.ly_ECompensationSize.width;
    frame.origin.y -= self.ly_ECompensationSize.height;
    frame.size.width += self.ly_ECompensationSize.width * 2;
    frame.size.height += self.ly_ECompensationSize.height * 2;
    CGRect rectInWindow = CGRectIntegral([self.superview convertRect:frame toView:window]);
    if (CGRectIsEmpty(rectInWindow) || CGRectIsNull(rectInWindow) || CGSizeEqualToSize(rectInWindow.size, CGSizeZero)) {
        return NO;
    }
    
    CGRect windowBox = CGRectIntegral(window.frame);
    CGRect intersectionRect = CGRectIntersection(rectInWindow, windowBox);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect) || CGSizeEqualToSize(intersectionRect.size, CGSizeZero)) {
        return NO;
    }
    
    CGFloat intersectionArea = intersectionRect.size.width * intersectionRect.size.height;
    CGFloat frameArea = frame.size.width * frame.size.height;
    if (self.ly_EffectiveExposureRatio > 0 && frameArea > 0) {
        NSInteger intersectionRatio = intersectionArea * 100 / frameArea;
        return intersectionRatio > self.ly_EffectiveExposureRatio;
    }
    
    return YES;
}

- (BOOL)ly_displayedInViewController {
    UIViewController *vc = self.ly_viewController;
    UIViewController *topVC = [self ly_topViewController];
    BOOL isSameOrChild = NO;
    while (vc) {
        if (vc == topVC) {
            isSameOrChild = YES;
            break;
        }
        
        if (!vc.parentViewController) {
            break;
        }
        
        // 判断是否在父控制器下
        vc = vc.parentViewController;
    }
    
    while (topVC) {
        if (vc == topVC) {
            isSameOrChild = YES;
            break;
        }
        
        if (!topVC.parentViewController) {
            break;
        }
        
        // 判断是否在父控制器下
        topVC = topVC.parentViewController;
    }
    
    return isSameOrChild;
}

@end

@implementation LYWeakObject
+ (id)ly_weakObject:(id)obj {
    LYWeakObject *wObj = [[LYWeakObject alloc] init];
    wObj.obj = obj;
    return wObj;
}
@end
