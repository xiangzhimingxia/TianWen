//
//  NSString+ExchangeData.m
//  SphygmomanometerAppIOS
//
//  Created by 极联开发 on 16/9/9.
//  Copyright © 2016年 极联开发. All rights reserved.
//

#import "NSString+ExchangeData.h"

@implementation NSString (ExchangeData)

//四舍五入
+(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];

    return [NSString stringWithFormat:@"%@",roundedOunces];
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString; 
    
    
}

//普通字符串转换为十六进制的
+ (NSString *)hexStringFromString:(NSString *)string {
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

//获取系统当前时间
+ (NSString *)getCurrentTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];//东九区时间

    //有效真实时间
//    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

    NSString *dataTime = [formatter stringFromDate:[NSDate date]];
    return dataTime;
}

//数值转换
+ (NSString *)getChangeNumberData:(NSString *)number {

    int num = [number intValue] > 0 ? [number intValue]:0;

    if(num > 9999) {

        int t = num/10000;
        int z = num%1000;
        return [NSString stringWithFormat:@"%ld.%ld万",t,z];
    }

    return [NSString stringWithFormat:@"%ld",num];
}

//比较时间大小
//日期格式请传入：2013-08-05 12:12:12；如果修改日期格式，比如：2013-08-05，则将[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];修改为[df setDateFormat:@"yyyy-MM-dd"];

+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}
//NSDate ---> NSString
+ (NSString *)dateExchangeToString:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

//NSString ---> NSDate
+ (NSDate *)stringExchangeToDate:(NSString *)string {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}

//获取当前时间戳
+ (NSString *)getCurrentTimesAboutTimestamp

{
    
    NSDate *date = [NSDate date];
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970]*1000;
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeInterval];
    
    return timeString;
    
}

//时间字符串转时间戳
+ (NSString *)timestampFromdataString:(NSString *)dataString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [dateFormatter dateFromString:dataString];
    
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeInterval];
    
    return timeString;
}

