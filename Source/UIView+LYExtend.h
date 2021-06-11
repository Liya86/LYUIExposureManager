//
//  UIView+LYExtend.h
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LYExtend)

@property (nonatomic, strong, setter=ly_setViewController:) UIViewController *ly_viewController;
@property (nonatomic, assign, readonly) BOOL ly_displayedInScreen;

/// 是否显示在当前显示的控制器上
- (BOOL)ly_displayedInViewController;

@end
