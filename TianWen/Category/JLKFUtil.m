//
//  JLKFUtil.m
//  ClassPamper
//
//  Created by Xcode on 16/8/19.
//  Copyright © 2016年 Xcode. All rights reserved.
//

#import "JLKFUtil.h"
#import <CommonCrypto/CommonDigest.h>
//#import <UIKit/UIKit.h>
//#import <CoreGraphics/CGContext.h>
#import "NSString+ExchangeData.h"
#import "lame.h"


@implementation JLKFUtil

/*
 *  用正则判断用户名，是否2－16位
 */
+ (BOOL) checkInputUserName:(NSString *)text
{
    NSString *Regex = @"^\\w{2,16}$";
    NSPredicate *userName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [userName evaluateWithObject:text];
}

/*
 *  用正则判断邮箱
 */
+ (BOOL) checkInputEmail:(NSString *)text
{
    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *email = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [email evaluateWithObject:text];
}

/*
 *  用正则判断密码，是否6－20位
 */
+ (BOOL) checkInputPassword:(NSString *)text
{
    NSString *Regex = @"\\w{6,16}";
    NSPredicate *password = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [password evaluateWithObject:text];
}


/*
 *  得到字符串长度 中英文混合情况下
 */
+(int)lengthToInt:(NSString*)string;
{
    //去掉空格
    NSString *st = [string  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    int strlength = 0;
    char* p = (char*)[st cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[st lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

/*
 *  将字符串进行MD5加密，返回加密后的字符串
 */
+ (NSString *) MD5Hash:(NSString*) aString
{
    const char *cStr = [aString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

/*
 *  新版手机号正则表达式
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     * 166，199
     */
//    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";

    NSString *CT = @"^1(3[3]|4[9]|53|6[6]|9[9]|7[037]|8[019])\\d{8}$";

    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isMobile:(NSString *)mobileNumbel{
    //    NSString *regex =@"^((1[3-8][0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //    if ([pred evaluateWithObject:mobileNumbel]) {
    //        return YES;
    //    }else{
    //        return NO;
    //    }
    NSString *mobileNum = mobileNumbel;
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    //    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    // 有些新电话号码会被判断为不是正常的电话号码，如166，199等这些开头的电话号码，注释掉上面加入电信中
    NSString *CT = @"^1(3[3]|4[9]|53|6[6]|9[9]|7[037]|8[019])\\d{8}$";



    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*
 *  URL解码
 */
+ (NSString *)URLDecodedString:(NSString*)stringURL
{
    return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                        (CFStringRef)stringURL,
                                                                                        CFSTR(""),
                                                                                        kCFStringEncodingUTF8);
}

///*
// *  图片变灰
// */
//+ (UIImage *)grayscaleWithImage:(UIImage *)image
//{
//	CGSize size = image.size;
//	CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
//
//	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//	CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
//	CGColorSpaceRelease(colorSpace);
//
//	CGContextDrawImage(context, rect, [image CGImage]);
//	CGImageRef grayscale = CGBitmapContextCreateImage(context);
//	CGContextRelease(context);
//
//	UIImage * image1 = [UIImage imageWithCGImage:grayscale];
//	CFRelease(grayscale);
//
//	return image1;
//}

/*
 *  判断字符串是否是数字组成
 */
+ (BOOL)isNumberStr:(NSString*)string
{
    NSString *number =@"0123456789";
    NSCharacterSet * cs =[[NSCharacterSet characterSetWithCharactersInString:number]invertedSet];
    NSString * comparStr = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    return [string isEqualToString:comparStr];
}

/*
 *  判断手机型号是否是iPhone5；
 */
+ (BOOL)isiPhone5Height:(NSInteger)height
{
    if (height>481) {
        return YES;
    }else
    {
        return NO;
    }
}

/*
 *  判断是否是身份证
 *  需要-(BOOL)isNumberStr:(NSString*)string配合
 */
+(BOOL)isPersonCard:(NSString*)string
{
    //    NSLog(@"%d",[self length]);
    if ([string length]!= 15 && [string length] != 18)
    {
        return NO;
    }
    else if ( ([string length] == 18 ||[string length] ==15) && [self isNumberStr:string])
    {
        return YES;
    }
    else if ([string length] == 18  && ([self isNumberStr:[string substringToIndex:17] ] && ([string hasSuffix:@"X"] || [string hasSuffix:@"x"])))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    //    return [string isMatchedByRegex:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}((19\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|(19\\d{2}(0[13578]|1[02])31)|(19\\d{2}02(0[1-9]|1\\d|2[0-8]))|(19([13579][26]|[2468][048]|0[48])0229))\\d{3}(\\d|X|x)?$"];
}

/*
 *  判断String中是否都是数字
 */
-(BOOL)isNumberStr:(NSString*)string
{
    NSString *number =@"0123456789";
    NSCharacterSet * cs =[[NSCharacterSet characterSetWithCharactersInString:number]invertedSet];
    NSString * comparStr = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    return [string isEqualToString:comparStr];
}
//匹配网址
+ (BOOL)isWeblinker:(NSString *)aString{
    
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * array = [regular matchesInString:aString options:0 range:NSMakeRange(0, aString.length)];
    if (array.count == 1) {
        NSTextCheckingResult * result = array.firstObject;
        if (result.range.length == aString.length ) {
            return YES;
        }
    }
    return NO;
}

/*
 *  base64转字符串
 */
+(NSString *)textStrFrombase64:(NSString *)base64{
   
    if (base64.length > 0) {

    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64 options:0];

    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        return base64;
    }
}

/*
 *  字符串转base64
 */
+(NSString *)base64FromStr:(NSString *)str{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}


/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示        :    刚刚
 ////   2）1小时以内 显示        :    X分钟前
 ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 ///    4) 今年显示              :   09月12日
 ///    5) 大于本年      显示    :    2013/09/09
 **/

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate
{

    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formate];

        NSDate * nowDate = [NSDate date];

        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];

        //// 再然后，把间隔的秒数折算成天数和小时数：

        NSString *dateStr = @"";

        if (time<=60) {  //// 1分钟以内的
            dateStr = @"刚刚";
        }else if(time<=60*60){  ////  一个小时以内的

            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];

        }else if(time<=60*60*24){   //// 在两天内的

            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];

            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                ////  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {

            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];

            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
//                [dateFormatter setDateFormat:@"MM月dd日"];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }

        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    
}

/**
 *  背景色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {

       CGRect rect = CGRectMake(0, 0, size.width, size.height);


        UIGraphicsBeginImageContext(rect.size);

        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetFillColorWithColor(context, [color CGColor]);

        CGContextFillRect(context, rect);

       UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

       UIGraphicsEndImageContext();

       return image;

}

/**
 *  更换图片路径
 */
+(NSString *)changePicURL:(NSString *)oldStr{
    NSString *newStr = [NSString string];

    newStr = [oldStr stringByReplacingOccurrencesOfString:@"\\" withString:@"//"];

    return newStr;
}

/// md5双加密(小写)
+ (NSString *)MD5md5Hash:(NSString *) aString {
    
    NSString *password = aString;
    
    password = [self MD5Hash:password];
    
    NSString *salt = @"ceolesson";
    
    password =  [self MD5Hash:[[password lowercaseString] stringByAppendingString:salt]];
    
    return [password lowercaseString];
}


/**
 判断日期的先后
 */
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;

}

