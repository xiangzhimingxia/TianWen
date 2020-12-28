//
//  ActivityDetailsViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/2.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import "ActityShareView.h"
#import "ActivityDetailsOneCell.h"
#import "ActivityDetailsTwoTableCell.h"
#import "ActivityDetailsThreeTableCell.h"
#import "ActivityDetailsThreeTopTableCell.h"
#import "ActivityDetailsFourTableCell.h"

@interface ActivityDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *topView;

kUI(UIImageView, topImgView);

kUI(UIButton, shareBtn);

@property (nonatomic, strong) ActityShareView *shareView;

@end

@implementation ActivityDetailsViewController

-(ActityShareView *)shareView{
    if (!_shareView) {
        _shareView = [[[NSBundle mainBundle]loadNibNamed:@"ActityShareView" owner:self options:nil] lastObject];
        _shareView.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight + SafeAreaBottomHeight);
//        [_shareView.cancelBtn addTarget:self action:@selector(shareCancel) forControlEvents:UIControlEventTouchUpInside];
        UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
        [keyWin addSubview:_shareView];
        _shareView.hidden = YES;
    }
    return _shareView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityDetailsOneCell" bundle:nil] forCellReuseIdentifier:@"ActivityDetailsOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityDetailsTwoTableCell" bundle:nil] forCellReuseIdentifier:@"ActivityDetailsTwoTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityDetailsThreeTopTableCell" bundle:nil] forCellReuseIdentifier:@"ActivityDetailsThreeTopTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityDetailsThreeTableCell" bundle:nil] forCellReuseIdentifier:@"ActivityDetailsThreeTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityDetailsFourTableCell" bundle:nil] forCellReuseIdentifier:@"ActivityDetailsFourTableCell"];
    
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 160)];
    
    self.topImgView = [[UIImageView alloc]init];
    self.topImgView.frame = CGRectMake(0, 0, KMainScreenWidth, 160);
    self.topImgView.image = [UIImage imageNamed:@"banner"];
    [self.topView addSubview:self.topImgView];
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareBtn setTitle:@"" forState:UIControlStateNormal];
    [self.shareBtn setImage:[UIImage imageNamed:@"content_icon_share_white"] forState:UIControlStateNormal];
    self.shareBtn.frame = CGRectMake(KMainScreenWidth - 20 - 50, 110, 50, 50);
    [self.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.shareBtn];
    
    self.tableView.tableHeaderView = self.topView;
}

-(void)shareAction:(UIButton *)sender{
    self.shareView.hidden = NO;
}

#pragma  tableView -- Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isType == 1) {
        return 4;
    }else{
    return 3;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isType == 1) {
        if (section == 2) {
            return 3;
        }else if(section == 3){
            return 4;
        }{
            return 1;
        }
    }else{
        if (section == 2) {
            return 4;
        }else{
            return 1;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ActivityDetailsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailsOneCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        return cell;
    }else if (indexPath.section ==1){
        
        ActivityDetailsTwoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailsTwoTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        return cell;
    }else if(indexPath.section == 2){
        
        if (self.isType == 1) {
            if (indexPath.row == 0) {
                ActivityDetailsThreeTopTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailsThreeTopTableCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = MainBackgroundColor;
                return cell;
            }else{
                ActivityDetailsThreeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailsThreeTableCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = MainBackgroundColor;
                return cell;
            }
        }else{
            ActivityDetailsFourTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailsFourTableCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = MainBackgroundColor;
            return cell;
        }
        
    }else{
        ActivityDetailsFourTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailsFourTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        return cell;
    }
        
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 46;
    }else if (indexPath.section == 1){
        return 290;
    }else if(indexPath.section == 2){
        if (self.isType == 1) {
            if (indexPath.row == 0) {
                return 51;
            }else{
                return 47;
            }
        }else{
            return 245;
        }
    }else{
        return 245;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isType == 1) {
        if (section == 3) {
            return 56;
        }else{
            return 15;
        }
    }else{
        if (section == 2) {
            return 56;
        }else{
            return 15;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isType == 1) {
        if (section == 3) {
            UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 56)];
            tagView.backgroundColor = MainBackgroundColor;
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tag_orange"]];
            img.frame = CGRectMake(15, 15, 120, 32);
            [tagView addSubview:img];
            return tagView;
        }else{
            UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
            tagView.backgroundColor = MainBackgroundColor;
            return tagView;
        }
    }else{
        if (section == 2) {
            UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 56)];
            tagView.backgroundColor = MainBackgroundColor;
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tag_orange"]];
            img.frame = CGRectMake(15, 15, 120, 32);
            [tagView addSubview:img];
            return tagView;
        }else{
            UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
            tagView.backgroundColor = MainBackgroundColor;
            return tagView;
        }
    }
}

@end
