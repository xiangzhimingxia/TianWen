//
//  StudentsHomeViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/19.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsHomeViewController.h"
#import "StudentsHomeTopView.h"
#import "SDCycleScrollView.h"
#import "StudentsChooseTableCell.h"
#import "StudentsHomeTeamTableCell.h"
#import "StudentsHomeActivityTableCell.h"
#import "ActivityListViewController.h"
#import "StudentsSearchViewController.h"
#import "ArticleDetailViewController.h"
#import "OtherModel.h"
#import "TeacherTeamModel.h"
#import "ActityModel.h"
#import "ArticleModel.h"
#import "WebViewViewController.h"

static const NSInteger ScrollFontNum = 13;

@interface StudentsHomeViewController ()<UITableViewDelegate,UITableViewDataSource,HomeTopViewDelegate,SDCycleScrollViewDelegate>
{
    float btnStartAndEndX;
    float offSet;
    float allViewWidth;
    float leftAndRightJianGe;
    float backViewWidth;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) StudentsHomeTopView *topView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView2;

@property (nonatomic, strong) NSArray *navArr;

@property (nonatomic, strong) UIView *bottomNavLine;

@property (nonatomic, strong) UIScrollView *navView;

kUI(NSArray, bannerArr);
kUI(NSArray, navDataArr);
kUI(NSMutableArray, facultyTeamMutArr);
kUI(NSMutableArray, activityMutArr);
kStr(columnId);
kAS(NSInteger, selectInt);

@end

@implementation StudentsHomeViewController

-(NSMutableArray *)activityMutArr{
    if (!_activityMutArr) {
        _activityMutArr = [NSMutableArray new];
    }
    return _activityMutArr;
}
-(NSMutableArray *)facultyTeamMutArr{
    if (!_facultyTeamMutArr) {
        _facultyTeamMutArr = [NSMutableArray new];
    }
    return _facultyTeamMutArr;
}
-(NSArray *)navDataArr{
    if (!_navDataArr) {
        _navDataArr = [NSArray new];
    }
    return _navDataArr;
}
-(NSArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSArray new];
    }
    return _bannerArr;
}
-(NSArray *)navArr{
    if (!_navArr) {
        _navArr = [NSArray new];
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
    [self requestData];
}

-(void)creatUI{
    
    self.titleLable.text = @"先问辅导";
    self.leftButton.hidden = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 49) style:UITableViewStyleGrouped];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StudentsChooseTableCell" bundle:nil] forCellReuseIdentifier:@"StudentsChooseTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StudentsHomeTeamTableCell" bundle:nil] forCellReuseIdentifier:@"StudentsHomeTeamTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StudentsHomeActivityTableCell" bundle:nil] forCellReuseIdentifier:@"StudentsHomeActivityTableCell"];
    
    self.topView = [[[NSBundle mainBundle]loadNibNamed:@"StudentsHomeTopView" owner:self options:nil] lastObject];
    self.topView.frame = CGRectMake(0, 0, KMainScreenWidth, 334);
    self.topView.homeDelagate = self;
    self.tableView.tableHeaderView = self.topView;
    
    self.cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 8+36+8, KMainScreenWidth, 155) delegate:self placeholderImage:[UIImage imageNamed:@"holdPic"]];
    
    self.cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.cycleScrollView2.pageDotColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    
    // 剪切图片
    self.cycleScrollView2.contentMode = UIViewContentModeScaleAspectFill;
//    self.cycleScrollView2.clipsToBounds = YES;
//    self.cycleScrollView2.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cycleScrollView2.delegate = self;
    [self.topView addSubview:self.cycleScrollView2];
    
//    self.cycleScrollView2.localizationImageNamesGroup = @[@"banner 1",@"banner 1",@"banner 1",@"banner 1"];
    
    __weak typeof(self) weakSelf = self;
    [self.topView.SearchView setTapActionWithBlock:^{
        StudentsSearchViewController *searchVC = [StudentsSearchViewController new];
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf requestArticleDataWithId:self.columnId];
    }];
    
}

-(void)requestData{
    
    [HttpManager getWithURL:Banner_Home andParams:nil returnBlcok:^(NSError *error, id obj) {
        
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.bannerArr = [OtherModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"bannerList"]];
            NSMutableArray *bannerMutArr = [NSMutableArray new];
            for (NSInteger i = 0; i < self.bannerArr.count; i++) {
                
                OtherModel *model = self.bannerArr[i];
                [bannerMutArr addObject:model.bannerPic];
            }
            
            self.cycleScrollView2.imageURLStringsGroup = [bannerMutArr copy];
        }
        
    }];
    