/**
 获取当前NSDate
 */
+(NSDate *)getCurrentDate{

//    NSDate *senddate=[NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: senddate];
//    NSDate *localDate = [senddate dateByAddingTimeInterval: interval];
//
//    return localDate;

    NSString *timeStr = [NSString getCurrentTime];
    NSDate *date = [NSString stringExchangeToDate:timeStr];
    return date;
}

/**
 时间戳转换为NSDate
 */
+(NSDate *)exchangeTimeStamp:(NSString *)timeStamp{

    NSString *time = [NSString stringWithFormat:@"%@", timeStamp];
//    NSInteger num = [time integerValue] / 1000;
    NSInteger num = [time integerValue] ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:num];
    return confromTime;
}

/**
 时间戳转比较时间

 return stamp 毫秒时间戳
 */
+(NSString *)stampToChangeTime:(NSString *)stamp{

    NSString *time = [NSString stringWithFormat:@"%@", stamp];
    NSInteger nsnum = [time integerValue] / 1000;
//    NSInteger nsnum = [time integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:nsnum];
    NSString *confromTimespStr = [formatter stringFromDate:confromTime];

    return [JLKFUtil formateDate:confromTimespStr withFormate:@"yyyy-MM-dd HH:mm:ss"];
}


/**
 时间戳转时间

 @param stamp <#stamp description#>
 @return <#return value description#>
 */
