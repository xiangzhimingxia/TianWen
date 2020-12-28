//
//  AppUser.h
//  BaseProject
//
//  Created by 朱伟 on 2017/8/6.
//  Copyright © 2017年 ZW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define User [AppUser user]

extern NSString * const YJGCAppUserKeyForUserDeatult;

@interface AppUser : NSObject <NSCoding>
// 标记是否登录
@property (nonatomic, assign)BOOL isLogin;
kStr(userId);//用户id

@property (nonatomic, assign)BOOL isAnswer;  //解答人端

//有赞信息
kStr(cookie_value);
kStr(cookie_key);
kStr(access_token);

//用户信息
//用户信息-登录token信息
kStr(token);
kStr(expire);
kStr(audits);  //解答人审核状态0待审核1审核通过2审核拒绝  10.空值Null
kStr(userIdentity);  //1.学生 2.老师

//用户信息-个人信息
kStr(id);
kStr(cardPhotoNegative);
kStr(realName);
kStr(phone);
kStr(sex);
kStr(idNumber);
kStr(oppenId);
kStr(useTime);
kStr(type);
kStr(password);
kStr(birthday);
kStr(nickName);
kStr(address);
kStr(cardPhotoPositive);
kStr(registerType);
kStr(realStatus);
kStr(createTime);
kStr(headImg);
kStr(status);
kStr(smokeType);

@property(nonatomic ,assign) NSInteger total;//社区消息数量
@property(nonatomic ,assign) NSInteger totalPriceNumber;//社区点赞消息数量
@property(nonatomic ,assign) NSInteger totalCommentNumber;//社区评论消息数量
@property(nonatomic ,assign) NSInteger totalSystemNotifyNumber;//系统消息数量

- (void)loginWithData:(NSDictionary *)data;
- (void)updateLocalUser;
- (void)clearLocalUser;
- (void)loginOut;
+ (instancetype)user;
@end