//    [HttpManager getWithURL:online_Home andParams:@{@"token":User.token} returnBlcok:^(NSError *error, id obj) {
//
//        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
//            OtherModel *model = [OtherModel mj_objectWithKeyValues:obj[dataKey]];
//            NSLog(@"%@", model);
//        }
//
//    }];
    
    [HttpManager getWithURL:column_Home andParams:nil returnBlcok:^(NSError *error, id obj) {
  
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.navDataArr = [OtherModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"columnList"]];
            NSMutableArray *navMutArr = [NSMutableArray new];
            for (NSInteger i = 0; i<self.navDataArr.count; i++) {
                OtherModel *model = self.navDataArr[i];
                [navMutArr addObject:model.columnName];
            }
            
            self.navArr = [navMutArr copy];

            [self TopViewAddScrollUI];
            
            if (self.navDataArr.count > 0) {
                OtherModel *navModel = [self.navDataArr firstObject];
                self.selectInt = 0;
                self.columnId = navModel.columnId;
                self.page = 1;
                [self requestArticleDataWithId:navModel.columnId];
            }
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
    
    [HttpManager getWithURL:facultyTeam_Home andParams:nil returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.facultyTeamMutArr = [TeacherTeamModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"facultyTeamList"]];
            
            [self.tableView reloadData];
        }
    }];
    
    NSDictionary *activityParams = @{@"page":@"1",@"pageSize":@"5"};
    
    [HttpManager getWithURL:activityList_Home andParams:activityParams returnBlcok:^(NSError *error, id obj) {
        [self endRefreshing];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.activityMutArr = [ActityModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"activityList"]];
            [self.tableView reloadData];
        }
    }];
    
}

