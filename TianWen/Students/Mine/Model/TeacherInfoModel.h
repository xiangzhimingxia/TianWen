//
//  TeacherInfoModel.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/12.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeacherInfoModel : NSObject

kStr(province);
kStr(city);
kStr(area);
kStr(gradeId);
kStr(gender); //性别1男2女
kStr(headPic);

kStr(userId);
kStr(nickName);
kStr(realName);
kStr(mobile);
kStr(school);
kStr(remarks);
kStr(subjectId);
kStr(years);
kStr(qualificationsId);
kStr(mandarinId);
kStr(describe);
kStr(balance);
kStr(integral);
kStr(mandarinName);
kStr(gradeName);
kStr(qualificationsName);
kStr(subjectName);

kStr(userIdentity);  //1.学生 2.老师

kStr(auditStatus);  //解答人审核状态0待审核1审核通过2审核拒绝

@end

NS_ASSUME_NONNULL_END
