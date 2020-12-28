//
//  TeacherOrderDetailsViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TeacherOrderDetailsViewController.h"
#import "OrderListModel.h"
#import "OrderOneTableCell.h"
#import "AskVoiceTableCell.h"
#import "OrderTwoTableCell.h"
#import "OrderPictureTableCell.h"
#import "OrderCostTableCell.h"
#import "OrderHaveEvaluationTableCell.h"

@interface TeacherOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

kUI(UIButton, answerBtn);
kUI(OrderListModel, detailsModel);
kUI(NSMutableArray, imgMutArr);
kUI(NSMutableArray, recordMutArr);

@end

@implementation TeacherOrderDetailsViewController

-(NSMutableArray *)recordMutArr{
    if (!_recordMutArr) {
        _recordMutArr = [NSMutableArray new];
    }
    return _recordMutArr;
}
-(NSMutableArray *)imgMutArr{
    if (!_imgMutArr) {
        _imgMutArr = [NSMutableArray new];
    }
    return _imgMutArr;
}
-(OrderListModel *)detailsModel{
    if (!_detailsModel) {
        _detailsModel = [OrderListModel new];
    }
    return _detailsModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self requestData];
}

-(void)creatUI{
    
    self.titleLable.text = @"订单详情";
        
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderOneTableCell" bundle:nil] forCellReuseIdentifier:@"OrderOneTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AskVoiceTableCell" bundle:nil] forCellReuseIdentifier:@"AskVoiceTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderTwoTableCell" bundle:nil] forCellReuseIdentifier:@"OrderTwoTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderPictureTableCell" bundle:nil] forCellReuseIdentifier:@"OrderPictureTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderCostTableCell" bundle:nil] forCellReuseIdentifier:@"OrderCostTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderHaveEvaluationTableCell" bundle:nil] forCellReuseIdentifier:@"OrderHaveEvaluationTableCell"];
    
    
    UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 150)];
    footView.backgroundColor = MainBackgroundColor;
    
    if ([self.orderStatus integerValue] == 1) {
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setTitle:@"分享好友" forState:UIControlStateNormal];
        [shareBtn setFont:[UIFont systemFontOfSize:14]];
        [shareBtn setTitleColor:KNavColor forState:UIControlStateNormal];
        shareBtn.backgroundColor = [UIColor whiteColor];
        shareBtn.frame = CGRectMake(30, 50, (KMainScreenWidth - 30*2 - 33)/2, 50);
        shareBtn.clipsToBounds = YES;
        shareBtn.layer.cornerRadius = 20;
        shareBtn.layer.borderColor = KNavColor.CGColor;
        shareBtn.layer.borderWidth = 1;
        [footView addSubview:shareBtn];
        
        UIButton *warnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [warnBtn setTitle:@"催促付款" forState:UIControlStateNormal];
        [warnBtn setFont:[UIFont systemFontOfSize:14]];
        [warnBtn setTitleColor:KNavColor forState:UIControlStateNormal];
        warnBtn.backgroundColor = [UIColor whiteColor];
        warnBtn.frame = CGRectMake(30 + (KMainScreenWidth - 30*2 - 33)/2 + 33, 50, (KMainScreenWidth - 30*2 - 33)/2, 50);
        warnBtn.clipsToBounds = YES;
        warnBtn.layer.cornerRadius = 20;
        warnBtn.layer.borderColor = KNavColor.CGColor;
        warnBtn.layer.borderWidth = 1;
        [footView addSubview:warnBtn];
        
    }else{
    
    self.answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.answerBtn setTitle:@"分享" forState:UIControlStateNormal];
    [self.answerBtn setFont:[UIFont systemFontOfSize:18]];
    [self.answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.answerBtn.backgroundColor = KNavColor;
    self.answerBtn.frame = CGRectMake(35, 50, KMainScreenWidth - 35*2, 50);
    self.answerBtn.clipsToBounds = YES;
    self.answerBtn.layer.cornerRadius = 25;
    self.answerBtn.userInteractionEnabled = NO;
    [footView addSubview:self.answerBtn];
    }
    self.tableView.tableFooterView = footView;
    
}

