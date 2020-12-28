//
//  FunctionTableViewCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FunctionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *explainBtn;
@property (weak, nonatomic) IBOutlet UIButton *ordersBtn;
@property (weak, nonatomic) IBOutlet UILabel *explainLb;
@property (weak, nonatomic) IBOutlet UILabel *orderLb;
@property (weak, nonatomic) IBOutlet UILabel *focusLb;

@end

NS_ASSUME_NONNULL_END
