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

/**
    UIView 曝光补偿（原来的曝光区域+这里的补偿，CGRectMake(x-.width, y-.heigh, w+2*.widht, h+2*.heigh)）
    时机：最好在设置曝光操作（ly_setExposuerBlock:）前设置 -- 默认时CGSizeZero
 */
@property (nonatomic, assign, setter=ly_setECompensationSize:) CGSize ly_ECompensationSize;

@end
