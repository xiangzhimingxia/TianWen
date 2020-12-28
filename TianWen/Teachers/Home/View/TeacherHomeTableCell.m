//
//  TeacherHomeTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/2.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TeacherHomeTableCell.h"

@implementation TeacherHomeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray *imgArr = @[@"bg_blue_question",@"bg_green_question",@"bg_yellow_question"];
    int a =  arc4random()%[imgArr count];
    NSString  *imgStr = [imgArr objectAtIndex:a];
    self.backImgView.image = [UIImage imageNamed:imgStr];
}

-(void)refreshUI:(OrderListModel *)model{
    self.titleLb.text = model.askTitle;
    self.timeLb.text = [NSString stringWithFormat:@"提问时间：%@",model.createTime];
    self.orderNumLb.text = [NSString stringWithFormat:@"订单编号：%@",model.orderId];
    self.levelLb.text = [NSString stringWithFormat:@"频道：%@ %@",model.gradeName,model.subjectName];
    self.nameLb.text = [NSString stringWithFormat:@"提问人：%@",model.realName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
