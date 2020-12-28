//
//  AfterClassModel.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/23.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeacherTeamModel.h"
#import "EvaluationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AfterClassModel : NSObject

kUI(TeacherTeamModel,facultyTeamDetails);
kUI(NSArray, userEvaluateList);

@end

NS_ASSUME_NONNULL_END
