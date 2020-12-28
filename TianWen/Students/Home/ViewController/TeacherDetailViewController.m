//
//  TeacherDetailViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TeacherDetailViewController.h"
#import "TeacherDetailTeaTableCell.h"
#import "TeacherTopTableCell.h"
#import "TeacherEvaluationTableCell.h"
#import "AfterClassModel.h"

@interface TeacherDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

kUI(AfterClassModel, classModel);
kUI(NSMutableArray, evaluationMutArr);

@end

@implementation TeacherDetailViewController

-(NSMutableArray *)evaluationMutArr{
    if (!_evaluationMutArr) {
        _evaluationMutArr = [NSMutableArray array];
    }
    return _evaluationMutArr;
}
-(AfterClassModel *)classModel{
    if (!_classModel) {
        _classModel = [AfterClassModel new];
    }
    return _classModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    [self requestData];
}

-(void)creatUI{
    
    self.titleLable.text = self.titleStr;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
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
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TeacherTopTableCell" bundle:nil] forCellReuseIdentifier:@"TeacherTopTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TeacherDetailTeaTableCell" bundle:nil] forCellReuseIdentifier:@"TeacherDetailTeaTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TeacherEvaluationTableCell" bundle:nil] forCellReuseIdentifier:@"TeacherEvaluationTableCell"];
    
}

-(void)requestData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager getWithURL:facultyTeamDetails_Home andParams:@{@"token":User.token,@"userId":self.userId} returnBlcok:^(NSError *error, id obj) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.classModel = [AfterClassModel mj_objectWithKeyValues:obj[dataKey]];
            [self.tableView reloadData];
        }else
        {
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
    
}

#pragma  tableView -- Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.classModel.userEvaluateList.count;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        TeacherTopTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherTopTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        [cell refreshUI:self.classModel.facultyTeamDetails];
        __weak typeof(self) weakSelf = self;
        cell.block = ^{
            if (weakSelf.block) {
                weakSelf.block();
            }
        };
        return cell;
    }else if (indexPath.section ==1){
        
        TeacherDetailTeaTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherDetailTeaTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        cell.contentLb.text = self.classModel.facultyTeamDetails.describe;
        return cell;
    }else{
        TeacherEvaluationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherEvaluationTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        [cell refreshUI:self.classModel.userEvaluateList[indexPath.row]];
        return cell;
    }
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 128;
    }else if (indexPath.section == 1){
        return 50 + [self.classModel.facultyTeamDetails.describe heightForFont:[UIFont systemFontOfSize:14] width:KMainScreenWidth - 30*2];
    }else{
        return 120;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

@end
