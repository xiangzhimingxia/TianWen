//
//  OrderHaveEvaluationTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderHaveEvaluationTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *xin1;
@property (weak, nonatomic) IBOutlet UIImageView *xin2;
@property (weak, nonatomic) IBOutlet UIImageView *xin3;
@property (weak, nonatomic) IBOutlet UIImageView *xin4;
@property (weak, nonatomic) IBOutlet UIImageView *xin5;
@property (weak, nonatomic) IBOutlet UILabel *evalutionLb;
@property (weak, nonatomic) IBOutlet UILabel *pariseLb;

-(void)refreshUI:(OrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
