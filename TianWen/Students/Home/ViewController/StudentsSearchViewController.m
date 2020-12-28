//
//  StudentsSearchViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsSearchViewController.h"

@interface StudentsSearchViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;

@end

@implementation StudentsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

-(void)creatUI{
    self.titleLable.text = @"搜索页面";
    self.toTopHeightConstant.constant = SafeAreaTopHeight;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
