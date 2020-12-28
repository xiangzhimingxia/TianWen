//
//  HomeTeamCollectionCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "HomeTeamCollectionCell.h"

@implementation HomeTeamCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.backView.layer.cornerRadius = 6;
    
    NSArray *imgArr = @[@"FFB85C",@"49CA6D",@"009EE0"];
    int a =  arc4random()%[imgArr count];
    NSString  *imgStr = [imgArr objectAtIndex:a];
    self.backView.backgroundColor = SYHEXCOLOR(imgStr);
}

-(void)refreshUI:(TeacherTeamModel *)model{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headPic]];
    self.nameLb.text = model.realName;
    self.levelLb.text = model.qualificationsName;
    self.schoolLb.text = model.school;
    self.subjectsLb.text = model.subjectName;
}

@end
