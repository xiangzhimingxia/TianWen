//
//  AppDelegate.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/12.
//  Copyright © 2020 ZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@protocol PayResultDelegate <NSObject>

-(void)WechatPaySuccess;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) RootViewController * tabBarVc;

@property (nonatomic, weak) id<PayResultDelegate>payDelegate;

- (void)initRootViewController;

@end