//时间戳转日期字符串 YYYY年MM月dd日 HH:mm
+ (NSString *)stringExchangeToDataAboutTimestamp:(NSString *)string {
    
    NSString *time = string;
    
    NSInteger num = [time integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY年MM月dd日   HH:mm"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

//时间戳转日期字符串 YYYY年MM月dd日
+ (NSString *)stringExchangeToDataAboutTimestamp1:(NSString *)string {
    
    NSString *time = string;
    
    NSInteger num = [time integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"MM月dd日"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

//时间戳转日期字符串 YYYY年MM月dd日HH时
+ (NSString *)stringExchangeToDataAboutTimestamp2:(NSString *)string {
    
    NSString *time = string;
    
    NSInteger num = [time integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY年MM月dd日HH时"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

//时间戳转日期字符串 MM.YY hh:mm
+ (NSString *)stringExchangeToDataAboutTimestamp3:(NSString *)string {
    
    NSString *time = string;
    
    NSInteger num = [time integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    NSArray *arr1 = [confromTimespStr componentsSeparatedByString:@" "];
    NSArray *arr2 = [arr1[0] componentsSeparatedByString:@"-"];
    NSString *str = [NSString stringWithFormat:@"%@.%@ %@",arr2[1],arr2[2],arr1[1]];
    
    return str;
}

//时间戳转日期字符串 YYYY-MM-dd
+ (NSString *)stringExchangeToDataAboutTimestamp4:(NSString *)string {

    NSString *time = string;
    
    NSInteger num = [time integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY/MM/dd"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

//时间戳转日期字符串 YYYY-MM-dd HH:mm
+ (NSString *)stringExchangeToDataAboutNumberTimestamp:(NSString *)string {
    
    NSString *time = string;
    
    NSInteger num = [time integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

//时间戳转日期字符串 YYYY-MM-dd HH:mm:ss
+ (NSString *)stringExchangeToDataAboutNumberTimestamp2:(NSString *)string {

    if(string.length > 10) {
        string = [string substringToIndex:string.length - 3];
    }
    NSString *time = string;
    
    NSInteger num = [time integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

+ (NSString *)stringExchangeToDataAboutNumberTimestamp13:(NSString *)string {
    
    if(string.length > 10) {
        string = [string substringToIndex:string.length - 3];
    }
    NSString *time = string;
    
    NSInteger num = [time integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"dd-MM-YYYY"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}


//时间戳转自定义时间字符串
+ (NSString *)timeStampExchangeToCustomStringAboutTimestamp:(NSString *)string {
    
    NSArray *dateArr = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Now",@"Dec"];
    NSString *str = [NSString stringExchangeToDataAboutNumberTimestamp:string];
    //第一个日期 第二个时间
    NSArray *array = [str componentsSeparatedByString:@" "];
    //获取日期
    NSString *dateStr = array[0];
    //年 月 日
    NSArray *arr1 = [dateStr componentsSeparatedByString:@"-"];
    dateStr = [NSString stringWithFormat:@"%@%@",dateArr[[arr1[1] integerValue]],arr1[2]];
    
    return [NSString stringWithFormat:@"%@ %@",array[1],dateStr];
}

//计算某个时间到现在是多少月／天／时
+ (NSString *)getUTCFormateDate:(NSString *)newsDate
{
    //    newsDate = @"2013-08-09 17:01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSLog(@"newsDate = %@",newsDate);
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int month=((int)time)/(3600*24*30);
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minute=((int)time)%(3600*24)/60;
    NSLog(@"time=%d",(double)time);
    
    NSString *dateContent;
    
    if(month!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",month,@"个月前"];
        
    }else if(days!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",days,@"天前"];
    }else if(hours!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",hours,@"小时前"];
    }else {
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",minute,@"分钟前"];
    }
    
    //    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    
    return dateContent;
}

//计算某一是时间距离某一时间天、时、分、秒
+ (NSArray *)getTimeData:(NSString *)timeOne toOtherTimeData:(NSString *)timeTwo {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    //创建日期对象
    NSString *str1 = [self stringExchangeToDataAboutNumberTimestamp2:timeOne];
    NSString *str2 = [self stringExchangeToDataAboutNumberTimestamp2:timeTwo];
    NSDate *date1 = [dateFormatter dateFromString:str1];
    NSDate *date = [dateFormatter dateFromString:str2];

    //计算时间间隔（单位是秒）
    NSTimeInterval time = [date1 timeIntervalSinceDate:date];

    //计算天数、时、分、秒

    int days = ((int)time)/(3600*24);

    int hours = ((int)time)%(3600*24)/3600;

    int minutes = ((int)time)%(3600*24)%3600/60;

    int seconds = ((int)time)%(3600*24)%3600%60;

    return @[[NSString stringWithFormat:@"%d",days],
             [NSString stringWithFormat:@"%d",hours],
             [NSString stringWithFormat:@"%d",minutes],
             [NSString stringWithFormat:@"%d",seconds]];
}

//时间戳转固定时间段
+ (NSString *)getMonthFormateDate:(NSString *)newsDate {
    //    newsDate = @"2013-08-09 17:01";
    newsDate = [self stringExchangeToDataAboutNumberTimestamp:newsDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    NSLog(@"newsDate = %@",newsDate);
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int month=((int)time)/(3600*24*30);
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minute=((int)time)%(3600*24)/60;
    NSLog(@"time=%zd",(double)time);
    
    NSArray *dataArr = [newsDate componentsSeparatedByString:@" "];
    
    if(month!=0 || days > 7){
        
        return  [dataArr[0] substringFromIndex:2];
        
    }else if(days >= 1){
        
        return  [NSString stringWithFormat:@"%zd天前",days];
    }else if(hours >= 1){
        
        return [NSString stringWithFormat:@"%zd小时前",hours];
    }else if(minute >= 1){

        return [NSString stringWithFormat:@"%zd分钟前",minute];
    }else {

        return @"刚刚";
    }
}


//时间戳转固定时间段2
+ (NSString *)getMonthFormateDateWeek:(NSString *)newsDate {
    //    newsDate = @"2013-08-09 17:01";
    newsDate = [self stringExchangeToDataAboutNumberTimestamp:newsDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSLog(@"newsDate = %@",newsDate);
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];

    NSDate* current_date = [[NSDate alloc] init];

    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int month=((int)time)/(3600*24*30);
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minute=((int)time)%(3600*24)/60;
    NSLog(@"time=%zd",(double)time);

    //当前传入时间
    NSArray *nowArr1 = [newsDate componentsSeparatedByString:@" "];
    nowArr1 = [nowArr1[0] componentsSeparatedByString:@"-"];

    //获取当前系统时间
    NSString *tep = [self getCurrentTimesAboutTimestamp];
    NSString *str = [self stringExchangeToDataAboutTimestamp3:tep];
    NSArray *nowArr = [str componentsSeparatedByString:@" "];
    nowArr = [nowArr[0] componentsSeparatedByString:@"-"];

    if([nowArr[0] integerValue] > [nowArr1[0] integerValue]) {
        //系统年份大于
    }

    NSArray *dataArr = [newsDate componentsSeparatedByString:@" "];

    if(month!=0 || days >= 6){

        return  [dataArr[0] substringFromIndex:2];

    }else if(days > 1){

        return  [NSString stringWithFormat:@"%@",[self getWeekDayFordate:[newsDate integerValue]]];
    }else {

        return [NSString stringWithFormat:@"%@",@"今天"];
    }
}



//时间转星期
+ (NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"星期天",@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];

    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];

    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}



@end