+(NSString *)stampToTimeStr:(NSString *)stamp WithFormatter:(NSString *)formatterStr{

    NSString *time = [NSString stringWithFormat:@"%@", stamp];
//    NSInteger nsnum = [time integerValue] / 1000;
    NSInteger nsnum = [time integerValue] ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (formatterStr.length > 0) {
        [formatter setDateFormat:formatterStr];
    }else{
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    }
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:nsnum];
    NSString *confromTimespStr = [formatter stringFromDate:confromTime];
    return confromTimespStr;
}

/**
 时间戳转时间(区分秒或毫秒)

 @param stamp <#stamp description#>
 @return <#return value description#>
 */
+(NSString *)stampToTimeStr:(NSString *)stamp WithFormatter:(NSString *)formatterStr WithSeconds:(BOOL)isSeconds{

    NSString *time = [NSString stringWithFormat:@"%@", stamp];
    //    NSInteger nsnum = [time integerValue] / 1000;
    NSInteger nsnum ;
    if (isSeconds) {
        nsnum = [time integerValue];
    }else{
        nsnum = [time integerValue] / 1000;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (formatterStr.length > 0) {
        [formatter setDateFormat:formatterStr];
    }else{
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    }
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:nsnum];
    NSString *confromTimespStr = [formatter stringFromDate:confromTime];
    return confromTimespStr;
}

/**
 时间转时间戳

 @param time 时间
 @return 时间戳
 */
+(NSString *)timeToStampStr:(NSString *)time WithFormatter:(NSString *)formatterStr{


    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (formatterStr.length > 0) {
        [formatter setDateFormat:formatterStr];
    }else{
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    }
    NSDate *date = [formatter dateFromString:time];

    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型

    return timeString;
}


/**
 将生日转为年龄

 @param bornStr <#time description#>
 @param formatterStr <#formatterStr description#>
 @return <#return value description#>
 */
+(NSString *)dateToOld:(NSString *)bornStr WithFormatter:(NSString *)formatterStr{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (formatterStr.length > 0) {
        [formatter setDateFormat:formatterStr];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate *bornDate = [formatter dateFromString:bornStr];

    //获得当前系统时间
    NSDate *currentDate = [JLKFUtil getCurrentDate];
    //获得当前系统时间与出生日期之间的时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:bornDate];
    //时间间隔以秒作为单位,求年的话除以60*60*24*356
    int age = ((int)time)/(3600*24*365);
    return [NSString stringWithFormat:@"%d",age];
}

// 获取当前周的周一和周日的时间
+ (NSString *)getWeekTime
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    NSLog(@"%d----%d",weekDay,day);

    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    NSLog(@"firstDiff: %ld   lastDiff: %ld",firstDiff,lastDiff);

    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];

    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit   fromDate:nowDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"MM月dd日"];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
    NSLog(@"%@=======%@",firstDay,lastDay);

    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",firstDay,lastDay];

    return dateStr;

}

/**
 获取UserDefaults数据

 @param keyStr UserDefaults Key值
 @return UserDefaults Value值
 */
+(NSData *)getUserDefaultsValuesFromKeyStr:(NSString *)keyStr{

    return [[NSUserDefaults standardUserDefaults] valueForKey:keyStr];
}
+(void)setValueToUserDefaultsForKeyStr:(NSString *)keyStr AndWithData:(NSData *)data{

    [[NSUserDefaults standardUserDefaults] setObject:data forKey:keyStr];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

/**
 url编码转换

 @param urlStr URL
 @return 编码转换URL
 */
+(NSString *)changeRightUrlEncordFromStr:(NSString *)urlStr{

    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,

                                                              (CFStringRef)urlStr,

                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",

                                                              NULL,
                                                              
                                                              kCFStringEncodingUTF8));
    return encodedString;
}


/**
 富文本

 @param str <#str description#>
 @param font <#font description#>
 @param color <#color description#>
 @param range <#range description#>
 @return <#return value description#>
 */
+(NSMutableAttributedString *)attributeWithStr:(NSString *)str AndWithFont:(UIFont *)font AndWithColor:(UIColor *)color AndRange:(NSRange )range{

    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:str];
    if (font != nil) {
        [attributeStr addAttribute:NSFontAttributeName value:font range:range];
    }
    if (color != nil) {
        [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }

    return attributeStr;
}


