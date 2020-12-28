//
//  ReceiveLiveView.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/20.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "ReceiveLiveView.h"

@implementation ReceiveLiveView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.holdImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.holdImg.layer.borderWidth = 2;
}

@end
