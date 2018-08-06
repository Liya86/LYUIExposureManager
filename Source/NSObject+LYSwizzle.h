//
//  NSObject+LYSwizzle.h
//  LYSingnalTest
//
//  Created by LY on 2017/11/15.
//  Copyright © 2017年 IMY. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LYSwizzle)
+ (BOOL)ly_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_;
+ (BOOL)ly_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError **)error_;
@end

@interface NSProxy (LYSwizzle)

+ (BOOL)ly_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_;
+ (BOOL)ly_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError **)error_;

@end
NS_ASSUME_NONNULL_END
