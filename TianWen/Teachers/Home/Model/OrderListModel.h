//
//  OrderListModel.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/20.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderListModel : NSObject

kUI(NSArray,orderFileList);

kStr(roomId);
kStr(realName);
kStr(gradeName);
kStr(orderId);
kStr(createTime);
kStr(askTitle);
kStr(subjectName);

kStr(answerText);
kStr(qualificationsName);
kStr(answerType);
kStr(orderStatus);
kStr(questionName);
kStr(headPic);
kStr(content);
kStr(score);
kStr(satisfiedCount);
kStr(answerCount);
kStr(payType);
kStr(answerDuration);
kStr(isSatisfied);
kStr(orderPrice);
kStr(describe);
kStr(userId);


kStr(answerTime);

@end

NS_ASSUME_NONNULL_END
