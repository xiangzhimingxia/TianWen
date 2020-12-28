//
//  ActivityListViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityListTableCell.h"
#import "ActityModel.h"
#import "ActivityDetailsViewController.h"

@interface ActivityListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ActivityListViewController

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
    
    self.titleLable.text = @"活动列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityListTableCell" bundle:nil] forCellReuseIdentifier:@"ActivityListTableCell"];
    
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
    
    NSDictionary *activityParams = @{@"page":@(_page),@"pageSize":@"10"};
    
    [HttpManager getWithURL:activityList_Home andParams:activityParams returnBlcok:^(NSError *error, id obj) {
        [self endRefreshing];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            NSArray *souceArr = [ActityModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"activityList"]];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        ActivityListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityListTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell refreshUI:self.dataArr[indexPath.row]];
        return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count <= 0) return;
    ActivityDetailsViewController *vc = [ActivityDetailsViewController new];
    vc.titleStr = [self.dataArr[indexPath.row] activityName];
    vc.isType = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

@end
