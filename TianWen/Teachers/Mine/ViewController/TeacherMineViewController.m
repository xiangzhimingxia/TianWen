//
//  TeacherMineViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/2.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TeacherMineViewController.h"
#import "StudentsMineTopView.h"
#import "FunctionTableViewCell.h"
#import "TaacherInfoApplyViewController.h"
#import "AppDelegate.h"
#import "TeacherMoneyViewController.h"
#import "TeacherOrderViewController.h"
#import "SetViewController.h"
#import "TeacherInfoModel.h"
#import "StudentInfoViewController.h"
#import "OtherModel.h"
#import "TRTCCalling.h"

@interface TeacherMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) StudentsMineTopView *topView;

@property (nonatomic, strong) TeacherInfoModel *infoModel;

@end

@implementation TeacherMineViewController

-(TeacherInfoModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [TeacherInfoModel new];
    }
    return _infoModel;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

-(void)creatUI{
    
    self.navigationBarView.hidden = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight - 44, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 49 + 44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = MainBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0,*)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
        
    [self.tableView registerNib:[UINib nibWithNibName:@"FunctionTableViewCell" bundle:nil] forCellReuseIdentifier:@"FunctionTableViewCell"];
    
    
    self.topView = [[[NSBundle mainBundle]loadNibNamed:@"StudentsMineTopView" owner:self options:nil] lastObject];
    self.topView.frame = CGRectMake(0, 0, KMainScreenWidth, 165);
    self.tableView.tableHeaderView = self.topView;
    
    self.topView.switchBtn.hidden = YES;
    self.topView.switchBtn.enabled = NO;
    
    [self.topView.exitBtn setEnlargeEdgeWithTop:0 right:6 bottom:0 left:0];
    
    __weak typeof(self) weakSelf = self;
    [self.topView.editBtn setTapActionWithBlock:^{
        
        if ([User.userIdentity integerValue] == 1) {
            StudentInfoViewController *infoVC = [StudentInfoViewController new];
            [weakSelf.navigationController pushViewController:infoVC animated:YES];
        }else{
        TaacherInfoApplyViewController *vc = [TaacherInfoApplyViewController new];
        vc.isAnswerInfo = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    
    [self.topView.switchBtn setTapActionWithBlock:^{
        weakSelf.topView.switchBtn.userInteractionEnabled = NO;
//        [weakSelf logoutIMAction];
    }];
    
    [self.topView.exitBtn setTapActionWithBlock:^{
        [User loginOut];
        
        [weakSelf logoutIMAction];
    }];
}

-(void)swichIDAction{
    
    [HttpManager postNotHeadWithURL:switch_Mine andParams:@{@"token":User.token,@"type":@"0"} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            User.isAnswer = NO;
            User.userId = obj[dataKey][@"userId"];
            User.token = obj[dataKey][@"token"];
            [User updateLocalUser];
            
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [del initRootViewController];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
        self.topView.switchBtn.userInteractionEnabled = YES;
    }];
}

-(void)logoutIMAction{
    
    [[TRTCCalling shareInstance] logout:^{
        if (User.isLogin) {
            [self swichIDAction];
        }else{
            [(AppDelegate *)[UIApplication sharedApplication].delegate initRootViewController];
        }
    } failed:^(int code, NSString * _Nonnull des) {
        [MBProgressHUD showMessage:des];
        [(AppDelegate *)[UIApplication sharedApplication].delegate initRootViewController];
    }];
}

-(void)requestData{
    [HttpManager getWithURL:userInfo_Mine andParams:@{@"token":User.token} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            
            self.infoModel = [TeacherInfoModel mj_objectWithKeyValues:obj[dataKey][@"userInfo"]];
            [self.topView.headImg sd_setImageWithURL:[NSURL URLWithString:self.infoModel.headPic] placeholderImage:[UIImage imageNamed:@"holdHeader"]];
            self.topView.nameLb.text = self.infoModel.nickName;
            if (self.infoModel.userIdentity.length > 0) {
                User.userIdentity = self.infoModel.userIdentity;
                [User updateLocalUser];
            }
            if ([User.userIdentity integerValue] == 1) {
                self.topView.describeLb.text = [NSString stringWithFormat:@"%@ %@",self.infoModel.gradeName,self.infoModel.mobile];
            }else{
            self.topView.describeLb.text = [NSString stringWithFormat:@"%@ %@",self.infoModel.qualificationsName,self.infoModel.mobile];
            }
            
            OtherModel *otherModel = [OtherModel mj_objectWithKeyValues:obj[dataKey]];
            
            if (otherModel.audits.length > 0) {
                User.audits = otherModel.audits;
                [User updateLocalUser];
            }else{
                User.audits = @"10";
                [User updateLocalUser];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}

#pragma  tableView -- Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FunctionTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = MainBackgroundColor;
    
    cell.explainLb.text = @"我的订单";
    [cell.explainBtn setImage:[UIImage imageNamed:@"icon4"] forState:UIControlStateNormal];
    cell.orderLb.text = @"平台客服电话";
    [cell.ordersBtn setImage:[UIImage imageNamed:@"icon3备份"] forState:UIControlStateNormal];
    cell.focusLb.text = @"设置";
    [cell.focusBtn setImage:[UIImage imageNamed:@"icon5备份 2"] forState:UIControlStateNormal];
    [cell.moneyBtn addTarget:self action:@selector(myMoneyAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.explainBtn addTarget:self action:@selector(explainAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.ordersBtn addTarget:self action:@selector(myOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.focusBtn addTarget:self action:@selector(myFocusAction) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 186;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - Event
-(void)myMoneyAction{
    TeacherMoneyViewController *moneyVC = [TeacherMoneyViewController new];
    [self.navigationController pushViewController:moneyVC animated:YES];
}
-(void)explainAction{
    
    TeacherOrderViewController *VC = [TeacherOrderViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)myOrderAction{
    

}
-(void)myFocusAction{
    SetViewController *VC = [SetViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
