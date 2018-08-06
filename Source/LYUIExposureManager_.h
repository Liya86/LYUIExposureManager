//
//  LYUIExposureManager_.h
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView, UIViewController;

@interface LYUIExposureManager : NSObject
@property (nonatomic, strong, class, readonly) LYUIExposureManager *sharedManager;

//加入监听队列--但是未必就开始监听，只有对应控制器/uiwindow也处于展示状态才会监听
- (void)listenExposureView:(UIView *)view;
- (void)listenExposureViewController:(UIViewController *)VC;
- (void)dismissExposureViewController:(UIViewController *)VC;
@end
