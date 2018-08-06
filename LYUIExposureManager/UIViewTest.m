//
//  UIViewTest.m
//  LYUIExposureManager
//
//  Created by Liya on 2018/8/4.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import "UIViewTest.h"

@implementation UIViewTest
- (void)willMoveToSuperview:(nullable UIView *)newSuperview {
    NSLog(@"%@ %@ %@", self.class, @"willMoveToSuperview:", newSuperview);
}
- (void)didMoveToSuperview {
    NSLog(@"%@ %@", self.class, @"didMoveToSuperview");
}
- (void)willMoveToWindow:(nullable UIWindow *)newWindow {
    NSLog(@"%@ %@ %@", self.class, @"willMoveToWindow:", newWindow);
}
- (void)didMoveToWindow {
    NSLog(@"%@ %@", self.class, @"didMoveToWindow");
}
@end
