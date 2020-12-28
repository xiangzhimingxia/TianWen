//
//  UploadModel.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/18.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadModel : NSObject

kStr(fileType);  //文件类型1图片2语音
kStr(fileUrl);
kStr(fileSize);

//订单详情
kStr(orderFileId);
kStr(orderId);

@end

NS_ASSUME_NONNULL_END
