//
//  RuleExplainViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "RuleExplainViewController.h"

@interface RuleExplainViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;

@end

@implementation RuleExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

-(void)creatUI{
    self.titleLable.text = @"计费规则说明";
    self.toTopHeightConstant.constant = SafeAreaTopHeight + 20;
}

@end
