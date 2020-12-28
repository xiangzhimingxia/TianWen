//
//  StudentsOrderListTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsOrderListTableCell.h"

@implementation StudentsOrderListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.finishBtn.layer.borderWidth = 1;
    self.finishBtn.layer.borderColor = KNavColor.CGColor;
}

-(void)refreshUI:(OrderListModel *)model{
    self.finishBtn.hidden = NO;
    if ([model.orderStatus integerValue] == 4) {
        self.stateLb.text = @"已取消";
        self.stateLb.textColor = TextRedColor;
        self.moneyLb.hidden = YES;
        self.moneyHoldLb.hidden = YES;
        [self.finishBtn setTitle:@"重新下单" forState:UIControlStateNormal];

    }else if ([model.orderStatus integerValue] == 1) {
        self.stateLb.text = @"已完成";
        self.stateLb.textColor = JColorFromRGB(0x009EE0);
        self.moneyLb.hidden = NO;
        self.moneyHoldLb.hidden = NO;
        [self.finishBtn setTitle:@"立即付款" forState:UIControlStateNormal];
    }else if ([model.orderStatus integerValue] == 2) {
        self.stateLb.text = @"已付款";
        self.stateLb.textColor = JColorFromRGB(0xFFB85C);
        self.moneyLb.hidden = NO;
        self.moneyHoldLb.hidden = NO;
        [self.finishBtn setTitle:@"立即评价" forState:UIControlStateNormal];
    }else if ([model.orderStatus integerValue] == 3) {
        self.stateLb.text = @"已评价";
        self.stateLb.textColor = JColorFromRGB(0x9C9C9C);
        self.moneyLb.hidden = NO;
        self.moneyHoldLb.hidden = NO;
        self.finishBtn.hidden = YES;
    }
    
    self.orderNumLb.text = [NSString stringWithFormat:@"订单编号：%@",model.orderId];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headPic]];
    self.nameLb.text = model.realName;
    NSString *typeStr = @"";
    if (model.answerType.length > 0) {
        switch ([model.answerType integerValue]) {
            case 1:
                typeStr = @"语音解答";
                break;
            case 2:
                typeStr = @"视频解答";
                break;
            case 3:
                typeStr = @"白板解答";
                break;
                
            default:
                break;
        }
    }
    self.levelLb.text = [NSString stringWithFormat:@"%@  %@  %@",model.gradeName,model.subjectName,typeStr];
    self.creatTimeLb.text = [NSString stringWithFormat:@"解答时间：%@",model.answerTime];
    self.questionNumLb.text = [NSString stringWithFormat:@"解答次数：%@",model.answerCount];
    self.paiseNumLb.text = [NSString stringWithFormat:@"满意次数：%@",model.satisfiedCount];
    self.moneyLb.text = [NSString stringWithFormat:@"￥%@",model.orderPrice];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
