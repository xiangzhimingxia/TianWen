//
//  HttpManager.h
//  中盾app
//
//  Created by 一路走一路寻 on 16/8/16.
//  Copyright © 2016年 Xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

#define dataKey  @"content"
#define codeKey @"success"
#define msgKey  @"message"

#define statusKey  @"status"
#define pagesKey @"pages"

#define SuccessInfo obj[codeKey]

// 客户服务器
//#define LHOST @"http://112.74.113.218:8086"

#define HOST @"https://tellwinedu.com"

//http://120.77.52.85:8899
//http://120.77.52.85:8180
//http://120.77.183.50:80

//测试
//#define HOST @"http://192.168.1.201:8080"
//#define LHOST @"http://112.74.113.218:8086"


#pragma mark -- Student

#pragma mark -- 首页
#define Banner_Home [NSString stringWithFormat:@"%@/heaven-api/api/index/banner",HOST]
#define online_Home [NSString stringWithFormat:@"%@/heaven-api/api/myWS",HOST]
#define column_Home [NSString stringWithFormat:@"%@/heaven-api/api/index/column",HOST]

#define facultyTeam_Home [NSString stringWithFormat:@"%@/heaven-api/api/index/facultyTeam",HOST]

#define activityList_Home [NSString stringWithFormat:@"%@/heaven-api/api/index/activityList",HOST]

#define indexQuestionList_Home [NSString stringWithFormat:@"%@/heaven-api/api/index/indexQuestionList",HOST]

#define questionDetails_Home [NSString stringWithFormat:@"%@/heaven-api/api/index/questionDetails",HOST]

#define facultyTeamDetails_Home [NSString stringWithFormat:@"%@/heaven-api/api/index/facultyTeamDetails",HOST]

#define follow_Home [NSString stringWithFormat:@"%@/heaven-api/api/index/follow",HOST]

//首页文章列表
#define acticleList_Home [NSString stringWithFormat:@"%@/heaven-api/api/index/indexQuestionList",HOST]


#define addOrder_Home [NSString stringWithFormat:@"%@/heaven-api/api/order/addOrder",HOST]

#define meetOrder_Home [NSString stringWithFormat:@"%@/heaven-api/api/order/meetOrder",HOST]

#define userCannelOrder_Home [NSString stringWithFormat:@"%@/heaven-api/api/order/userCannelOrder",HOST]

#define answerSuccess_Home [NSString stringWithFormat:@"%@/heaven-api/api/order/answerSuccess",HOST]

#define sendOrder_Home [NSString stringWithFormat:@"%@/heaven-api/api/order/sendOrder",HOST]

#define answerType_Home [NSString stringWithFormat:@"%@/heaven-api/api/order/answerType",HOST]


#pragma mark -- Mine
#define userInfo_Mine [NSString stringWithFormat:@"%@/heaven-api/api/my/userInfo",HOST]

#define userHeadPic_Mine [NSString stringWithFormat:@"%@/heaven-api/api/my/userHeadPic",HOST]

#define switch_Mine [NSString stringWithFormat:@"%@/heaven-api/api/my/switch",HOST]

#define myFollow_Mine [NSString stringWithFormat:@"%@/heaven-api/api/my/myFollow",HOST]

#define integralSet_Mine [NSString stringWithFormat:@"%@/heaven-api/api/my/integralSet",HOST]

#define integral_Mine [NSString stringWithFormat:@"%@/heaven-api/api/my/integral",HOST]

#define feedback_Mine [NSString stringWithFormat:@"%@/heaven-api/api/my/feedback",HOST]

#define recharge_Mine [NSString stringWithFormat:@"%@/heaven-api/api/my/recharge",HOST]

#pragma mark -- Teacher
#pragma mark - Home
#define answerList_Home [NSString stringWithFormat:@"%@/heaven-api/api/order/answerList",HOST]

#define answerStatistics_Home [NSString stringWithFormat:@"%@/heaven-api/api/index/answerStatistics",HOST]

#define orderDetails_Home [NSString stringWithFormat:@"%@/heaven-api/api/order/orderDetails",HOST]

#define orderList_Home [NSString stringWithFormat:@"%@/heaven-api/api/order/orderList",HOST]


#pragma mark -- 登录注册

#define SENDMEG_LOGIN [NSString stringWithFormat:@"%@/heaven-api/api/send/sms",HOST]

