//
//  AskTopView.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AskTopView : UIView
@property (weak, nonatomic) IBOutlet UIView *uploadPicView;
@property (weak, nonatomic) IBOutlet UIView *uploadVocieView;
@property (weak, nonatomic) IBOutlet UIView *gradeView;
@property (weak, nonatomic) IBOutlet UILabel *gradeLb;
@property (weak, nonatomic) IBOutlet UIView *subjectsView;
@property (weak, nonatomic) IBOutlet UILabel *subjectLb;
@property (weak, nonatomic) IBOutlet UITextField *titleTextfield;
@property (weak, nonatomic) IBOutlet UILabel *holdLb;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end

NS_ASSUME_NONNULL_END
