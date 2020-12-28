//
//  OrderCostTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderCostTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyHoldLb;
@property (weak, nonatomic) IBOutlet UILabel *typeHoldLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;

-(void)refreshUI:(OrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
