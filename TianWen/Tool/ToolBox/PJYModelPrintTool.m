//
//  PJYModelPrintTool.m
//  Text
//
//  Created by Xcode on 2018/3/8.
//  Copyright © 2018年 Xcode. All rights reserved.
//

#import "PJYModelPrintTool.h"
@interface PJYModelPrintTool ()
@property (nonatomic, strong) NSMutableString *resultString;
@end

@implementation PJYModelPrintTool

+ (void)printWithData:(id)data {
    PJYModelPrintTool *tool = [[PJYModelPrintTool alloc] init];
    [tool printWithData:data grade:0 spaceString:@""];
    NSLog(@"%@", tool.resultString);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _resultString = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)printWithData:(id)data grade:(int)grade spaceString:(NSString *)spaceString {
    if ([data isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in data) {
            if (![data[key] isKindOfClass:[NSDictionary class]] && ![data[key] isKindOfClass:[NSArray class]]) {
                [_resultString appendFormat:@"%@@property (nonatomic, copy) NSString *%@\n",spaceString, key];
            }else {
                if ([data[key] isKindOfClass:[NSDictionary class]]) {
                    [_resultString appendFormat:@"%@******** Dictionary: %@\n",spaceString, key];
                }else if ([data[key] isKindOfClass:[NSArray class]]) {
                    [_resultString appendFormat:@"%@******** Array: %@\n",spaceString, key];
                }
                NSMutableString *newString = [NSMutableString stringWithString:spaceString];
                [newString insertString:@"-" atIndex:0];
                [self printWithData:data[key] grade:grade + 1 spaceString:newString];
            }
        }
    }else if ([data isKindOfClass:[NSArray class]]) {
        for (id obj in data) {
            NSMutableString *newString = [NSMutableString stringWithString:spaceString];
            [newString insertString:@"-" atIndex:0];
            [self printWithData:obj grade:grade + 1 spaceString:newString];
        }
    }else {
        [_resultString appendFormat:@"%@+++++++++++++++++++++%@\n", spaceString, data];

        NSLog(@"%@+++++++++++++++++++++%@", spaceString, data);
    }
    
    
}

@end