-(void)requestArticleDataWithId:(NSString *)columnId{
    
        [HttpManager getWithURL:indexQuestionList_Home andParams:@{@"token":User.token,@"page":@(_page),@"pageSize":@"10",@"columnId":columnId} returnBlcok:^(NSError *error, id obj) {
            [self endRefreshing];
            if ([SuccessInfo integerValue] == MSG_SUCCESS) {
                NSArray *souceArr = [ArticleModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"questionList"]];
                [self.dataArr addObjectsFromArray:souceArr];
                [self.tableView reloadData];
                if (souceArr.count <= 0) {
                    self->_page--;
                }
            }else{
                self->_page--;
                [self.tableView reloadData];
//                [MBProgressHUD showMessage:obj[dataKey]];
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

//头部添加选择控件
-(void)TopViewAddScrollUI{
    
    [self.topView.topNavView removeAllSubviews];
    
    self.navView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 20, KMainScreenWidth - 15*2, 32)];
    self.navView.bounces = NO;
    self.navView.showsVerticalScrollIndicator = NO;
    self.navView.showsHorizontalScrollIndicator = NO;
    self.navView.backgroundColor = JColorFromRGB(0xF5F5F5);
    self.navView.clipsToBounds = YES;
    self.navView.layer.cornerRadius = 16;
    
    btnStartAndEndX = 0.0;
    offSet = 0.0;
    allViewWidth = btnStartAndEndX*2.0;
    leftAndRightJianGe = 20.0;
    backViewWidth = KMainScreenWidth - 15*2;
    
    
    for (NSString *str in self.navArr) {
        float width = [str widthForFont:[UIFont systemFontOfSize:ScrollFontNum]] + leftAndRightJianGe*1.0;
        allViewWidth = allViewWidth + width;
    }
    
    allViewWidth = allViewWidth + leftAndRightJianGe;
    
    if (allViewWidth < backViewWidth) {
        offSet = (backViewWidth - allViewWidth)/self.navArr.count;
        allViewWidth = backViewWidth;
    }
    
    self.navView.contentSize = CGSizeMake(allViewWidth,32);
    
    float  totalWidth = 0;
    
    for (NSInteger i = 0; i < self.navArr.count; i++) {
        UIButton *navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [navBtn setBackgroundColor:[UIColor clearColor]];
        [navBtn setTitle:self.navArr[i] forState:UIControlStateNormal];
        navBtn.font = [UIFont systemFontOfSize:ScrollFontNum];
        [navBtn setTitleColor:JColorFromRGB(0x666666) forState:UIControlStateNormal];
        [navBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [navBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        NSString *str = self.navArr[i];
        CGFloat strWidth = [str widthForFont:[UIFont systemFontOfSize:ScrollFontNum]];
        
        navBtn.frame = CGRectMake(totalWidth + leftAndRightJianGe, 0, strWidth + offSet, 32);
        
        totalWidth = totalWidth + (strWidth + leftAndRightJianGe*1.0 + offSet);
        
        [navBtn addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
        navBtn.tag = 10 + i;
        
        NSInteger selectM = 0;
        if (self.selectInt < self.navArr.count) {
            selectM = self.selectInt;
        }
        
        if (i == selectM) {
            
            navBtn.selected = YES;
            [navBtn setFont:[UIFont systemFontOfSize:ScrollFontNum]];
            
            self.bottomNavLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, strWidth + leftAndRightJianGe*2.0 + offSet, 32)];
            self.bottomNavLine.clipsToBounds = YES;
            self.bottomNavLine.layer.cornerRadius = 16;
            self.bottomNavLine.backgroundColor = KNavColor;
            
//            CGSize LbSize = LabelSizeWithStr(self.navArr[i], CGSizeMake(KMainScreenWidth, 30), Attributes(15));
            
            //            navBtn.imageEdgeInsets = UIEdgeInsetsMake(0, ceil(LbSize.width) + ceil(LbSize.width)/2.0f , 0, 0);
            //            navBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ceil(LbSize.width)/2.0f - 20);
            
//            [self.bottomNavLine setWidth:ceil(LbSize.width) ];
            self.bottomNavLine.centerX = navBtn.centerX;
            [self.navView addSubview:self.bottomNavLine];
        }
        
        [self.navView addSubview:navBtn];
    }
    
    [self.topView.topNavView addSubview:self.navView];
    
}

-(void)navAction:(UIButton *)sender{
    
    for (NSInteger i = 0; i < self.navArr.count; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:10 + i];
        if (i == sender.tag - 10) {
            btn.selected = YES;
            
            OtherModel *navModel = self.navDataArr[i];
            self.selectInt = i;
            self.columnId = navModel.columnId;
            self.page = 1;
            [self.dataArr removeAllObjects];
            [self requestArticleDataWithId:navModel.columnId];
            
            [self scroollTopViewWithBtn:sender];
            
            CGFloat strWidth = [self.navArr[i] widthForFont:[UIFont systemFontOfSize:ScrollFontNum]];
            [UIView animateWithDuration:.25 animations:^{
//                CGSize LbSize = LabelSizeWithStr(self.navArr[i], CGSizeMake(KMainScreenWidth, 30), Attributes(15));
                
                [self.bottomNavLine setWidth:strWidth + self->leftAndRightJianGe*2.0 + self->offSet];
                self.bottomNavLine.centerX = btn.centerX ;
            }];
        }else{
            btn.selected = NO;
        }
    }
    
}

-(void)scroollTopViewWithBtn:(UIButton *)sender
{
    [self.navView scrollRectToVisible:CGRectMake(sender.x - (SCREEN_WIDTH -sender.width)/2.0, 0, KMainScreenWidth, self.navView.frame.size.height) animated:YES];
}

#pragma  tableView -- Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.dataArr.count - 1;
    }else if (section == 0){
        if (self.dataArr.count > 0) {
            return 1;
        }else{
            return 0;
        }
    } else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StudentsChooseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentsChooseTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArr.count > 0) {
            [cell refreshUI:[self.dataArr firstObject]];
        }
        return cell;
    }else if (indexPath.section == 1){
        StudentsHomeTeamTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentsHomeTeamTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nav = self.navigationController;
        [cell refreshUI:[self.facultyTeamMutArr copy]];
        return cell;
    }else if (indexPath.section == 2){
        StudentsHomeActivityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentsHomeActivityTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nav = self.navigationController;
        [cell refreshUI:[self.activityMutArr copy]];
        [cell.moreBtn addTarget:self action:@selector(moreActivityAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        StudentsChooseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentsChooseTableCell" forIndexPath:indexPath];
        cell.cancelFocusView.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArr.count > 1) {
            [cell refreshUI:self.dataArr[indexPath.row + 1]];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.dataArr.count <= 0) {
            return;
        }
        ArticleDetailViewController *articleVC = [ArticleDetailViewController new];
        articleVC.questionId = [[self.dataArr firstObject] questionId];
        [self.navigationController pushViewController:articleVC animated:YES];
    }else if (indexPath.section == 3) {
        if (self.dataArr.count <= 1) {
            return;
        }
        ArticleDetailViewController *articleVC = [ArticleDetailViewController new];
        articleVC.questionId = [self.dataArr[indexPath.row + 1] questionId];
        [self.navigationController pushViewController:articleVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 171;
    }else if(indexPath.section == 1){
        return 265;
    }else if (indexPath.section == 2){
        return 207;
    }else{
        return 136 + 15;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 54 - 15;
    }else{
    return CGFLOAT_MIN;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 3) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 54 - 15)];
        headView.backgroundColor = [UIColor whiteColor];
//        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
//        backView.backgroundColor = MainBackgroundColor;
//        [headView addSubview:backView];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 16, 4, 19)];
        imgView.image = [UIImage imageNamed:@"nav／icon／title备份"];
        [headView addSubview:imgView];
        UILabel *textLb = [[UILabel alloc]initWithFrame:CGRectMake(29, 15, 90, 22)];
        textLb.font = [UIFont boldSystemFontOfSize:17];
        textLb.textColor = JColorFromRGB(0x0C0C0C);
        textLb.text = @"热门知识";
        [headView addSubview:textLb];
        
        return headView;
    }else{
        
        return nil;
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
        headView.backgroundColor = MainBackgroundColor;
        return headView;
    }
    
}

#pragma mark - Event
-(void)moreActivityAction{
    ActivityListViewController *moreVC = [ActivityListViewController new];
    [self.navigationController pushViewController:moreVC animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    WebViewViewController *webVC = [WebViewViewController new];    
    webVC.titleStr = [self.bannerArr[index] bannerName];
    webVC.urlStr = [self.bannerArr[index] bannerUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - HomeTopViewDelegate
-(void)clickSearchAction{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
