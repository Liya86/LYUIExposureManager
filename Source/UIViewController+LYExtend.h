//
//  UIViewController+LYExtend.h
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LYExtend)
@property (nonatomic, assign, readonly) BOOL ly_viewDidAppeared;
@property (nonatomic, assign, readonly) BOOL ly_viewWillDisappeared;
@end
