//
//  ActivityListTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "ActivityListTableCell.h"

@implementation ActivityListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSArray *imgArr = @[@"FFECF9",@"D9F7EA",@"FFEEC3",@"D0F9FF"];
    int a =  arc4random()%[imgArr count];
    NSString  *imgStr = [imgArr objectAtIndex:a];
    self.backView.backgroundColor = SYHEXCOLOR(imgStr);
    
    NSArray *imgArr1 = @[@"FF4D76",@"01D496",@"FE9C1F",@"39C8F7"];
    int b =  arc4random()%[imgArr1 count];
    NSString  *imgStr1 = [imgArr1 objectAtIndex:b];
    self.titleVerticalView.backgroundColor = SYHEXCOLOR(imgStr1);
    
}

-(void)refreshUI:(ActityModel *)model{
    
    self.titleLb.text = model.activityName;
    switch ([model.participateType integerValue]) {
        case 0:
            self.signTypeLb.text = @"参与人：所有用户";
            break;
        case 1:
            self.signTypeLb.text = @"参与人：学生";
            break;
        case 2:
            self.signTypeLb.text = @"参与人：教师";
            break;
            
        default:
            break;
    }
    self.signNumLb.text = [NSString stringWithFormat:@"目前报名人数：%@",model.participateCount];
    self.timeLb.text = [NSString stringWithFormat:@"报名截止时间：%@",model.participateTime];
    
    switch ([model.activityStatus integerValue]) {
        case 1:
            self.stateLb.text = @"报名中";
            self.stateImg.image = [UIImage imageNamed:@"tag1"];
            break;
        case 2:
            self.stateLb.text = @"投票中";
            self.stateImg.image = [UIImage imageNamed:@"tag2"];
            break;
        case 3:
            self.stateLb.text = @"已结束";
            self.stateImg.image = [UIImage imageNamed:@"tag3"];
            break;
            
        default:
            break;
    }
    
    [self.imgView setImageURL:[NSURL URLWithString:model.activityPic]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
