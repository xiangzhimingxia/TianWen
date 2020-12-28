//
//  HttpManager.m
//  中盾app
//
//  Created by 一路走一路寻 on 16/8/16.
//  Copyright © 2016年 Xcode. All rights reserved.
//

#import "HttpManager.h"
//#import "AFNetworking.h"

#import "JRToast.h"

NSString const  * stateKey = @"status";
NSString const * messageKey = @"msg";
NSString const * listKey = @"data";

NSString *const MSG_STR_SUCCESS = @"success";
const NSInteger MSG_SUCCESS = 1;


@implementation HttpManager

+(void)getWithURL:(NSString *)url andParams:(NSDictionary *)params returnBlcok:(returnBlock)block{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/plain", @"text/javascript",@"text/html", nil];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    if (params) {
        if ([params objectForKey:@"token"]) {
            [manager.requestSerializer setValue:[params objectForKey:@"token"] forHTTPHeaderField:@"token"];
            NSMutableDictionary *oneParams = [NSMutableDictionary dictionaryWithDictionary:params];            
            [oneParams removeObjectForKey:@"token"];
            params = [oneParams copy];
        }
    }

    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//             NSLog(@"这里打印请求成功要做的事");
             ZWLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",params,url,responseObject);
             //成功
             block(nil,responseObject);
         }

         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {

             //这里打印错误信息
             ZWLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",params,url,error.userInfo);
             
             [MBProgressHUD hideAllHUDsForView:[self currentViewController].view animated:YES];
             [JRToast showWithText:ErrorShowInView];
             //失败
             block(error,nil);
         }];
        
}

+(void)postWithURL:(NSString *)url andParams:(id)params returnBlcok:(returnBlock)block{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/plain", @"text/javascript", nil];
    
    if (params) {
        if ([params objectForKey:@"token"]) {
            [manager.requestSerializer setValue:[params objectForKey:@"token"] forHTTPHeaderField:@"token"];
            NSMutableDictionary *oneParams = [NSMutableDictionary dictionaryWithDictionary:params];
//            params = [NSMutableDictionary dictionaryWithDictionary:params];
//            [params removeObjectForKey:@"token"];
            [oneParams removeObjectForKey:@"token"];
            params = [oneParams copy];
        }
    }
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {


    } progress:^(NSProgress * _Nonnull uploadProgress) {

        ZWLog(@"url = %@",manager.baseURL);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        ZWLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",params,url,responseObject);
        //成功
        block(nil,responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        ZWLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",params,url,error.userInfo);
        
        [MBProgressHUD hideAllHUDsForView:[self currentViewController].view animated:YES];
        [JRToast showWithText:ErrorShowInView];
        //失败
        block(error,nil);
    }];

}

+ (void)postNotHeadWithURL:(NSString *)url andParams:(id)params returnBlcok:(returnBlock)block {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if (params) {
        if ([params objectForKey:@"token"]) {
            [manager.requestSerializer setValue:[params objectForKey:@"token"] forHTTPHeaderField:@"token"];
            NSMutableDictionary *oneParams = [NSMutableDictionary dictionaryWithDictionary:params];            
            [oneParams removeObjectForKey:@"token"];
            params = [oneParams copy];
        }
    }

    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

        ZWLog(@"url = %@",manager.baseURL);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        ZWLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",params,url,responseObject);
        //成功
        block(nil,responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        ZWLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",params,url,error.userInfo);
        
        [MBProgressHUD hideAllHUDsForView:[self currentViewController].view animated:YES];
        [JRToast showWithText:ErrorShowInView];
        //失败
        block(error,nil);
    }];
}

+(void)putWithURL:(NSString *)url andParams:(NSDictionary *)params returnBlcok:(returnBlock)block{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//        ZWLog(@"这里打印请求成功要做的事");
        ZWLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",params,url,responseObject);
        //成功
        block(nil,responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        //这里打印错误信息
        ZWLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",params,url,error.userInfo);
        //失败
        block(error,nil);
    }];
}

+(void)deleteWithURL:(NSString *)url andParams:(NSDictionary *)params returnBlcok:(returnBlock)block{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//        NSLog(@"这里打印请求成功要做的事");
        ZWLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",params,url,responseObject);
        //成功
        block(nil,responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        //这里打印错误信息
        ZWLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",params,url,error.userInfo);
        //失败
        block(error,nil);

    }];
}

