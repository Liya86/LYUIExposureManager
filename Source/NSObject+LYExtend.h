//
//  NSObject+LYExtend.h
//  LYUIExposureManager
//
//  Created by Liya on 2018/3/14.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIViewController;

@interface NSObject (LYExtend)
- (UIViewController *)topViewController;
- (UIViewController *)topViewController:(UIViewController *)rootViewController;
@end
