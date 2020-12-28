//
//  TeacherOrderListTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/12.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TeacherOrderListTableCell.h"

@implementation TeacherOrderListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shareBtn.layer.borderWidth = 1;
    self.shareBtn.layer.borderColor = KNavColor.CGColor;
    self.lastBtn.layer.borderWidth = 1;
    self.lastBtn.layer.borderColor = KNavColor.CGColor;
}

-(void)refreshUI:(OrderListModel *)model{
    self.bottomView.hidden = NO;
    if ([model.orderStatus integerValue] == 0) {
        self.stateLb.text = @"未接单";
        self.stateLb.textColor = TextRedColor;
        self.bottomView.hidden = YES;
    }else if ([model.orderStatus integerValue] == 1) {
        self.stateLb.text = @"已完成";
        self.stateLb.textColor = JColorFromRGB(0x009EE0);
        self.lastBtn.hidden = NO;
        self.shareToRightwidthConstant.constant = 107;
    }else if ([model.orderStatus integerValue] == 2) {
        self.stateLb.text = @"已付款";
        self.stateLb.textColor = JColorFromRGB(0xFFB85C);
        self.lastBtn.hidden = YES;
        self.shareToRightwidthConstant.constant = 15;
    }else if ([model.orderStatus integerValue] == 3) {
        self.stateLb.text = @"已评价";
        self.stateLb.textColor = KNavColor;
        self.lastBtn.hidden = YES;
        self.shareToRightwidthConstant.constant = 15;
    }
    
    self.orderNumLb.text = [NSString stringWithFormat:@"订单编号：%@",model.orderId];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headPic]];
    self.nameLb.text = model.realName;
    self.titleLb.text = model.askTitle;
    self.levelLb.text = [NSString stringWithFormat:@"%@ %@",model.gradeName,model.subjectName];
    self.creatTimeLb.text = [NSString stringWithFormat:@"提问时间：%@",model.createTime];
    self.timeLengthLb.text = [NSString stringWithFormat:@"解答时长：%@",model.answerDuration];
    self.moneyLb.text = [NSString stringWithFormat:@"￥%@",model.orderPrice];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
