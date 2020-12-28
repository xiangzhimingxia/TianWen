//
//  AskPicTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AskPicTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *firstPic;
@property (weak, nonatomic) IBOutlet UIButton *firstDeleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *secondPic;
@property (weak, nonatomic) IBOutlet UIButton *secondDeleteBtn;

@end

NS_ASSUME_NONNULL_END
