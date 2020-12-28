//
//  OrderDetailsModel.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderListModel.h"
#import "UploadModel.h"

/**********弃用***********/

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailsModel : NSObject

kUI(OrderListModel, orderDetails);
kUI(NSArray,orderFileList);

@end

NS_ASSUME_NONNULL_END
