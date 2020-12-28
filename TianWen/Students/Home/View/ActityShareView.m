//
//  ActityShareView.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/2.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "ActityShareView.h"

@implementation ActityShareView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.toBottomHeightConstant.constant = 205 + SafeAreaBottomHeight;
}

- (IBAction)wechatAction:(id)sender {
    self.hidden = YES;
}

- (IBAction)circleAction:(id)sender {
    self.hidden = YES;
}

- (IBAction)cancelAction:(id)sender {
    self.hidden = YES;
}
@end
