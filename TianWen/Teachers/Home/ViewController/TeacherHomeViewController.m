//
//  TeacherHomeViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/2.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TeacherHomeViewController.h"
#import "TeacherHomeTopView.h"
#import "TeacherHomeTableCell.h"
#import "QuestionDetailsViewController.h"
#import "OrderListModel.h"
#import "OtherModel.h"

@interface TeacherHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TeacherHomeTopView *topView;

@property (nonatomic, assign) NSInteger page;

kUI(NSMutableArray, dataArr);
kUI(OtherModel, topModel;)

@end

@implementation TeacherHomeViewController

-(OtherModel *)topModel{
    if (!_topModel) {
        _topModel = [OtherModel new];
    }
    return _topModel;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self isRefreshing];
}

-(void)creatUI{
    
    self.titleLable.text = @"先问辅导";
    self.leftButton.hidden = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;    
    self.tableView.backgroundColor = [UIColor whiteColor];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TeacherHomeTableCell" bundle:nil] forCellReuseIdentifier:@"TeacherHomeTableCell"];
    
    self.topView = [[[NSBundle mainBundle]loadNibNamed:@"TeacherHomeTopView" owner:self options:nil] lastObject];
    self.topView.frame = CGRectMake(0, 0, KMainScreenWidth, 105);
    self.tableView.tableHeaderView = self.topView;
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataArr removeAllObjects];
        weakSelf.page = 1;
        [weakSelf requestTopData];
        [weakSelf requestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf requestData];
    }];
    
}

-(void)requestTopData{
    [HttpManager getWithURL:answerStatistics_Home andParams:@{@"token":User.token} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.topModel = [OtherModel mj_objectWithKeyValues:obj[dataKey][@"answerStatistics"]];
            self.topView.praiseLb.text = self.topModel.satisfiedCount;
            self.topView.timeLb.text = self.topModel.answerDuration;
            self.topView.numLb.text = self.topModel.orderCount;
            self.topView.moneyLb.text = self.topModel.answerIncome;
            
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}

-(void)requestData{
    
    NSDictionary *activityParams = @{@"page":@(_page),@"pageSize":@"10"};
    
    [HttpManager getWithURL:answerList_Home andParams:activityParams returnBlcok:^(NSError *error, id obj) {
        [self endRefreshing];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            NSArray *souceArr = [OrderListModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"answerList"]];
            [self.dataArr addObjectsFromArray:souceArr];
            [self.tableView reloadData];
            if (souceArr.count <= 0) {
                self->_page--;
            }
        }else{
            self->_page--;
            [self.tableView reloadData];
        }
    }];
    
}

- (void)isRefreshing {
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefreshing {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma  tableView -- Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeacherHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherHomeTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell refreshUI:self.dataArr[indexPath.section]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count == 0) {
        return;
    }
    QuestionDetailsViewController *vc = [QuestionDetailsViewController new];
    vc.orderId = [self.dataArr[indexPath.section] orderId];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 129 - 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

@end