-(void)requestData{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager getWithURL:orderDetails_Home andParams:@{@"orderId":self.orderId} returnBlcok:^(NSError *error, id obj) {
        //        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.detailsModel = [OrderListModel mj_objectWithKeyValues:obj[dataKey][@"orderDetails"]];
            [self sortData];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
    
}

-(void)sortData{
    for (NSInteger i = 0; i<self.detailsModel.orderFileList.count; i++) {
        UploadModel *model = self.detailsModel.orderFileList[i];
        if ([model.fileType integerValue] == 1) {
            [self.imgMutArr addObject:model];
        }else if ([model.fileType integerValue] == 2){
            [self.recordMutArr addObject:model];
        }
    }
    [self.tableView reloadData];
    self.answerBtn.userInteractionEnabled = YES;
}

#pragma  tableView -- Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.orderStatus integerValue] == 0) {
        return 2;
    }else if ([self.orderStatus integerValue] == 3){
        return 4;
    }else{
        return 3;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        if (self.imgMutArr.count%3 == 0) {
            return 1 + self.recordMutArr.count + self.imgMutArr.count/3;
        }else{
            return 1 + self.recordMutArr.count + self.imgMutArr.count/3 + 1;
        }
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        OrderOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderOneTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;        
        [cell refreshUI:self.detailsModel];
        return cell;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            OrderTwoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTwoTableCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = MainBackgroundColor;
            cell.textLb.text = self.detailsModel.describe;
            return cell;
        }else if (indexPath.row >= 1 + self.recordMutArr.count){
            OrderPictureTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPictureTableCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            cell.secondImg.hidden = NO;
            cell.threeImg.hidden = NO;
            [cell.firstImg sd_setImageWithURL:[NSURL URLWithString:[self.imgMutArr[(indexPath.row - 1 - self.recordMutArr.count)*3] fileUrl]]];
            if (self.imgMutArr.count > (indexPath.row - 1 - self.recordMutArr.count)*3 + 1) {
                [cell.secondImg sd_setImageWithURL:[NSURL URLWithString:[self.imgMutArr[(indexPath.row - 1 - self.recordMutArr.count)*3 + 1] fileUrl]]];
            }
            if (self.imgMutArr.count > (indexPath.row - 1 - self.recordMutArr.count)*3 + 2) {
                [cell.threeImg sd_setImageWithURL:[NSURL URLWithString:[self.imgMutArr[(indexPath.row - 1 - self.recordMutArr.count)*3 + 2] fileUrl]]];
            }
            
            if (self.imgMutArr.count%3 == 0) {
                
            }else if (self.imgMutArr.count%3 == 1){
                cell.secondImg.hidden = YES;
                cell.threeImg.hidden = YES;
            }else if (self.imgMutArr.count%3 == 2){
                cell.threeImg.hidden = YES;
            }
            
            return cell;
        } else{
            AskVoiceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AskVoiceTableCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = MainBackgroundColor;
            cell.backView.backgroundColor = [UIColor whiteColor];
            cell.toLeftBackViewWidthConstant.constant = 15;
            [cell refreshUI:self.recordMutArr[indexPath.row - 1]];
            return cell;
        }
    }else if(indexPath.section == 2){
        OrderCostTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCostTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell refreshUI:self.detailsModel];
        return cell;
    }else{
        OrderHaveEvaluationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHaveEvaluationTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell refreshUI:self.detailsModel];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==  0) {
        return 170;
    }else if (indexPath.section ==  1){
        if (indexPath.row == 0) {
            if (self.detailsModel.describe.length > 0) {
                return 60 + [self.detailsModel.describe heightForFont:[UIFont systemFontOfSize:15] width:KMainScreenWidth - 30*2];
            }else{
                return 60;
            }
        }else if (indexPath.row >= 1 + self.recordMutArr.count){
            return 85;
        }else{
            return 42;
        }
    }else if (indexPath.section == 2){
        if ([self.orderStatus integerValue] == 2 || [self.orderStatus integerValue] == 3) {
            return 108;
        }else{
            return 80;
        }
    }else{
        return 108;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

@end
