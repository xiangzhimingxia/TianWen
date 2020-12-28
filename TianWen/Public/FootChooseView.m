//
//  FootChooseView.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/12.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "FootChooseView.h"

@interface FootChooseView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FootChooseView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - (54*(self.dataArr.count + 1) + self.dataArr.count - 1 + 5 + SafeAreaBottomHeight), self.frame.size.width, 54*(self.dataArr.count + 1) + self.dataArr.count - 1 + 5 + SafeAreaBottomHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = JColorFromRGB(0xEAEAEA);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.bounces = NO;
    [self addSubview:self.tableView];

    if (@available(iOS 11.0,*)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.tableView reloadData];
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self.tableView setFrame:CGRectMake(0, self.frame.size.height - (54*(self.dataArr.count + 1) + self.dataArr.count - 1 + 5 + SafeAreaBottomHeight), self.frame.size.width, 54*(self.dataArr.count + 1) + self.dataArr.count - 1 + 5 + SafeAreaBottomHeight)];
//    });
    
    
    
}


#pragma  tableView -- Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *footChooseIdentifier = @"footChooseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:footChooseIdentifier];
    
    UILabel *titleLb = [UILabel new];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footChooseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        titleLb.frame = CGRectMake(0, 0, self.frame.size.width, 54);
        titleLb.font = [UIFont systemFontOfSize:18];
        [titleLb setTextColor:TextBlackColor];
        [titleLb setTextAlignment:NSTextAlignmentCenter];
        [cell.contentView addSubview:titleLb];
    }
    if (indexPath.section < self.dataArr.count) {
        titleLb.text = self.dataArr[indexPath.section];
        [titleLb setTextColor:TextBlackColor];
    }else{
        titleLb.text = @"取消";
        [titleLb setTextColor:TextGrayColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getBackText:AndIsCancel:AndType:)]) {
        
        if (self.dataArr.count > 0) {
        
        if (indexPath.section < self.dataArr.count) {
            [self.delegate getBackText:self.dataArr[indexPath.section] AndIsCancel:NO AndType:self.typeNum];
        }else{
            [self.delegate getBackText:nil AndIsCancel:YES AndType:self.typeNum];
        }
            
        }else{
            [self.delegate getBackText:nil AndIsCancel:YES AndType:self.typeNum];
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.dataArr.count) {
        return 54;
    }else{
        return 54 + SafeAreaBottomHeight;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataArr.count - 1) {
        return 5;
    }else if (section == self.dataArr.count){
        return CGFLOAT_MIN;
    }else{
        return 1;
    }
}

@end
