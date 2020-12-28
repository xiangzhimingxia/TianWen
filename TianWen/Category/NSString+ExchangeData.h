//
//  NSString+ExchangeData.h
//  SphygmomanometerAppIOS
//
//  Created by 极联开发 on 16/9/9.
//  Copyright © 2016年 极联开发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ExchangeData)

//四舍五入
+(NSString *)notRounding:(float)price afterPoint:(int)position;

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString;

//数值转换
+ (NSString *)getChangeNumberData:(NSString *)number;

//普通字符串转换为十六进制的
+ (NSString *)hexStringFromString:(NSString *)string;

//比较时间大小
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;

//获取系统当前时间
+ (NSString *)getCurrentTime;

//时间字符串转时间戳
+ (NSString *)timestampFromdataString:(NSString *)dataString;

//NSDate ---> NSString
+ (NSString *)dateExchangeToString:(NSDate *)date;

//NSString ---> NSDate
+ (NSDate *)stringExchangeToDate:(NSString *)string;

//获取当前时间戳
+ (NSString *)getCurrentTimesAboutTimestamp;

////时间戳转日期字符串 YYYY年MM月dd日 HH:mm
+ (NSString *)stringExchangeToDataAboutTimestamp:(NSString *)string;


////时间戳转日期字符串 YYYY年MM月dd日
+ (NSString *)stringExchangeToDataAboutTimestamp1:(NSString *)string ;

//时间戳转日期字符串 YYYY年MM月dd日HH时
+ (NSString *)stringExchangeToDataAboutTimestamp2:(NSString *)string;

//时间戳转日期字符串 MM.YY hh:mm
+ (NSString *)stringExchangeToDataAboutTimestamp3:(NSString *)string;
//时间戳转日期字符串 YYYY-MM-dd
+ (NSString *)stringExchangeToDataAboutTimestamp4:(NSString *)string;

//时间戳转日期字符串 YYYY-MM-dd HH:mm
+ (NSString *)stringExchangeToDataAboutNumberTimestamp:(NSString *)string;

//时间戳转日期字符串 YYYY-MM-dd HH:mm:ss
+ (NSString *)stringExchangeToDataAboutNumberTimestamp2:(NSString *)string;

//时间戳转日期字符串 YYYY-MM-dd HH:mm:ss
+ (NSString *)stringExchangeToDataAboutNumberTimestamp13:(NSString *)string;

//时间戳转自定义时间字符串
+ (NSString *)timeStampExchangeToCustomStringAboutTimestamp:(NSString *)string;
//计算某个时间到现在是多少月／天／时
+ (NSString *)getUTCFormateDate:(NSString *)newsDate;

//计算某一是时间距离某一时间天、时、分、秒
+ (NSArray *)getTimeData:(NSString *)timeOne toOtherTimeData:(NSString *)timeTwo;

//计算某个时间到现在是多少月
+ (NSString *)getMonthFormateDate:(NSString *)newsDate;
//时间戳转固定时间段2
+ (NSString *)getMonthFormateDateWeek:(NSString *)newsDate;


@end
