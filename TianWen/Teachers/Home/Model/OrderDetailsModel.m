//
//  OrderDetailsModel.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "OrderDetailsModel.h"

@implementation OrderDetailsModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"orderDetails":[OrderListModel class],@"orderFileList":[UploadModel class]};
}

@end
