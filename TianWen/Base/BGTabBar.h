//
//  BGTabBar.h
//  BoardGame
//
//  Created by 张享 on 16/3/9.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BGTabBar;
@protocol BGTabBarDelegate <UITabBarDelegate>
@optional
- (void)tabBarDidClickPlusButton:(BGTabBar *)tabBar;
@end

@interface BGTabBar : UITabBar
@property (nonatomic,weak) id<BGTabBarDelegate> delegate;
@property (nonatomic,weak) UIButton *plusBtn;
@end
