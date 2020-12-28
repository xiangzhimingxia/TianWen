//
//  StudentsHomeTeamTableCell.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudentsHomeTeamTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;

@property (nonatomic, strong) UINavigationController * nav;

@property (nonatomic, strong) NSArray * dataArr;

-(void)refreshUI:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
