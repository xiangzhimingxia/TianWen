//
//  BGTabBar.m
//  BoardGame
//
//  Created by 张享 on 16/3/9.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "BGTabBar.h"
//#import "UIViewExt.h"
@interface BGTabBar()
{
    UIView * _line1;
    UIView * _line2;
}



@end
@implementation BGTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[[UIImage imageNamed:@"tab_icon_fabu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"tab_icon_fabu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateHighlighted];
        [button setBackgroundImage:[[UIImage imageNamed:@"tab_icon_fabu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateSelected];

        button.width = 60;
        button.height = 60;
       

        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        self.plusBtn = button;
        
        //加横线
        UIView * line1 =[UIView new];
        line1.backgroundColor = GRAY_SEP;
        line1.layer.shadowColor=[[UIColor hexStringToColor:@"#d7d7d7"] colorWithAlphaComponent:0.5f].CGColor;
        line1.layer.shadowOffset=CGSizeMake(0, 0);
        line1.layer.shadowOpacity=0.95f;
        line1.layer.shadowRadius=4;
        [self addSubview:line1];
        _line1 = line1;
        
        UIView * line2 =[UIView new];
        line2.backgroundColor = GRAY_SEP;
        line2.layer.shadowColor=[[UIColor hexStringToColor:@"#d7d7d7"] colorWithAlphaComponent:0.5f].CGColor;
        line2.layer.shadowOffset=CGSizeMake(0, 0);
        line2.layer.shadowOpacity=0.95f;
        line2.layer.shadowRadius=4;
        [self addSubview:line2];
        _line2 = line2;

//        CALayer * line1 =[CALayer layer];
//        line1.backgroundColor = GRAY_SEP.CGColor;
//        [self.layer addSublayer:line1];
//        _line1 = line1;
//
//        CALayer * line2 =[CALayer layer];
//        line2.backgroundColor = GRAY_SEP.CGColor;
//        [self.layer addSublayer:line2];
//        _line2 = line2;

    }
    return self;
}
//重写tabBar的方法
- (void)layoutSubviews{
    [super layoutSubviews];
    //    1、设置加号按钮的位置
    self.plusBtn.centerX = self.width/2;
    if (KISIphoneX) {
        self.plusBtn.centerY = self.height/2- 10 - 34/2.0f - 3;
        _line1.frame = CGRectMake(0, 0, (self.width - self.plusBtn.width)/2.0 + 5, 0.6);
        _line2.frame = CGRectMake(self.plusBtn.right - 5, 0, (self.width - self.plusBtn.width)/2.0 + 5, 0.6);
    }else{
    self.plusBtn.centerY = self.height/2- 10;
        _line1.frame = CGRectMake(0, 0, (self.width - self.plusBtn.width)/2.0 + 6, 0.6);
        _line2.frame = CGRectMake(self.plusBtn.right - 6, 0, (self.width - self.plusBtn.width)/2.0 + 6, 0.6);
    }

}

////加号按钮点击
- (void)buttonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    //通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}
@end
