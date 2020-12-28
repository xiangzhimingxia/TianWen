//
//  IntegralTableViewCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "IntegralTableViewCell.h"

@implementation IntegralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.backView.layer.cornerRadius = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
