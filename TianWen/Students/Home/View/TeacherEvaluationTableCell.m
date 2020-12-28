//
//  TeacherEvaluationTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TeacherEvaluationTableCell.h"

@implementation TeacherEvaluationTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshUI:(EvaluationModel *)model{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headPic] placeholderImage:[UIImage imageNamed:@"holdHeader"]];
    self.nameLb.text = model.realName;
    self.timeLb.text = model.createTime;
    self.contentLb.text = model.content;
    self.xin1.hidden = YES;
    self.xin2.hidden = YES;
    self.xin3.hidden = YES;
    self.xin4.hidden = YES;
    self.xin5.hidden = YES;
    switch ([model.score integerValue]) {
        case 1:
        {
            self.xin1.hidden = NO;
        }
            break;
        case 2:
        {
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
        }
            break;
        case 3:
        {
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
            self.xin3.hidden = NO;
        }
            break;
        case 4:
        {
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
            self.xin3.hidden = NO;
            self.xin4.hidden = NO;
        }
            break;
        case 5:
        {
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
            self.xin3.hidden = NO;
            self.xin4.hidden = NO;
            self.xin5.hidden = NO;
        }
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
