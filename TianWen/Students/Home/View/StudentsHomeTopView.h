//
//  StudentsHomeTopView.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/19.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeTopViewDelegate <NSObject>

-(void)clickSearchAction;

@end

@interface StudentsHomeTopView : UIView
@property (weak, nonatomic) IBOutlet UIView *SearchView;
@property (weak, nonatomic) IBOutlet UILabel *OnLineTeacherNumLb;
@property (weak, nonatomic) IBOutlet UILabel *OnLineStudentNumLb;
@property (weak, nonatomic) IBOutlet UIView *topNavView;

@property (nonatomic, weak) id<HomeTopViewDelegate>homeDelagate;

@end

NS_ASSUME_NONNULL_END
