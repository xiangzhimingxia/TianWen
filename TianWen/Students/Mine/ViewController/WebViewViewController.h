//
//  WebViewViewController.h
//  TianWen
//
//  Created by 朱伟 on 2020/12/23.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "JLKFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewViewController : JLKFBaseViewController

kAS(NSInteger, type);  //0.直接进入（轮播图）1.@"计费规则",2.@"帮助中心",3.@"联系我们",4.登录注册隐私协议

kStr(titleStr);
kStr(urlStr);

@end

NS_ASSUME_NONNULL_END
