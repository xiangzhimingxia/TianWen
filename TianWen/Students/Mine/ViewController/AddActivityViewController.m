//
//  AddActivityViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/2.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "AddActivityViewController.h"

@interface AddActivityViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;

@end

@implementation AddActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

-(void)creatUI{
    
    self.titleLable.text = @"上传作品";
    self.toTopHeightConstant.constant = SafeAreaTopHeight + 20;
}

@end
