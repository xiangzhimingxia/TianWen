//
//  StudentsMyFocusViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/23.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsMyFocusViewController.h"
#import "StudentsFocusQuestionViewController.h"
#import "StudentsFocusTeacherViewController.h"

@interface StudentsMyFocusViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *navArr;

@property (nonatomic, strong) UIView *bottomNavLine;

@property (nonatomic, strong) UIScrollView *baseScrollView;

@end

@implementation StudentsMyFocusViewController

-(NSArray *)navArr{
    if (!_navArr) {
        _navArr = @[@"问题",@"老师"];
    }
    return _navArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

-(void)creatUI{
    
    self.titleLable.text = @"我的关注";
 
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, 48)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    for (NSInteger i = 0; i < self.navArr.count; i++) {
        UIButton *navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [navBtn setBackgroundColor:[UIColor clearColor]];
        [navBtn setTitle:self.navArr[i] forState:UIControlStateNormal];
        navBtn.font = [UIFont systemFontOfSize:15];
        [navBtn setTitleColor:JColorFromRGB(0x666666) forState:UIControlStateNormal];
        [navBtn setTitleColor:KNavColor forState:UIControlStateSelected];
        [navBtn setTitleColor:KNavColor forState:UIControlStateHighlighted];
        navBtn.frame = CGRectMake(KMainScreenWidth/self.navArr.count * i, 0, KMainScreenWidth/self.navArr.count, 48 - 2);
        [navBtn addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
        navBtn.tag = 10 + i;
        
        if (i == 0) {
            
            navBtn.selected = YES;
            [navBtn setFont:[UIFont systemFontOfSize:15]];
            
            self.bottomNavLine = [[UIView alloc]initWithFrame:CGRectMake(0, 48 - 2, 72, 2)];
            self.bottomNavLine.backgroundColor = KNavColor;
            
            //            CGSize LbSize = LabelSizeWithStr(self.navArr[i], CGSizeMake(KMainScreenWidth, 30), Attributes(15));
            
            //            navBtn.imageEdgeInsets = UIEdgeInsetsMake(0, ceil(LbSize.width) + ceil(LbSize.width)/2.0f , 0, 0);
            //            navBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ceil(LbSize.width)/2.0f - 20);
            
            //            [self.bottomNavLine setWidth:ceil(LbSize.width) ];
            self.bottomNavLine.centerX = navBtn.centerX;
            [navView addSubview:self.bottomNavLine];
        }
        
        [navView addSubview:navBtn];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 48, KMainScreenWidth, 14)];
    lineView.backgroundColor = MainBackgroundColor;
    [self.view addSubview:lineView];
    
    self.baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 48 + 14, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - 48 - 14)];
    self.baseScrollView.contentSize = CGSizeMake(KMainScreenWidth * self.navArr.count, 1);
    self.baseScrollView.bounces = NO;
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.delegate = self;
    self.baseScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseScrollView];
    
    StudentsFocusQuestionViewController *focusVC = [StudentsFocusQuestionViewController new];
    focusVC.view.frame = CGRectMake(0, 0, KMainScreenWidth, self.baseScrollView.frame.size.height);
    [self addChildViewController:focusVC];
    [self.baseScrollView addSubview:focusVC.view];
    
    StudentsFocusTeacherViewController *teacherVC = [StudentsFocusTeacherViewController new];
    teacherVC.view.frame = CGRectMake(KMainScreenWidth, 0, KMainScreenWidth, self.baseScrollView.frame.size.height);
    [self addChildViewController:teacherVC];
    [self.baseScrollView addSubview:teacherVC.view];
}

-(void)navAction:(UIButton *)sender{
    
    for (NSInteger i = 0; i < self.navArr.count; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:10 + i];
        if (i == sender.tag - 10) {
            
            btn.selected = YES;
            [btn setFont:[UIFont systemFontOfSize:15]];
            
            [UIView animateWithDuration:.25 animations:^{
                
                //                CGSize LbSize = LabelSizeWithStr(self.navArr[i], CGSizeMake(KMainScreenWidth, 30), Attributes(15));
                //
                //                [self.bottomNavLine setWidth:ceil(LbSize.width)];
                self.bottomNavLine.centerX = btn.centerX ;
                
                [self.baseScrollView scrollRectToVisible:CGRectMake(KMainScreenWidth * (sender.tag - 10), 0, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - 48 - 14) animated:YES];
                
            }];
        }else{
            btn.selected = NO;
            [btn setFont:[UIFont systemFontOfSize:15]];
            
        }
    }
}

#pragma marj -- UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.baseScrollView) {
        
        CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (value < 0) {return;}
        if (value > self.navArr.count) {return;}
    
        for (NSInteger i = 0; i < self.navArr.count; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:10 + i];
            if (i == value) {
                
                btn.selected = YES;
                [btn setFont:[UIFont systemFontOfSize:15]];
                
                [UIView animateWithDuration:.25 animations:^{
                    
                    //                CGSize LbSize = LabelSizeWithStr(self.navArr[i], CGSizeMake(KMainScreenWidth, 30), Attributes(15));
                    //
                    //                [self.bottomNavLine setWidth:ceil(LbSize.width)];
                    self.bottomNavLine.centerX = btn.centerX ;
                    
                }];
            }else{
                btn.selected = NO;
                [btn setFont:[UIFont systemFontOfSize:15]];
                
            }
        }
        
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView == self.baseScrollView) {
        
        CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (value < 0) {return;}
        if (value > self.navArr.count) {return;}
        
        for (NSInteger i = 0; i < self.navArr.count; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:10 + i];
            if (i == value) {
                
                btn.selected = YES;
                [btn setFont:[UIFont systemFontOfSize:15]];
                
                [UIView animateWithDuration:.25 animations:^{
                    
                    //                CGSize LbSize = LabelSizeWithStr(self.navArr[i], CGSizeMake(KMainScreenWidth, 30), Attributes(15));
                    //
                    //                [self.bottomNavLine setWidth:ceil(LbSize.width)];
                    self.bottomNavLine.centerX = btn.centerX ;
                    
                }];
            }else{
                btn.selected = NO;
                [btn setFont:[UIFont systemFontOfSize:15]];
                
            }
        }
        
        
    }
    
}

@end
