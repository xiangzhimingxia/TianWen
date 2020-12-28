//
//  TaacherInfoApplyViewController.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/2.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "JLKFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaacherInfoApplyViewController : JLKFBaseViewController

@property (nonatomic, assign) BOOL isTeacherInfo;  //是否普通用户教师身份(相当于isLogin判别)
@property (nonatomic, assign) BOOL isAnswerInfo;  //是否解答人教师身份
//以上两种都不是，则为申请成为解答人

kAS(BOOL, isLogin);  //是否从登陆注册处进入

kStr(auditsStatus);  //解答人审核状态0待审核1审核通过2审核拒绝   10.空值（从未申请）

@end

NS_ASSUME_NONNULL_END
