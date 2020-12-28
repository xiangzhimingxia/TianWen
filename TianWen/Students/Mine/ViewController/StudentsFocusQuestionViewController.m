//
//  StudentsFocusQuestionViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/26.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsFocusQuestionViewController.h"
#import "ArticleDetailViewController.h"
#import "StudentsChooseTableCell.h"
#import "ArticleModel.h"

@interface StudentsFocusQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation StudentsFocusQuestionViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - 48 - 14) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StudentsChooseTableCell" bundle:nil] forCellReuseIdentifier:@"StudentsChooseTableCell2"];
    
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
    
    NSDictionary *activityParams = @{@"token":User.token,@"page":@(_page),@"pageSize":@"10",@"relationType":@"1"};
    
    [HttpManager getWithURL:myFollow_Mine andParams:activityParams returnBlcok:^(NSError *error, id obj) {
        [self endRefreshing];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            NSArray *souceArr = [ArticleModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"myFollowList"]];
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    StudentsChooseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentsChooseTableCell2" forIndexPath:indexPath];
    cell.cancelFocusView.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell refreshUI:self.dataArr[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    [cell.cancelFocusView setTapActionWithBlock:^{
        [weakSelf postFocusWith:indexPath.row WithView:cell.cancelFocusView WithId:[weakSelf.dataArr[indexPath.row] questionId]];
    }];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArr.count <= 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    ArticleDetailViewController *VC = [ArticleDetailViewController new];
    VC.questionId = [self.dataArr[indexPath.row] questionId];
    VC.block = ^{
        [weakSelf isRefreshing];
    };
    [self.navigationController pushViewController:VC animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136 + 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(void)postFocusWith:(NSInteger)selectNum WithView:(UIView *)sender WithId:(NSString *)userID{
    sender.userInteractionEnabled = NO;
    [HttpManager postNotHeadWithURL:follow_Home andParams:@{@"token":User.token,@"followType":@"1",@"relationId":userID,@"relationType":@"0"} returnBlcok:^(NSError *error, id obj) {
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
