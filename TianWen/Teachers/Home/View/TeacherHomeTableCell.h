//
//  TeacherHomeTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/2.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeacherHomeTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

-(void)refreshUI:(OrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
