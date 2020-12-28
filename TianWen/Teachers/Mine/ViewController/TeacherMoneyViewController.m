//
//  TeacherMoneyViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/7.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TeacherMoneyViewController.h"
#import "StudentsMoneyRecordTableCell.h"
#import "WithdrawalViewController.h"
#import "BindingViewController.h"

@interface TeacherMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;

@end

@implementation TeacherMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

-(void)creatUI{
    
    self.titleLable.text = @"束脩";
    
    self.toTopHeightConstant.constant = SafeAreaTopHeight + 16;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 256, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 256) style:UITableViewStyleGrouped];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StudentsMoneyRecordTableCell" bundle:nil] forCellReuseIdentifier:@"StudentsMoneyRecordTableCell"];
    
}

#pragma mark - Event

- (IBAction)chargeAction:(id)sender {
    WithdrawalViewController *vc= [WithdrawalViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)myAlipayAction:(id)sender {
    BindingViewController *vc = [BindingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)backCardAction:(id)sender {
    BindingViewController *vc = [BindingViewController new];
    vc.isBank = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  tableView -- Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StudentsMoneyRecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentsMoneyRecordTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.stateLb.hidden = NO;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

@end
