//
//  OrderCostTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "OrderCostTableCell.h"

@implementation OrderCostTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshUI:(OrderListModel *)model{
    
    if ([model.orderStatus integerValue] == 3 || [model.orderStatus integerValue] == 2) {
        self.typeHoldLb.hidden = NO;
        self.typeLb.hidden = NO;
        self.typeHoldLb.text = @"已付费用：";
    }else{
        self.typeHoldLb.hidden = YES;
        self.typeLb.hidden = YES;
        self.typeHoldLb.text = @"待付费用：";
    }
    
    if ([model.answerType integerValue] == 3 && ([model.orderStatus integerValue] == 3 || [model.orderStatus integerValue] == 2)) {
        self.videoView.hidden = NO;
    }else{
        self.videoView.hidden = YES;
    }
    
    self.timeLb.text = model.answerDuration;
    self.moneyLb.text = model.orderPrice;
    switch ([model.payType integerValue]) {
        case 1:
            self.typeLb.text = @"微信支付";
            break;
        case 2:
            self.typeLb.text = @"支付宝支付";
            break;
        case 3:
            self.typeLb.text = @"余额支付";
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