//手机号登录
#define USERLOGIN_LOGIN [NSString stringWithFormat:@"%@/heaven-api/api/user/userLogion",HOST]

//注册
#define REGiSTERUSER_LOGIN [NSString stringWithFormat:@"%@/heaven-api/api/user/userRegister",HOST]

#define grade_LOGIN [NSString stringWithFormat:@"%@/heaven-api/api/select/grade",HOST]

//填写完善资料接口
#define FILLUSERINFO_LOGIN [NSString stringWithFormat:@"%@/heaven-api/api/my/updateUserInfo",HOST]

#define applyAnswer_LOGIN [NSString stringWithFormat:@"%@/heaven-api/api/my/applyAnswer",HOST]

#define subject_LOGIN [NSString stringWithFormat:@"%@/heaven-api/api/select/subject",HOST]

#define qualifications_LOGIN [NSString stringWithFormat:@"%@/heaven-api/api/select/qualifications",HOST]

#define mandarin_LOGIN [NSString stringWithFormat:@"%@/heaven-api/api/select/mandarin",HOST]


#define UPLOADFILE [NSString stringWithFormat:@"%@/heaven-api/api/upload/upload",HOST]



extern NSString *const MSG_STR_SUCCESS;
extern const NSInteger MSG_SUCCESS;

@interface HttpManager : NSObject


//主要负责数据的请求
/**
 *  回调的blcok
 *
 *  @param error 错误信息
 *  @param obj   请求到的数据
 */
typedef void (^returnBlock)(NSError *error,id obj);
/**
 *  发起get请求
 *
 *  @param url    url地址
 *  @param params 参数
 *  @param block  回调block
 */
+(void)getWithURL:(NSString *)url andParams:(NSDictionary *)params returnBlcok:(returnBlock)block;
/**
 *  发起post请求
 *
 *  @param url    url地址
 *  @param params 参数
 *  @param block  回调block
 */
+(void)postWithURL:(NSString *)url andParams:(NSDictionary *)params returnBlcok:(returnBlock)block;
//不带头部，请求为json
+ (void)postNotHeadWithURL:(NSString *)url andParams:(id)params returnBlcok:(returnBlock)block;

/**
 *  发起put请求
 *
 *  @param url    url地址
 *  @param params 参数
 *  @param block  回调block
 */
+(void)putWithURL:(NSString *)url andParams:(NSDictionary *)params returnBlcok:(returnBlock)block;

/**
 *  发起delete请求
 *
 *  @param url    url地址
 *  @param params 参数
 *  @param block  回调block
 */
+(void)deleteWithURL:(NSString *)url andParams:(NSDictionary *)params returnBlcok:(returnBlock)block;

/**
 *  发起post请求
 *  上传多张图片
 *  @param url    url地址
 *  @param params 参数
 *  @param block  回调block
 */
+(void)postWithURL:(NSString *)url andParams:(NSDictionary *)params imageFiles:(NSArray *)files withFilesName:(NSString *)name returnBlcok:(returnBlock)block;

+(void)postWithURL1:(NSString *)url andParams:(NSDictionary *)params imageFiles:(NSArray *)files withFilesName:(NSString *)name returnBlcok:(returnBlock)block;


/**
 *  发起post请求
 *  上传音频
 *  @param url    url地址
 *  @param params 参数
 *  @param block  回调block
 */
+(void)postWithURL3:(NSString *)url andParams:(NSDictionary *)params voiceFiles:(NSString *)files withFilesName:(NSString *)name returnBlcok:(returnBlock)block;

/**
 * 图片加载
 */
+(void)setImageView:(UIImageView *)imageView withURL:(NSString *)imageUrl;


#pragma mark -- 自定义

/**
 *  发起带参get请求
 *
 *  @param url    url地址
 *  @param params 参数
 *  @param block  回调block
 */
+(void)getParamsWithURL:(NSString *)url andParams:(NSDictionary *)params returnBlcok:(returnBlock)block;

//获取当前视图控制器
+(UIViewController *)currentViewController;

#pragma mark - 环信相关
#define EM_PASS_WORD (@"123456")
/**
 *  环信登录
 *
 *  @return 是否成功
 */
+ (BOOL)EMLogin:(NSString *)userId;
/**
 *  退出登录
 *
 *  @return 是否成功
 */
+ (BOOL)EMLogff:(NSString *)userId;

+ (NSString *)SStrToMD5:(NSString *)aStr;

@end
