//
//  StudentsMineTopView.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsMineTopView.h"

@implementation StudentsMineTopView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.headImg.layer.cornerRadius = 40;
    self.headImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImg.layer.borderWidth = 2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
