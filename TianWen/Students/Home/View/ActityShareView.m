//
//  ActityShareView.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/2.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "ActityShareView.h"
#import "WXApi.h"

@implementation ActityShareView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.toBottomHeightConstant.constant = 205 + SafeAreaBottomHeight;
    
    if (![WXApi isWXAppInstalled]) {
        self.wechatLb.hidden = YES;
        self.wechatBtn.hidden = YES;
        self.circleLb.hidden = YES;
        self.circleFriendBtn.hidden = YES;
    }
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