/**
 如果有两位小数不为0则保留两位小数，如果有一位小数不为0则保留一位小数，否则显示整数
 */
+ (NSString *)formatFloat:(double)f
{
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}

+ (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    //  NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL) checkCardNo:(NSString*) cardNo{
    
    int oddsum = 0;    //奇数求和
    
    int evensum = 0;    //偶数求和
    
    int allsum = 0;
    
    int cardNoLength = (int)[cardNo length];
    
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    
    
    cardNo = [cardNo substringToIndex:cardNoLength -1];
    
    for (int i = cardNoLength -1 ; i>=1;i--) {
        
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1,1)];
        
        int tmpVal = [tmpString intValue];
        
        if (cardNoLength % 2 ==1 ) {
            
            if((i % 2) == 0){
                
                tmpVal *= 2;
                
                if(tmpVal>=10)
                    
                    tmpVal -= 9;
                
                evensum += tmpVal;
                
            }else{
                
                oddsum += tmpVal;
                
            }
            
        }else{
            
            if((i % 2) == 1){
                
                tmpVal *= 2;
                
                if(tmpVal>=10)
                    
                    tmpVal -= 9;
                
                evensum += tmpVal;
                
            }else{
                
                oddsum += tmpVal;
                
            }
            
        }
        
    }
    
    
    
    allsum = oddsum + evensum;
    
    allsum += lastNum;
    
    if((allsum % 10) ==0)
        
        return YES;
    
    else
        
        return NO;
    
}

