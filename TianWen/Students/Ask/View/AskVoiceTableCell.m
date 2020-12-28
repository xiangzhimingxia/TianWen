//
//  AskVoiceTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "AskVoiceTableCell.h"
#import "CXAudioPlayer.h"

@implementation AskVoiceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.vocieView.layer.cornerRadius  = 16;
    self.vocieView.layer.borderColor = JColorFromRGB(0x49CA6D).CGColor;
    self.vocieView.layer.borderWidth = 1;
}

-(void)refreshUI:(UploadModel *)model{
    
    self.vocieLb.text = model.fileSize;
    
    [self.vocieView setTapActionWithBlock:^{
        [CXAudioPlayer sharedInstance].playUrlStr = model.fileUrl;
        [[CXAudioPlayer sharedInstance] play];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
