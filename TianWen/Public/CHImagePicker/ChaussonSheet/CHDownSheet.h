//
//  CHDownSheet.h
//
//
//  Created by Chausson on 14-7-19.
//  Copyright (c) 2014年 Chausson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDownSheetCell.h"
@protocol CHDownSheetDelegate <NSObject>
@optional
-(void)didSelectIndex:(NSInteger)index;
@end

@interface CHDownSheet : UIView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
   
}

-(id)initWithlist:(NSArray *)list height:(CGFloat)height;
- (void)showInView:(UIViewController *)Sview;
- (void)showInView:(UIViewController *)Sview andViewIsHidedNavigationBar:(id)HidTag;////从隐藏navigation的viewcontroller过来 手动上移位置

@property (nonatomic,assign) id <CHDownSheetDelegate> delegate;
@property (nonatomic ,strong) UITableView *view;

@property (nonatomic)BOOL isFeedAndNoCaiJianFlage;

@end


