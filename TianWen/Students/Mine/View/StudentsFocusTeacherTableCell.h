//
//  StudentsFocusTeacherTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/26.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherTeamModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentsFocusTeacherTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIView *cancelFocusView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;
@property (weak, nonatomic) IBOutlet UILabel *schoolLb;
@property (weak, nonatomic) IBOutlet UILabel *subjectLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelWidthConstant;

-(void)refreshUI:(TeacherTeamModel *)model;

@end

NS_ASSUME_NONNULL_END
