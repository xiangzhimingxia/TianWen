//
//  StudentsMineViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/19.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsMineViewController.h"
#import "StudentsMineTopView.h"
#import "IntegralTableViewCell.h"
#import "FunctionTableViewCell.h"
#import "IntegralExchangeViewController.h"
#import "StudentsMoneyViewController.h"
#import "RuleExplainViewController.h"
#import "MyOrdersViewController.h"
#import "StudentsMyFocusViewController.h"
#import "TaacherInfoApplyViewController.h"
#import "AddActivityViewController.h"
#import "AppDelegate.h"
#import "StudentInfoViewController.h"
#import "TeacherInfoModel.h"
#import "OtherModel.h"
#import "TRTCCalling.h"
#import "SetViewController.h"

@interface StudentsMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) StudentsMineTopView *topView;

@property (nonatomic, strong) TeacherInfoModel *infoModel;

@end

@implementation StudentsMineViewController

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IntegralTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntegralTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FunctionTableViewCell" bundle:nil] forCellReuseIdentifier:@"FunctionTableViewCell"];
    
    
    self.topView = [[[NSBundle mainBundle]loadNibNamed:@"StudentsMineTopView" owner:self options:nil] lastObject];
    self.topView.frame = CGRectMake(0, 0, KMainScreenWidth, 165);
    self.tableView.tableHeaderView = self.topView;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
    footView.backgroundColor = MainBackgroundColor;
    self.tableView.tableFooterView = footView;
    
    [self.topView.exitBtn setEnlargeEdgeWithTop:0 right:6 bottom:0 left:0];
    
    self.topView.switchBtn.hidden = YES;
    self.topView.switchBtn.enabled = NO;
    
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
    
    [HttpManager postNotHeadWithURL:switch_Mine andParams:@{@"token":User.token,@"type":@"1"} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            User.isAnswer = YES;
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
            if ([User.userIdentity integerValue] == 2) {
                self.topView.describeLb.text = [NSString stringWithFormat:@"%@ %@",self.infoModel.qualificationsName,self.infoModel.mobile];
            }else{
                self.topView.describeLb.text = [NSString stringWithFormat:@"%@ %@",self.infoModel.gradeName,self.infoModel.mobile];
            }
            
            OtherModel *otherModel = [OtherModel mj_objectWithKeyValues:obj[dataKey]];
            
            if (otherModel.audits.length > 0) {
                User.audits = otherModel.audits;
                [User updateLocalUser];
                
//                if ([otherModel.audits integerValue] == 1) {
//                    self.topView.switchBtn.hidden = NO;
//                    self.topView.switchBtn.enabled = YES;
//                }else{
//                    self.topView.switchBtn.hidden = YES;
//                    self.topView.switchBtn.enabled = NO;
//                }
                
            }else{
                User.audits = @"10";
                [User updateLocalUser];
                
//                self.topView.switchBtn.hidden = YES;
//                self.topView.switchBtn.enabled = NO;
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}

#pragma  tableView -- Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        IntegralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        cell.integralLb.text = [NSString stringWithFormat:@"积分：%@",self.infoModel.integral];
        return cell;
    }else if(indexPath.section == 1){
        
        FunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FunctionTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        
        [cell.moneyBtn addTarget:self action:@selector(myMoneyAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.explainBtn addTarget:self action:@selector(explainAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.ordersBtn addTarget:self action:@selector(myOrderAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.focusBtn addTarget:self action:@selector(myFocusAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if(indexPath.section == 2){
        
        static NSString *cellId = @"ApplyUITableViewCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        UIImageView *picImg = [UIImageView new];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = MainBackgroundColor;
            
            picImg.frame = CGRectMake(15, 0, KMainScreenWidth - 15*2, 100);
            [cell.contentView addSubview:picImg];
        }
        picImg.image =[UIImage imageNamed:@"mine_banner1"];
        return cell;
    }else{
        static NSString *cellId = @"ChangeUITableViewCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        UIImageView *picImg = [UIImageView new];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = MainBackgroundColor;
            
            picImg.frame = CGRectMake(15, 0, KMainScreenWidth - 15*2, 100);
            [cell.contentView addSubview:picImg];
        }
        picImg.image =[UIImage imageNamed:@"mine_banner2"];
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IntegralExchangeViewController *exchangeVC = [IntegralExchangeViewController new];
        exchangeVC.integral = self.infoModel.integral;
        [self.navigationController pushViewController:exchangeVC animated:YES];
    }else if (indexPath.section == 2){
        TaacherInfoApplyViewController *VC = [TaacherInfoApplyViewController new];
        VC.auditsStatus = User.audits;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.section == 3){
//        AddActivityViewController *VC = [AddActivityViewController new];
//        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 58;
    }else if(indexPath.section == 1){
        return 166;
    }else{
        return 100;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - Event
-(void)myMoneyAction{
    StudentsMoneyViewController *moneyVC = [StudentsMoneyViewController new];
    [self.navigationController pushViewController:moneyVC animated:YES];
}
-(void)explainAction{
    
    MyOrdersViewController *VC = [MyOrdersViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)myOrderAction{
    StudentsMyFocusViewController *VC = [StudentsMyFocusViewController new];
    [self.navigationController pushViewController:VC animated:YES];    
}
-(void)myFocusAction{
    SetViewController *setVC = [SetViewController new];
    [self.navigationController pushViewController:setVC animated:YES];
}

@end
