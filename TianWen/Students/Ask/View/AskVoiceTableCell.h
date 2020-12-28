//
//  AskVoiceTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AskVoiceTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vocieView;
@property (weak, nonatomic) IBOutlet UILabel *vocieLb;
@property (weak, nonatomic) IBOutlet UIImageView *vocieImg;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toLeftBackViewWidthConstant;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

-(void)refreshUI:(UploadModel *)model;

@end

NS_ASSUME_NONNULL_END
