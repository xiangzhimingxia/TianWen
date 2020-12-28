//
//  AskTopView.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "AskTopView.h"

@implementation AskTopView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.uploadPicView.layer.cornerRadius = 6;
    self.uploadVocieView.layer.cornerRadius = 6;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
