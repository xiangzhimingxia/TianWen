//
//  ActivityListTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityListTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIView *titleVerticalView;
@property (weak, nonatomic) IBOutlet UILabel *signTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *signNumLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *stateLb;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;

-(void)refreshUI:(ActityModel *)model;

@end

NS_ASSUME_NONNULL_END
