//
//  StudentsFocusTeacherTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/26.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsFocusTeacherTableCell.h"

@implementation StudentsFocusTeacherTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshUI:(TeacherTeamModel *)model{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headPic] placeholderImage:[UIImage imageNamed:@"holdHeader"]];
    self.nameLb.text = model.realName;
    self.levelLb.text = model.qualificationsName;
    self.subjectLb.text = model.subjectName;
    self.schoolLb.text = model.school;
    self.levelWidthConstant.constant = [model.qualificationsName widthForFont:[UIFont systemFontOfSize:10]] + 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
