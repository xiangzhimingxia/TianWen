//
//  StudentsChooseTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/20.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentsChooseTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cancelFocusView;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *textLb;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

-(void)refreshUI:(ArticleModel *)model;

@end

NS_ASSUME_NONNULL_END
