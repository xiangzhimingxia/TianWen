//
//  TeacherOrderViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/12.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TeacherOrderViewController.h"
#import "TeacherOrderListTableCell.h"
#import "OrderListModel.h"
#import "TeacherOrderDetailsViewController.h"
#import "QuestionDetailsViewController.h"

@interface TeacherOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSArray *navArr;

@property (nonatomic, strong) UIView *bottomNavLine;

kAS(NSInteger, selectNum);

@end

@implementation TeacherOrderViewController

-(NSArray *)navArr{
    if (!_navArr) {
        _navArr = @[@"全部",@"未接单",@"已完成",@"已付款",@"已评价"];
    }
    return _navArr;
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
    self.selectNum = 0;
    [self isRefreshing];
}

-(void)creatUI{
    
    self.titleLable.text = @"我的订单";
    
    [self initScrollTopView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 58, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 58) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TeacherOrderListTableCell" bundle:nil] forCellReuseIdentifier:@"TeacherOrderListTableCell"];
    
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
    NSString *typeStr = @"";
    switch (self.selectNum) {
        case 0:
            break;
        case 1:
            typeStr = @"0";
            break;
        case 2:
            typeStr = @"1";
            break;
        case 3:
            typeStr = @"2";
            break;
        case 4:
            typeStr = @"3";
            break;
            
        default:
            break;
    }
    
    NSDictionary *activityParams = @{@"token":User.token,@"status":typeStr,@"page":@(_page),@"pageSize":@"10"};
    
    [HttpManager getWithURL:orderList_Home andParams:activityParams returnBlcok:^(NSError *error, id obj) {
        [self endRefreshing];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            NSArray *souceArr = [OrderListModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"orderList"]];
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

-(void)initScrollTopView{
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, 58)];
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
        navBtn.frame = CGRectMake(KMainScreenWidth/self.navArr.count * i, 0, KMainScreenWidth/self.navArr.count, 58 - 2);
        [navBtn addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
        navBtn.tag = 10 + i;
        
        if (i == 0) {
            
            navBtn.selected = YES;
            [navBtn setFont:[UIFont systemFontOfSize:15]];
            
            self.bottomNavLine = [[UIView alloc]initWithFrame:CGRectMake(0, 56, 72, 2)];
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
}

-(void)navAction:(UIButton *)sender{
    
    for (NSInteger i = 0; i < self.navArr.count; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:10 + i];
        if (i == sender.tag - 10) {
            
            self.selectNum = i;
            [self isRefreshing];
            
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
    
    TeacherOrderListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherOrderListTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell refreshUI:self.dataArr[indexPath.section]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count == 0) {
        return;
    }
    if ([[self.dataArr[indexPath.section] orderStatus] integerValue] == 0) {
        QuestionDetailsViewController *vc= [QuestionDetailsViewController new];
        vc.orderId = [self.dataArr[indexPath.section] orderId];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        TeacherOrderDetailsViewController *vc= [TeacherOrderDetailsViewController new];
        vc.orderId = [self.dataArr[indexPath.section] orderId];
        vc.orderStatus = [self.dataArr[indexPath.section] orderStatus];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 195;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


@end
