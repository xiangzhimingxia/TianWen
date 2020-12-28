//
//  FootChooseView.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/12.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FootChooseDelegate <NSObject>

-(void)getBackText:(NSString *)text AndIsCancel:(BOOL)isCancel AndType:(NSInteger)typeNum;

@end

@interface FootChooseView : UIView

@property (nonatomic, weak) id<FootChooseDelegate>delegate;

kUI(NSArray, dataArr);

kAS(NSInteger, typeNum);

@end

NS_ASSUME_NONNULL_END
