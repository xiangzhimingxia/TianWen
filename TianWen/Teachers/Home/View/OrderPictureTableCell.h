//
//  OrderPictureTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/7.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderPictureTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeImg;

@end

NS_ASSUME_NONNULL_END
