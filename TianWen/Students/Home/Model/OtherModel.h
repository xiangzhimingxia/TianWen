//
//  OtherModel.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/15.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtherModel : NSObject

kStr(bannerUrl);
kStr(bannerPic);
kStr(bannerName);
kStr(bannerId);


kStr(columnId);
kStr(columnName);


kUI(NSURL, recordLocalURL);
kStr(recordLocalStr);
kStr(recordTimeStr);


kStr(userHeadPic);
kStr(nickName);


kStr(satisfiedCount);
kStr(answerDuration);
kStr(orderCount);
kStr(answerIncome);


kStr(audits);


//登录
kStr(isIdentity);
kStr(userId);
kStr(token);
kStr(answerToken);
kStr(answerUserId);


//腾讯云自定义信令（单聊）消息
kAS(int, classId);
kStr(orderId);
kAS(int, type);

@end

NS_ASSUME_NONNULL_END
