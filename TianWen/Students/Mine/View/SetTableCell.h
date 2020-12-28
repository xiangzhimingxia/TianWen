//
//  SetTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/28.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *textLb;

@end

NS_ASSUME_NONNULL_END
