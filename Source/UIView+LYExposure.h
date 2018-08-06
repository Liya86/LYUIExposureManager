//
//  UIView+LYExposure.h
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LYExposure)

/**
     UIView 曝光时的操作（可用于统计）
 */
@property (nonatomic, copy, setter=ly_setExposuerBlock:) void(^ly_exposureBlock)(UIView *);

@end
