//
//  StudentsFocusTeacherViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/26.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsFocusTeacherViewController.h"
#import "StudentsFocusTeacherTableCell.h"
#import "TeacherDetailViewController.h"
#import "TeacherTeamModel.h"

@interface StudentsFocusTeacherViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation StudentsFocusTeacherViewController

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
    
    self.navigationBarView.hidden = YES;
    self.view.backgroundColor = MainBackgroundColor;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - 48 - 14) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = MainBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    //    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0,*)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StudentsFocusTeacherTableCell" bundle:nil] forCellReuseIdentifier:@"StudentsFocusTeacherTableCell"];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataArr removeAllObjects];
        weakSelf.page = 1;
        [weakSelf requestData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf requestData];
    }];
    
}

-(void)requestData{
    
    NSDictionary *activityParams = @{@"token":User.token,@"page":@(_page),@"pageSize":@"10",@"relationType":@"2"};
    
    [HttpManager getWithURL:myFollow_Mine andParams:activityParams returnBlcok:^(NSError *error, id obj) {
        [self endRefreshing];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            NSArray *souceArr = [TeacherTeamModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"myFollowList"]];
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
    
    StudentsFocusTeacherTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentsFocusTeacherTableCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = MainBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell refreshUI:self.dataArr[indexPath.section]];
    __weak typeof(self) weakSelf = self;
    [cell.cancelFocusView setTapActionWithBlock:^{
        [weakSelf postFocusWith:indexPath.section WithView:cell.cancelFocusView WithId:[weakSelf.dataArr[indexPath.section] userId]];
    }];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count <= 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    TeacherDetailViewController *VC = [TeacherDetailViewController new];
    VC.titleStr = [self.dataArr[indexPath.section] realName];
    VC.userId = [self.dataArr[indexPath.section] userId];
    VC.block = ^{
        [weakSelf isRefreshing];
    };
    [self.navigationController pushViewController:VC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 93;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

-(void)postFocusWith:(NSInteger)selectNum WithView:(UIView *)sender WithId:(NSString *)userID{
    sender.userInteractionEnabled = NO;
    [HttpManager postNotHeadWithURL:follow_Home andParams:@{@"token":User.token,@"followType":@"1",@"relationId":userID,@"relationType":@"1"} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            if (self.dataArr.count <= 0) {
                return ;
            }
            [self.dataArr removeObjectAtIndex:selectNum];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
        sender.userInteractionEnabled = YES;
    }];
}

@end
