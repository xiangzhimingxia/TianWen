//
//  StudentsChooseTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/20.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsChooseTableCell.h"

@implementation StudentsChooseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray *imgArr = @[@"bg_blue",@"bg_green",@"bg_yellow"];
    int a =  arc4random()%[imgArr count];
    NSString  *imgStr = [imgArr objectAtIndex:a];
    self.backImg.image = [UIImage imageNamed:imgStr];
}

-(void)refreshUI:(ArticleModel *)model{
    
    self.titleLb.text = model.questionName;
    self.textLb.text = model.indexContent;
    if ([model.isLike integerValue] == 1) {
        self.praiseBtn.selected = YES;
    }else{
        self.praiseBtn.selected = NO;
    }
    __weak typeof(self) weakSelf = self;
    [self.praiseBtn setTapActionWithBlock:^{
        [weakSelf postFocusWith:weakSelf.praiseBtn.isSelected WithBtn:weakSelf.praiseBtn WithId:model.questionId];
    }];
    
}

-(void)postFocusWith:(BOOL)isSelect WithBtn:(UIButton *)sender WithId:(NSString *)userID{
    sender.enabled = NO;
    [HttpManager postNotHeadWithURL:follow_Home andParams:@{@"token":User.token,@"followType":@"0",@"relationId":userID,@"relationType":@"0"} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            sender.enabled = YES;
            sender.selected = !isSelect;
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
