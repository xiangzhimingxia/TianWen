//
//  AfterClassModel.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/23.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "AfterClassModel.h"

@implementation AfterClassModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"facultyTeamDetails":[TeacherTeamModel class],@"userEvaluateList":[EvaluationModel class]};
}

@end
