//
//  SetViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/28.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "SetViewController.h"
#import "SetTableCell.h"
#import "WebViewViewController.h"
#import "FeedbankViewController.h"
#import "TRTCCalling.h"
#import "AppDelegate.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

kUI(UIButton, answerBtn);

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatUI];
}

-(void)creatUI{
    
    self.titleLable.text = @"设置";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, SafeAreaTopHeight, KMainScreenWidth - 15, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = MainBackgroundColor;
    self.tableView.bounces = NO;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SetTableCell" bundle:nil] forCellReuseIdentifier:@"SetTableCell"];
    
    UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 150)];
    footView.backgroundColor = MainBackgroundColor;
    
    self.answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.answerBtn setTitle:@"退出" forState:UIControlStateNormal];
    [self.answerBtn setFont:[UIFont systemFontOfSize:18]];
    [self.answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.answerBtn.backgroundColor = KNavColor;
    self.answerBtn.frame = CGRectMake(35, 50, KMainScreenWidth - 35*2, 50);
    self.answerBtn.clipsToBounds = YES;
    self.answerBtn.layer.cornerRadius = 25;
    self.answerBtn.userInteractionEnabled = NO;
    [footView addSubview:self.answerBtn];
    
    self.tableView.tableFooterView = footView;
    
    __weak typeof(self) weakSelf = self;
    [self.answerBtn setTapActionWithBlock:^{
        [User loginOut];
        
        [weakSelf logoutIMAction];
    }];
    
}

-(void)logoutIMAction{
    
    [[TRTCCalling shareInstance] logout:^{
        [(AppDelegate *)[UIApplication sharedApplication].delegate initRootViewController];
    } failed:^(int code, NSString * _Nonnull des) {
        [MBProgressHUD showMessage:des];
        [(AppDelegate *)[UIApplication sharedApplication].delegate initRootViewController];
    }];
}

#pragma  tableView -- Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    NSArray *imgArr = @[@"icon111",@"icon112",@"icon112(1)",@"icon113"];
    NSArray *nameArr = @[@"计费规则",@"帮助中心",@"联系我们",@"反馈意见"];
    cell.img.image = [UIImage imageNamed:imgArr[indexPath.row]];
    cell.textLb.text = nameArr[indexPath.row];
    if (indexPath.row == 3) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            {
                WebViewViewController *webVC = [WebViewViewController new];
                webVC.type = 1;
                [self.navigationController pushViewController:webVC animated:YES];
            }
            break;
        case 1:
        {
            WebViewViewController *webVC = [WebViewViewController new];
            webVC.type = 2;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2:
        {
            WebViewViewController *webVC = [WebViewViewController new];
            webVC.type = 3;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 3:
        {
            FeedbankViewController *VC = [FeedbankViewController new];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

@end
