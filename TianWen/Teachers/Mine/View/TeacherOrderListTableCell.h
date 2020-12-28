//
//  TeacherOrderListTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/12.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeacherOrderListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UILabel *stateLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLb;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLengthLb;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareToRightwidthConstant;

-(void)refreshUI:(OrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
