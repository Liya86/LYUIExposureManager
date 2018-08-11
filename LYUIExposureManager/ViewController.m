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
        NSLog(@"exposure %ld", (long)view.tag);
    };

    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    view1.tag = 2;
    view1.backgroundColor = [UIColor yellowColor];
    view1.ly_exposureBlock = ^(UIView *view) {
        NSLog(@"exposure %ld", (long)view.tag);
    };
    [self.view addSubview:view0];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(-40, -50, 30, 30)];
    view2.tag = 3;
    view2.backgroundColor = [UIColor yellowColor];
    view2.ly_exposureBlock = ^(UIView *view) {
        NSLog(@"exposure %ld", (long)view.tag);
    };
    [self.view addSubview:view2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:view1];
        //view2 增加补偿曝光后才曝光
        view2.ly_ECompensationSize = CGSizeMake(15, 25);
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view1.ly_exposureBlock = ^(UIView *view) {
            NSLog(@"曝光后重新设置后的会重新曝光 exposure %ld", (long)view.tag);
        };
    });
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view insertSubview:scrollView atIndex:0];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 2);
    scrollView.contentInset = UIEdgeInsetsMake(60, 0, 50, 0);
    
    UIView *s_view0 = [[UIView alloc] initWithFrame:CGRectMake(60, -80, 50, 50)];
    s_view0.backgroundColor = [UIColor redColor];
    s_view0.tag = 1;
    [scrollView addSubview:s_view0];
    s_view0.ly_exposureBlock = ^(UIView *s_view) {
        NSLog(@"s_view0 exposure %ld", (long)s_view.tag);
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
