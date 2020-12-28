//
//  TeacherTopTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TeacherTopTableCell.h"

@implementation TeacherTopTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshUI:(TeacherTeamModel *)model{
    if ([model.isFollow integerValue] == 1) {
        self.focusBtn.selected = YES;
    }else{
        self.focusBtn.selected = NO;
    }
    __weak typeof(self) weakSelf = self;
    [self.focusBtn setTapActionWithBlock:^{
        [weakSelf postFocusWith:weakSelf.focusBtn.isSelected WithBtn:weakSelf.focusBtn WithId:model.userId];
    }];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headPic] placeholderImage:[UIImage imageNamed:@"holdHeader"]];
    self.answerNumLb.text = model.answerCount;
    self.evaluationNumLb.text = model.evaluateCount;
    self.timeLengthLb.text = model.answerDuration;
}

-(void)postFocusWith:(BOOL)isSelect WithBtn:(UIButton *)sender WithId:(NSString *)userID{
    sender.enabled = NO;
    [HttpManager postNotHeadWithURL:follow_Home andParams:@{@"token":User.token,@"followType":@"1",@"relationId":userID,@"relationType":@"1"} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            sender.enabled = YES;
            sender.selected = !isSelect;
            if (self.block) {
                self.block();
            }
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
