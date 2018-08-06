//
//  ViewController.m
//  LYUIExposureManager
//
//  Created by Liya on 2018/8/4.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LYExposure.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    view0.tag = 1;
    view0.backgroundColor = [UIColor yellowColor];
    view0.ly_exposureBlock = ^(UIView *view) {
        NSLog(@"exposureBlock %ld", (long)view.tag);
    };
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    view1.tag = 2;
    view1.backgroundColor = [UIColor yellowColor];
    view1.ly_exposureBlock = ^(UIView *view) {
        NSLog(@"exposureBlock %ld", (long)view.tag);
    };
    [self.view addSubview:view0];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(-40, -50, 30, 30)];
    view2.tag = 3;
    view2.backgroundColor = [UIColor yellowColor];
    view2.ly_exposureBlock = ^(UIView *view) {
        NSLog(@"exposureBlock %ld", (long)view.tag);
    };
    [self.view addSubview:view2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:view1];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view2.frame = CGRectMake(40, 40, 30, 30);
        view1.ly_exposureBlock = ^(UIView *view) {
            NSLog(@"重新设置可以再次曝光 exposureBlock %ld", (long)view.tag);
        };
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
