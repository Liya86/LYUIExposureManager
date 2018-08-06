//
//  UIView+LYExtend.m
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import "UIView+LYExtend.h"
#import <objc/runtime.h>

@implementation UIView (LYExtend)
- (UIViewController *)ly_viewController {
    // 响应链里的第一个uiviewcontroller
    UIViewController *vc = objc_getAssociatedObject(self, @"ly_viewController");
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
    objc_setAssociatedObject(self, @"ly_viewController", ly_viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ly_displayedInScreen {
    UIWindow *window = self.window;
    if (!window || self.isHidden || self.alpha < 0.01) {
        return NO;
    }
    
    CGRect rectInWindow = CGRectIntegral([self.superview convertRect:self.frame toView:window]);
    if (CGRectIsEmpty(rectInWindow) || CGRectIsNull(rectInWindow) || CGSizeEqualToSize(rectInWindow.size, CGSizeZero)) {
        return NO;
    }
    
    CGRect windowBox = CGRectIntegral(window.frame);
    CGRect intersectionRect = CGRectIntersection(rectInWindow, windowBox);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect) || CGSizeEqualToSize(intersectionRect.size, CGSizeZero)) {
        return NO;
    }
    return YES;
}

@end
