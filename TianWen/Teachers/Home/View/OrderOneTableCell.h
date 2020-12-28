//
//  OrderOneTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/3.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderOneTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLb;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;

-(void)refreshUI:(OrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