+ (NSString *)backbankenameWithBanknumber:(NSString *)banknumber{
    
    NSString *bankNumber = [banknumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *dic;
    
    NSString *bank = @"";
    
    NSString *bank1 = @"";
    
    NSString *bank2 = @"";
    
    NSString *bankname;
    
    bank1 = [bankNumber substringToIndex:5];
    
    bank = [bankNumber substringToIndex:6];
    
    bank2 = [bankNumber substringToIndex:8];
    
    if (!dic) {
        
        dic = @{@"402791":@"工商银行",@"427028":@"工商银行",@"427038":@"工商银行",@"548259":@"工商银行",@"620200":@"工商银行",@"620302":@"工商银行",@"620402":@"工商银行",@"620403":@"工商银行",@"620404":@"工商银行",@"620405":@"工商银行",@"620406":@"工商银行",@"620407":@"工商银行",@"620408":@"工商银行",@"620409":@"工商银行",@"620410":@"工商银行",@"620411":@"工商银行",@"620412":@"工商银行",@"620502":@"工商银行",@"620503":@"工商银行",@"620512":@"工商银行",@"620602":@"工商银行",@"620604":@"工商银行",@"620607":@"工商银行",@"620609":@"工商银行",@"620611":@"工商银行",@"620612":@"工商银行",@"620704":@"工商银行",@"620706":@"工商银行",@"620707":@"工商银行",@"620708":@"工商银行",@"620709":@"工商银行",@"620710":@"工商银行",@"620711":@"工商银行",@"620712":@"工商银行",@"620713":@"工商银行",@"620714":@"工商银行",@"620802":@"工商银行",@"620904":@"工商银行",@"620905":@"工商银行",@"621101":@"工商银行",@"621102":@"工商银行",@"621103":@"工商银行",@"621105":@"工商银行",@"621106":@"工商银行",@"621107":@"工商银行",@"621202":@"工商银行",@"621203":@"工商银行",@"621204":@"工商银行",@"621205":@"工商银行",@"621206":@"工商银行",@"621207":@"工商银行",@"621208":@"工商银行",@"621209":@"工商银行",@"621210":@"工商银行",@"621211":@"工商银行",@"621302":@"工商银行",@"621303":@"工商银行",@"621304":@"工商银行",@"621305":@"工商银行",@"621306":@"工商银行",@"621307":@"工商银行",@"621308":@"工商银行",@"621309":@"工商银行",@"621311":@"工商银行",@"621313":@"工商银行",@"621315":@"工商银行",@"621317":@"工商银行",@"621402":@"工商银行",@"621404":@"工商银行",@"621405":@"工商银行",@"621406":@"工商银行",@"621407":@"工商银行",@"621408":@"工商银行",@"621409":@"工商银行",@"621410":@"工商银行",@"621502":@"工商银行",@"621511":@"工商银行",@"621602":@"工商银行",@"621603":@"工商银行",@"621604":@"工商银行",@"621605":@"工商银行",@"621606":@"工商银行",@"621607":@"工商银行",@"621608":@"工商银行",@"621609":@"工商银行",@"621610":@"工商银行",@"621611":@"工商银行",@"621612":@"工商银行",@"621613":@"工商银行",@"621614":@"工商银行",@"621615":@"工商银行",@"621616":@"工商银行",@"621617":@"工商银行",@"621804":@"工商银行",@"621807":@"工商银行",@"621813":@"工商银行",@"621814":@"工商银行",@"621817":@"工商银行",@"621901":@"工商银行",@"621903":@"工商银行",@"621904":@"工商银行",@"621905":@"工商银行",@"621906":@"工商银行",@"621907":@"工商银行",@"621908":@"工商银行",@"621909":@"工商银行",@"621910":@"工商银行",@"621911":@"工商银行",@"621912":@"工商银行",@"621913":@"工商银行",@"621914":@"工商银行",@"621915":@"工商银行",@"622002":@"工商银行",@"622003":@"工商银行",@"622004":@"工商银行",@"622005":@"工商银行",@"622006":@"工商银行",@"622007":@"工商银行",@"622008":@"工商银行",@"622009":@"工商银行",@"622010":@"工商银行",@"622011":@"工商银行",@"622012":@"工商银行",@"622013":@"工商银行",@"622014":@"工商银行",@"622015":@"工商银行",@"622016":@"工商银行",@"622017":@"工商银行",@"622018":@"工商银行",@"622019":@"工商银行",@"622020":@"工商银行",@"622102":@"工商银行",@"622103":@"工商银行",@"622104":@"工商银行",@"622105":@"工商银行",@"622110":@"工商银行",@"622111":@"工商银行",@"622114":@"工商银行",@"622302":@"工商银行",@"622303":@"工商银行",@"622304":@"工商银行",@"622305":@"工商银行",@"622306":@"工商银行",@"622307":@"工商银行",@"622308":@"工商银行",@"622309":@"工商银行",@"622313":@"工商银行",@"622314":@"工商银行",@"622315":@"工商银行",@"622317":@"工商银行",@"622402":@"工商银行",@"622403":@"工商银行",@"622404":@"工商银行",@"622502":@"工商银行",@"622504":@"工商银行",@"622505":@"工商银行",@"622509":@"工商银行",@"622510":@"工商银行",@"622513":@"工商银行",@"622517":@"工商银行",@"622604":@"工商银行",@"622605":@"工商银行",@"622606":@"工商银行",@"622703":@"工商银行",@"622706":@"工商银行",@"622715":@"工商银行",@"622806":@"工商银行",@"622902":@"工商银行",@"622903":@"工商银行",@"622904":@"工商银行",@"623002":@"工商银行",@"623006":@"工商银行",@"623008":@"工商银行",@"623011":@"工商银行",@"623012":@"工商银行",@"623014":@"工商银行",@"623015":@"工商银行",@"623100":@"工商银行",@"623202":@"工商银行",@"623301":@"工商银行",@"623400":@"工商银行",@"623500":@"工商银行",@"623602":@"工商银行",@"623700":@"工商银行",@"623803":@"工商银行",@"623901":@"工商银行",@"624000":@"工商银行",@"624100":@"工商银行",@"624200":@"工商银行",@"624301":@"工商银行",@"624402":@"工商银行",@"620058":@"工商银行",@"620516":@"工商银行",@"621225":@"工商银行",@"621226":@"工商银行",@"621227":@"工商银行",@"621281":@"工商银行",@"621288":@"工商银行",@"621721":@"工商银行",@"621722":@"工商银行",@"621723":@"工商银行",@"622200":@"工商银行",@"622202":@"工商银行",@"622203":@"工商银行",@"622208":@"工商银行",@"900000":@"工商银行",@"900010":@"工商银行",@"620086":@"工商银行",@"621558":@"工商银行",@"621559":@"工商银行",@"621618":@"工商银行",@"621670":@"工商银行",@"623062":@"工商银行",@"421349":@"建设银行",@"434061":@"建设银行",@"434062":@"建设银行",@"524094":@"建设银行",@"526410":@"建设银行",@"552245":@"建设银行",@"621080":@"建设银行",@"621082":@"建设银行",@"621466":@"建设银行",@"621488":@"建设银行",@"621499":@"建设银行",@"622966":@"建设银行",@"622988":@"建设银行",@"436742":@"建设银行",@"589970":@"建设银行",@"620060":@"建设银行",@"621081":@"建设银行",@"621284":@"建设银行",@"621467":@"建设银行",@"621598":@"建设银行",@"621621":@"建设银行",@"621700":@"建设银行",@"622280":@"建设银行",@"622700":@"建设银行",@"436742":@"建设银行",@"622280":@"建设银行",@"623211":@"建设银行",@"620059":@"农业银行",@"621282":@"农业银行",@"621336":@"农业银行",@"621619":@"农业银行",@"621671":@"农业银行",@"622821":@"农业银行",@"622822":@"农业银行",@"622823":@"农业银行",@"622824":@"农业银行",@"622825":@"农业银行",@"622826":@"农业银行",@"622827":@"农业银行",@"622828":@"农业银行",@"622840":@"农业银行",@"622841":@"农业银行",@"622843":@"农业银行",@"622844":@"农业银行",@"622845":@"农业银行",@"622846":@"农业银行",@"622847":@"农业银行",@"622848":@"农业银行",@"622849":@"农业银行",@"623018":@"农业银行",@"623206":@"农业银行",@"621626":@"平安银行",@"623058":@"平安银行",@"602907":@"平安银行",@"622298":@"平安银行",@"622986":@"平安银行",@"622989":@"平安银行",@"627066":@"平安银行",@"627067":@"平安银行",@"627068":@"平安银行",@"627069":@"平安银行",@"412962":@"发展银行",@"412963":@"发展银行",@"415752":@"发展银行",@"415753":@"发展银行",@"622535":@"发展银行",@"622536":@"发展银行",@"622538":@"发展银行",@"622539":@"发展银行",@"622983":@"发展银行",@"998800":@"发展银行",@"690755":@"招商银行",@"402658":@"招商银行",@"410062":@"招商银行",@"468203":@"招商银行",@"512425":@"招商银行",@"524011":@"招商银行",@"621286":@"招商银行",@"622580":@"招商银行",@"622588":@"招商银行",@"622598":@"招商银行",@"622609":@"招商银行",@"690755":@"招商银行",@"433670":@"中信银行",@"433671":@"中信银行",@"433680":@"中信银行",@"442729":@"中信银行",@"442730":@"中信银行",@"620082":@"中信银行",@"621767":@"中信银行",@"621768":@"中信银行",@"621770":@"中信银行",@"621771":@"中信银行",@"621772":@"中信银行",@"621773":@"中信银行",@"622690":@"中信银行",@"622691":@"中信银行",@"622692":@"中信银行",@"622696":@"中信银行",@"622698":@"中信银行",@"622998":@"中信银行",@"622999":@"中信银行",@"968807":@"中信银行",@"968808":@"中信银行",@"968809":@"中信银行",@"620085":@"广大银行",@"620518":@"广大银行",@"621489":@"广大银行",@"621492":@"广大银行",@"622660":@"广大银行",@"622661":@"广大银行",@"622662":@"广大银行",@"622663":@"广大银行",@"622664":@"广大银行",@"622665":@"广大银行",@"622666":@"广大银行",@"622667":@"广大银行",@"622668":@"广大银行",@"622669":@"广大银行",@"622670":@"广大银行",@"622671":@"广大银行",@"622672":@"广大银行",@"622673":@"广大银行",@"622674":@"广大银行",@"620535":@"广大银行",@"622516":@"浦发银行",@"622517":@"浦发银行",@"622518":@"浦发银行",@"622521":@"浦发银行",@"622522":@"浦发银行",@"622523":@"浦发银行",@"984301":@"浦发银行",@"984303":@"浦发银行",@"621352":@"浦发银行",@"621793":@"浦发银行",@"621795":@"浦发银行",@"621796":@"浦发银行",@"621351":@"浦发银行",@"621390":@"浦发银行",@"621792":@"浦发银行",@"621791":@"浦发银行",@"84301":@"浦发银行",@"84336":@"浦发银行",@"84373":@"浦发银行",@"84385":@"浦发银行",@"84390":@"浦发银行",@"87000":@"浦发银行",@"87010":@"浦发银行",@"87030":@"浦发银行",@"87040":@"浦发银行",@"84380":@"浦发银行",@"84361":@"浦发银行",@"87050":@"浦发银行",@"84342":@"浦发银行",@"415599":@"民生银行",@"421393":@"民生银行",@"421865":@"民生银行",@"427570":@"民生银行",@"427571":@"民生银行",@"472067":@"民生银行",@"472068":@"民生银行",@"622615":@"民生银行",@"622616":@"民生银行",@"622617":@"民生银行",@"622618":@"民生银行",@"622619":@"民生银行",@"622620":@"民生银行",@"622622":@"民生银行",@"601428":@"交通银行",@"405512":@"交通银行",@"622258":@"交通银行",@"622259":@"交通银行",@"622260":@"交通银行",@"622261":@"交通银行",@"622262":@"交通银行",@"621056":@"交通银行",@"621335":@"交通银行",@"621096":@"邮政储蓄银行",@"621098":@"邮政储蓄银行",@"622150":@"邮政储蓄银行",@"622151":@"邮政储蓄银行",@"622181":@"邮政储蓄银行",@"622188":@"邮政储蓄银行",@"955100":@"邮政储蓄银行",@"621095":@"邮政储蓄银行",@"620062":@"邮政储蓄银行",@"621285":@"邮政储蓄银行",@"621798":@"邮政储蓄银行",@"621799":@"邮政储蓄银行",@"621797":@"邮政储蓄银行",@"620529":@"邮政储蓄银行",@"622199":@"邮政储蓄银行",@"62215049":@"邮政储蓄银行",@"62215050":@"邮政储蓄银行",@"62215051":@"邮政储蓄银行",@"62218850":@"邮政储蓄银行",@"62218851":@"邮政储蓄银行",@"62218849":@"邮政储蓄银行",@"621622":@"邮政储蓄银行",@"621599":@"邮政储蓄银行",@"623219":@"邮政储蓄银行",@"621674":@"邮政储蓄银行",@"623218":@"邮政储蓄银行",@"621660":@"中国银行",@"621661":@"中国银行",@"621662":@"中国银行",@"621663":@"中国银行",@"621665":@"中国银行",@"621667":@"中国银行",@"621668":@"中国银行",@"621669":@"中国银行",@"621666":@"中国银行",@"456351":@"中国银行",@"601382":@"中国银行",@"621256":@"中国银行",@"621212":@"中国银行",@"621283":@"中国银行",@"620061":@"中国银行",@"621725":@"中国银行",@"621330":@"中国银行",@"621331":@"中国银行",@"621332":@"中国银行",@"621333":@"中国银行",@"621297":@"中国银行",@"621568":@"中国银行",@"621569":@"中国银行",@"621672":@"中国银行",@"623208":@"中国银行",@"621620":@"中国银行",@"621756":@"中国银行",@"621757":@"中国银行",@"621758":@"中国银行",@"621759":@"中国银行",@"621785":@"中国银行",@"621786":@"中国银行",@"621787":@"中国银行",@"621788":@"中国银行",@"621789":@"中国银行",@"621790":@"中国银行"};
        
    }
    
    
    
    for (NSString *s in [dic allKeys]) {
        
        if ([bank1 isEqualToString:s]||[bank isEqualToString:s]||[bank2 isEqualToString:s]) {
            
            //            bankname = [dic objectForKey:s];
            
            bankname = dic[s];
            
            NSLog(@"bankname%@",bankname);
            
            break ;
            
        }
        
    }
    
    
    
    return bankname;
    
}

+(NSData *)imageData:(UIImage *)myimage{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024)
    {
        if (data.length>1024*1024)
        {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024)
        {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024)
        {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}

/**
 获取字符串中多个相同字符串的所有range

 @param initialArray 空数组或有值数组
 @param initialText 源字符串
 @param regexString 查询字符串    //应用例子：value = initialArray[0][@"subStringRange"]  NSRange range = [value rangeValue];
 */
+ (void)searchAllTextRangeWithInitialArray:(NSMutableArray*)initialArray initialText:(NSString*)initialText regexString:(NSString*)regexString{

          if (initialArray.count == 0) {//如果此时传入的array是空

                    NSRange range = [initialText rangeOfString:regexString options:NSRegularExpressionSearch];

                    if (range.location != NSNotFound) {

                              //包装字典，存进数组

                              NSMutableDictionary *dict = [NSMutableDictionary dictionary];

                              dict[@"subString"] = [initialText substringWithRange:range];

                              dict[@"subStringRange"] = [NSValue valueWithRange:range];

                              [initialArray addObject:dict];

                              //递归调用

                              [self searchAllTextRangeWithInitialArray:initialArray initialText:initialText regexString:regexString];

                        }else{

                                  return;

                            }

              }else{//如果数组中已经有值了

                        //1、取数组中最后一个字典，记录后串在原串中的起始位置，把该串及其之前的串去掉生成新串

                        NSMutableDictionary *lastDict = [initialArray lastObject];

                        NSRange lastRange = [lastDict[@"subStringRange"] rangeValue];

                        NSUInteger newStringBeginLocation = lastRange.location+ lastRange.length;

                        NSString *newString = [initialText substringFromIndex:newStringBeginLocation];

                        //2、在新串中找符合的子串，如果找到，包装存进数组

                        NSRange rangeInNewString = [newString rangeOfString:regexString options:NSRegularExpressionSearch];

                        if(rangeInNewString.location!=NSNotFound) {

                                  //包装字典，存进数组

                                  NSMutableDictionary*dict = [NSMutableDictionary dictionary];

                                 dict[@"subString"] = [newString substringWithRange:rangeInNewString];

                                 NSRange rangeIninitialText = NSMakeRange(rangeInNewString.location+newStringBeginLocation, rangeInNewString.length);

                                 dict[@"subStringRange"] = [NSValue valueWithRange:rangeIninitialText];

                                 [initialArray addObject:dict];

                                 //递归调用

                                 [self searchAllTextRangeWithInitialArray:initialArray initialText:initialText regexString:regexString];

                           }else{

                                     return;

                               }

                  }

}

/**通过CAShapeLayer方式绘制虚线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+(void)viewmasksAllToBounds:(UIView *)view{

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(view.frame.size.height/2.0, view.frame.size.height/2.0)];

    // 初始化一个CAShapeLayer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    // 将曲线路径设置为layer的路径
    maskLayer.path = path.CGPath;

    // 设置控件的mask为CAShapeLayer
    view.layer.mask = maskLayer;
}

+(void)viewmasksLeftToBounds:(UIView *)view{

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(view.frame.size.height/2.0, view.frame.size.height/2.0)];

    // 初始化一个CAShapeLayer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    // 将曲线路径设置为layer的路径
    maskLayer.path = path.CGPath;

    // 设置控件的mask为CAShapeLayer
    view.layer.mask = maskLayer;
}

+(void)viewmasksRightToBounds:(UIView *)view{

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(view.frame.size.height/2.0, view.frame.size.height/2.0)];

    // 初始化一个CAShapeLayer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    // 将曲线路径设置为layer的路径
    maskLayer.path = path.CGPath;

    // 设置控件的mask为CAShapeLayer
    view.layer.mask = maskLayer;
}

+(void)viewmasksTopToBounds:(UIView *)view{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(8.0, 8.0)];

    // 初始化一个CAShapeLayer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    // 将曲线路径设置为layer的路径
    maskLayer.path = path.CGPath;

    // 设置控件的mask为CAShapeLayer
    view.layer.mask = maskLayer;
}

+(void)viewmasksBottomToBounds:(UIView *)view{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];

    // 初始化一个CAShapeLayer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    // 将曲线路径设置为layer的路径
    maskLayer.path = path.CGPath;

    // 设置控件的mask为CAShapeLayer
    view.layer.mask = maskLayer;
}



+ (int)ConvertWavToMp3:(NSString *)aWavPath mp3SavePath:(NSString *)aSavePath
{
    int state = 0;
    @try {
        int read, write;
        
        FILE *pcm = fopen([aWavPath cStringUsingEncoding:NSASCIIStringEncoding], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([aSavePath cStringUsingEncoding:NSASCIIStringEncoding], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init(); // 初始化
        lame_set_num_channels(lame, 2); // 双声道
        lame_set_in_samplerate(lame, 8000); // 8k采样率
        lame_set_brate(lame, 16);  // 压缩的比特率为16
        lame_set_quality(lame, 2);  // mp3音质
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
        state = 1;
    }
    @catch (NSException *exception) {
        state = 0;
    }
    @finally {
        return state;
    }
}

+ (NSString *)getCacheDirectory
{
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *voicePath = [cache stringByAppendingPathComponent:@"Voice"];
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    if (![filemanager fileExistsAtPath:voicePath]){
        [filemanager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return voicePath;
}


+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

#pragma mark -- 业务逻辑

@end
