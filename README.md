# LYUIExposureManager
监听普通UIView曝光的封装

* `iOS8.0` `Objective_C`
* 引入： pod 'LYUIExposureManager'
* 使用：  

  ```
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    view.ly_exposureBlock = ^(UIView *view) {
        NSLog(@"曝光了，做点啥");
    };
    [self.view addSubview:view];
    
    ....
    
    view.ly_exposureBlock = ^(UIView *view) {
        NSLog(@"曝光后重新设置曝光操作，会再次曝光，那又做点啥");
    };
    
  ```
  
  

* 主要是为了曝光某些view时，统计某些事件，后觉得每次都需要繁琐的额外代码，太麻烦，所以整理了曝光的一些封装  
  思路是监听 mainRunLoop，收到即将进入休眠的通知时进行 view 的曝光计算  
* 完善   
   * `UITableView` `UICollectionView` 的相关曝光  
   * `PageViewContrller` 预加载页面的曝光处理
   * 延迟曝光