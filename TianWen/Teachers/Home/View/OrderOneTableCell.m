//
//  OrderOneTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/3.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "OrderOneTableCell.h"

@implementation OrderOneTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dataView.layer.borderColor = JColorFromRGB(0xA3E3C7).CGColor;
    self.dataView.layer.borderWidth = 3;
    
}

-(void)refreshUI:(OrderListModel *)model{
    self.levelLb.text = [NSString stringWithFormat:@"%@ %@",model.gradeName,model.subjectName];
    self.orderNumLb.text = model.orderId;
    self.titleLb.text = model.askTitle;
    self.nameLb.text = model.questionName;
    switch ([model.answerType integerValue]) {
        case 1:
            self.typeLb.text = @"语音解答";
            break;
        case 2:
            self.typeLb.text = @"视频解答";
            break;
        case 3:
            self.typeLb.text = @"白板解答";
            break;
        default:
            self.typeLb.text = @"";
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
