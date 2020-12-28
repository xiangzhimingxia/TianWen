//
//  TeacherEvaluationTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeacherEvaluationTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIImageView *xin1;
@property (weak, nonatomic) IBOutlet UIImageView *xin2;
@property (weak, nonatomic) IBOutlet UIImageView *xin3;
@property (weak, nonatomic) IBOutlet UIImageView *xin4;
@property (weak, nonatomic) IBOutlet UIImageView *xin5;

-(void)refreshUI:(EvaluationModel *)model;

@end

NS_ASSUME_NONNULL_END
