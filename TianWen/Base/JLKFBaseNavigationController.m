//
//  JLKFBaseNavigationController.m
//  BaseProject
//
//  Created by 一路走一路寻 on 17/6/27.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "JLKFBaseNavigationController.h"

@interface JLKFBaseNavigationController ()

@end

@implementation JLKFBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    //    self.navigationBar.barTintColor = RGBACOLOR(0x4d, 0x4d, 0x4d, 1.0);
    //    [self.navigationBar setBarTintColor:KNavColor];
    [self.navigationBar setBarTintColor:KNavColor];
    self.navigationBar.translucent = YES;
    self.navigationBar.tintColor = KNavColor;
    [self.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count == 0){
        return [super pushViewController:viewController animated:animated];
    }else if (self.viewControllers.count>=1) {
        viewController.hidesBottomBarWhenPushed = YES;//隐藏二级页面的tabbar
    }
    [super pushViewController:viewController animated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
