//
//  StudentsOrderListTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentsOrderListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UILabel *stateLb;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLb;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *questionNumLb;
@property (weak, nonatomic) IBOutlet UILabel *paiseNumLb;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyHoldLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;

-(void)refreshUI:(OrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