+(void)postWithURL:(NSString *)url andParams:(NSDictionary *)params imageFiles:(NSArray *)files withFilesName:(NSString *)name returnBlcok:(returnBlock)block {

    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //2.上传文件

    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数

        for (NSInteger i=0;i<files.count;i++) {

            //            NSData *data = UIImageJPEGRepresentation(files[i], 0.5);
            NSString *Name = [NSString stringWithFormat:@"%@[%zd]",name,i];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",Name];
            [formData appendPartWithFileData:files[i] name:Name fileName:fileName mimeType:@"image/png"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {

        //打印下上传进度
        ZWLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //请求成功
        ZWLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",params,url,responseObject);
        //成功
        block(nil,responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        //请求失败
        ZWLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",params,url,error.userInfo);
        
        [MBProgressHUD hideAllHUDsForView:[self currentViewController].view animated:YES];
        [JRToast showWithText:ErrorShowInView];
        //失败
        block(error,nil);
    }];

}

+(void)postWithURL1:(NSString *)url andParams:(NSDictionary *)params imageFiles:(NSArray *)files withFilesName:(NSString *)name returnBlcok:(returnBlock)block {

    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //2.上传文件

    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数

        for (NSInteger i=0;i<files.count;i++) {

            NSData *data = UIImageJPEGRepresentation(files[i], 0.5);
//            NSString *Name = [NSString stringWithFormat:@"%@[%zd]",name,i];
            NSString *Name = [NSString stringWithFormat:@"%@",name];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",Name];
            [formData appendPartWithFileData:data name:Name fileName:fileName mimeType:@"image/png"];
            
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {

        //打印下上传进度
        ZWLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //请求成功
        ZWLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",params,url,responseObject);
        //成功
        block(nil,responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        //请求失败
        ZWLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",params,url,error.userInfo);
        
        [MBProgressHUD hideAllHUDsForView:[self currentViewController].view animated:YES];
        [JRToast showWithText:ErrorShowInView];
        //失败
        block(error,nil);
    }];

}

+(void)postWithURL3:(NSString *)url andParams:(NSDictionary *)params voiceFiles:(NSString *)files withFilesName:(NSString *)name returnBlcok:(returnBlock)block {
    
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.上传文件
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数
        
        NSString *Name = [NSString stringWithFormat:@"%@",name];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3",Name]; //wav
        
        // application/octet-stream  任意的二进制数据类型
        // audio/mpeg  mp3数据类型
//        [formData appendPartWithFileURL:files name:Name fileName:fileName mimeType:@"application/octet-stream" error:nil];  //用于上传本地wav格式的音频文件
        
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:files] name:Name fileName:fileName mimeType:@"audio/mpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        ZWLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        ZWLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",params,url,responseObject);
        //成功
        block(nil,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        ZWLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",params,url,error.userInfo);
        
        [MBProgressHUD hideAllHUDsForView:[self currentViewController].view animated:YES];
        [JRToast showWithText:ErrorShowInView];
        //失败
        block(error,nil);
    }];
    
}


+(void)setImageView:(UIImageView *)imageView withURL:(NSString *)imageUrl{

    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];

}

+(void)getParamsWithURL:(NSString *)url andParams:(NSDictionary *)params returnBlcok:(returnBlock)block{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/plain", @"text/javascript",@"text/html", nil];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSString *utype = [NSString string];

//    if ([[DemoGlobalClass sharedInstance].userType integerValue] == 1) {
//        utype = @"1";
//    }else{
//        utype = @"2";
//    }

    NSMutableDictionary *mutParams = [NSMutableDictionary dictionaryWithDictionary:params];

    [mutParams setValue:utype forKey:@"utype"];

    [manager GET:url parameters:mutParams progress:^(NSProgress * _Nonnull downloadProgress) {

    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//             NSLog(@"这里打印请求成功要做的事");
             [self nslogFullUrlWith:mutParams andUrl:url];
             ZWLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",params,url,responseObject);
             //成功
             block(nil,responseObject);
         }

         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {

             //这里打印错误信息
             ZWLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",params,url,error.userInfo);
             
             [MBProgressHUD hideAllHUDsForView:[self currentViewController].view animated:YES];
             [JRToast showWithText:ErrorShowInView];
             //失败
             block(error,nil);
         }];

}

+(void)nslogFullUrlWith:(id  _Nullable)responseObject andUrl:(NSString *)url
{
#if DEBUG
    if (responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *paramDicString = [self keyValueStringWithDict:responseObject];
            NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@",url,paramDicString];
            ZWLog(@"拼接出的urlString是%@",fullUrlStr);
        }
    }
#endif
}

//NSLog 完整url
+ (NSString *)keyValueStringWithDict:(NSDictionary *)dict
{
    if (dict == nil) {
        return nil;
    }
    NSMutableString *string = [NSMutableString stringWithString:@"?"];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];

    if ([string rangeOfString:@"&"].length) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }

    return string;
}


+(UIViewController *)currentViewController
{
    
    UIViewController * currVC = nil;
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    UIViewController * Rootvc = keyWin.rootViewController;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    
    
    return currVC;
}

#pragma mark - 环信相关

//加密
+ (NSString *)SStrToMD5:(NSString *)aStr{

    //    NSString *firstMD5 = [JLKFUtil MD5Hash:aStr];
    //
    //    firstMD5 = [firstMD5 lowercaseString];
    
    //    NSString *appendStr = @"q!wse#r4t%yhu&i8o(p;";
    
    NSString *appendStr = @"kcapp";
    
    NSString *appendPassword = [aStr stringByAppendingString:appendStr];
    
    NSString *scoendMD5 = [JLKFUtil MD5Hash:appendPassword];
    
    scoendMD5 = [scoendMD5 lowercaseString];
    
    return scoendMD5;
}

@end
