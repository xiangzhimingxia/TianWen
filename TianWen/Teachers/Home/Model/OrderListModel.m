//
//  OrderListModel.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/20.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"roomId":@"id"};
}
+(NSDictionary *)mj_objectClassInArray{
    return @{@"orderFileList":[UploadModel class]};
}

@end
