//
//  JLKFBaseViewController.h
//  BaseProject
//
//  Created by 一路走一路寻 on 17/6/27.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLKFBaseViewController : UIViewController

@property (nonatomic, strong) UIView *navigationBarView;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) UIView *line;

- (void)leftButtonClick:(UIButton *)sender;

- (void)rightButtonClick:(UIButton *)sender;

//- (void)languageChanged;  //语言设置

- (void)translationActionData;   //翻译语言

@end
