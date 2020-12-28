//
//  JLKFBaseViewController.m
//  BaseProject
//
//  Created by 一路走一路寻 on 17/6/27.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "JLKFBaseViewController.h"

@interface JLKFBaseViewController ()

@end

@implementation JLKFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    [self initNavigationBar];

//    if (KISIphoneX) {
//        self.view.backgroundColor = [UIColor whiteColor];
//    }else{
    self.view.backgroundColor = MainBackgroundColor;
//    }

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
  
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.navigationController.navigationBar.hidden = YES;
}

- (void)initNavigationBar {

    self.view.backgroundColor = MainBackgroundColor;

    self.navigationBarView = [[UIView alloc] init];

//    self.navigationBarView.backgroundColor = KNavBar_Color;
    
    self.navigationBarView.backgroundColor = KNavColor;
    [self.view addSubview:self.navigationBarView];
    [self.navigationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        if (KISIphoneX) {
            make.height.offset(64 + IPHONEX_TOP_HEIGHT);
        }else{
        make.height.offset(64);
        }
    }];
    
    //标题
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.textColor = [UIColor whiteColor];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.font = [UIFont boldSystemFontOfSize:19];
    [self.navigationBarView addSubview:self.titleLable];
    if (KISIphoneX) {
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.offset(20 + 12 + IPHONEX_TOP_HEIGHT);
            make.width.offset(250);
            make.height.offset(20);
            make.centerX.offset(0);
        }];
    }else{
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.offset(20 + 12);
        make.width.offset(250);
        make.height.offset(20);
        make.centerX.offset(0);
    }];
    }

    //返回按钮
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (KISIphoneX) {
        [self.leftButton setEnlargeEdgeWithTop:30 right:35 bottom:10 left:15];
    }else{
    [self.leftButton setEnlargeEdgeWithTop:20 right:20 bottom:10 left:15];
    }
    [self.navigationBarView addSubview:self.leftButton];

    if (KISIphoneX) {

        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.offset(15);
            make.width.offset(11);
            make.height.offset(18);
            make.top.offset(20 + 13 + IPHONEX_TOP_HEIGHT);
        }];

    }else{

    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.offset(15);
        make.width.offset(11);
        make.height.offset(18);
        make.top.offset(20 + 13);
    }];
    }

    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.backgroundColor = [UIColor clearColor];
//    [self.rightButton setTitleColor:KHEXCOLOR(@"202532", 1) forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = KSystemFont(16);
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (KISIphoneX) {
        [self.rightButton setEnlargeEdgeWithTop:30 right:15 bottom:10 left:25];
    }else{
    [self.rightButton setEnlargeEdgeWithTop:10 right:15 bottom:10 left:15];
    }
    [self.navigationBarView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.offset(-15);
        make.centerY.equalTo(self.titleLable.mas_centerY).offset(0);
    }];
    
    self.line = [[UIView alloc]init];
    if (KISIphoneX) {
        self.line.frame = CGRectMake(0, 63.5 + IPHONEX_TOP_HEIGHT, kScreenWidth, 0.5);
    }else{
        self.line.frame = CGRectMake(0, 63.5, kScreenWidth, 0.5);
    }
//    self.line.backgroundColor = KRGBACOLOR(194, 194, 194, 1);
    self.line.backgroundColor = [UIColor whiteColor];
    self.line.hidden = YES;
//    [self.navigationBarView addSubview:self.line];
    
//    UIButton *mineButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    mineButton.frame = CGRectMake(0, 30, 70, 25);
////    [mineButton setTitle:@"返回" forState:UIControlStateNormal];
//    [mineButton setTitleColor:TextBlueColor forState:UIControlStateNormal];
//    [mineButton setImage:KImageName(@"back") forState:UIControlStateNormal];
//    [mineButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    mineButton.titleLabel.font = KSystemFont(14);
////    [mineButton setIconInLeftWithSpacing:2];
//    self.leftButton = mineButton;
//    [self.navigationBarView addSubview:mineButton];
}

- (void)leftButtonClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick:(UIButton *)sender{

}

//-(void)viewSafeAreaInsetsDidChange{
//    [super viewSafeAreaInsetsDidChange];
//    if (@available(iOS 11.0, *)) {
//        self.additionalSafeAreaInsets = UIEdgeInsetsMake(10, 0, 0, 34);
//    }
//}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //return UIStatusBarStyleLightContent;
    return UIStatusBarStyleDefault;
}

@end
