//
//  TeacherTopTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherTeamModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SecondRBlock)(void);

@interface TeacherTopTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *answerNumLb;
@property (weak, nonatomic) IBOutlet UILabel *evaluationNumLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLengthLb;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@property (nonatomic, copy) SecondRBlock block;

-(void)refreshUI:(TeacherTeamModel *)model;
@end

NS_ASSUME_NONNULL_END
