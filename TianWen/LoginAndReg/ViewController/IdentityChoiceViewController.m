//
//  IdentityChoiceViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/14.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "IdentityChoiceViewController.h"
#import "TaacherInfoApplyViewController.h"
#import "StudentInfoViewController.h"

@interface IdentityChoiceViewController ()
@property (weak, nonatomic) IBOutlet UIView *studentView;
@property (weak, nonatomic) IBOutlet UIView *teacherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopheightConstant;

@end

@implementation IdentityChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

-(void)creatUI{
    
    self.titleLable.text = @"身份选择";
    self.view.backgroundColor = [UIColor whiteColor];
    self.toTopheightConstant.constant = SafeAreaTopHeight + 30;
    
    __weak typeof(self) weakSelf = self;
    [self.teacherView setTapActionWithBlock:^{
       
        User.userIdentity = @"2";
        [User updateLocalUser];
        
        TaacherInfoApplyViewController *vc = [TaacherInfoApplyViewController new];
        vc.isTeacherInfo = YES;
        vc.isLogin = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [self.studentView setTapActionWithBlock:^{
       
        User.userIdentity = @"1";
        [User updateLocalUser];
        StudentInfoViewController *vc = [StudentInfoViewController new];
        vc.isLogin = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

@end
