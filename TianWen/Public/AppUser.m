//
//  AppUser.m
//  BaseProject
//
//  Created by 朱伟 on 2017/8/6.
//  Copyright © 2017年 ZW. All rights reserved.
//

#import "AppUser.h"
#import<objc/runtime.h>

NSString * const YJGCAppUserKeyForUserDeatult = @"YJGCAppUserKeyForUserDeatult";

@implementation AppUser

- (void)updateLocalUser {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [ud setObject:data forKey:YJGCAppUserKeyForUserDeatult];
    if ([ud synchronize]) {
        NSLog(@"succ··essfully write user info to local");
    }
    else {
        NSLog(@"fail write user info to local");
    }
}

- (void)clearLocalUser {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:nil forKey:YJGCAppUserKeyForUserDeatult];
    if ([ud synchronize]) {
        NSLog(@"successfully write user info to local");
    }
    else {
        NSLog(@"fail write user info to local");
    }
}
- (void)loginWithData:(NSDictionary *)data{
    NSArray *props = [self getAllProperties];
    for (NSString *key in props) {
        if (data[key]) {
            [self setValue:data[key] forKey:key];
        }
    }
    [self updateLocalUser];
}

- (void)loginOut{
    
    NSDictionary *props = [self properties_aps];
    for (NSString *keys in [props allKeys]) {
        [self setValue:nil forKey:keys];
    }
    [self clearLocalUser];
}

- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    
    return props;
}
- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

+ (instancetype)user{
    
    static dispatch_once_t onceToken;
    static AppUser *appUser = nil;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [userDefaults objectForKey:YJGCAppUserKeyForUserDeatult];
        AppUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (user) {
                appUser = user;
            }
            else {
                appUser = [[AppUser alloc]init];
            }
    });
    return appUser;
}

#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
- (SEL) creatSetterWithPropertyName: (NSString *) propertyName param:(NSString *)param{
    NSString *str = [NSString stringWithFormat:@"set%@:%@",[propertyName capitalizedString],param];
    
    return NSSelectorFromString(str);
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivarLists = class_copyIvarList([AppUser class], &count);
    for (int i = 0; i < count; i++) {
        const char* name = ivar_getName(ivarLists[i]);
        NSString* strName = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:strName] forKey:strName];
    }
    free(ivarLists);
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivarLists = class_copyIvarList([AppUser class], &count);
        for (int i = 0; i < count; i++) {
            const char* name = ivar_getName(ivarLists[i]);
            NSString* strName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [aDecoder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivarLists);
    }
    return self;
}

- (void)setNilValueForKey:(NSString *)key{
    [self setValue:@"" forKey:key];
}

-(id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
