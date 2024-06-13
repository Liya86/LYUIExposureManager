//
//  UIView+LYExposure.h
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger kLYEffectiveExposureTime = 300; //默认的有效曝光时间300ms
static NSInteger kLYEffectiveExposureRatio = 0;  //默认的有效曝光比例

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

/// 设置为YES时，忽略进行曝光的操作，NO就正常曝光，默认NO
@property (nonatomic, assign, setter=ly_setIgnoreExposure:) BOOL ly_ignoreExposure;

/// 设置为YES时，忽略进行曝光的操作，NO就正常曝光，默认NO
/// 当superView的ly_ignoreExposure为YES时，ly_ignoreExposureFromSuperView就会跟随变为YES
@property (nonatomic, assign, setter=ly_setIgnoreExposureFromSuperView:, readonly) BOOL ly_ignoreExposureFromSuperView;

/// 父视图隐藏，那子视图也应该是隐藏状态
/// 当superView的ly_ignoreExposure为YES时，ly_ignoreExposureFromSuperView就会跟随变为YES
@property (nonatomic, assign, setter=ly_setHiddenFromSuperView:, readonly) BOOL ly_hiddenFromSuperView;

/// 有效曝光时长，只有曝光时长大于ly_EffectiveExposureTime才算有效曝光, 单位是毫秒
/// 默认是300毫秒（kLYEffectiveExposureTime）
@property (nonatomic, assign, setter=ly_setEffectiveExposureTime:) NSInteger ly_EffectiveExposureTime;

/// 有效曝光比例，只有曝光面积大于ly_EffectiveExposureRatio时才算曝光（0～100），小于0就等于0，只要有曝光即可，大于100就等于100，要全部曝光
/// 默认是0，即露出就算曝光（kLYEffectiveExposureRatio）
@property (nonatomic, assign, setter=ly_setEffectiveExposureRatio:) NSInteger ly_EffectiveExposureRatio;
 
@end
