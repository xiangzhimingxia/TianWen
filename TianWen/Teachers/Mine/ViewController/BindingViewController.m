//
//  BindingViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/11.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "BindingViewController.h"

@interface BindingViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UIView *submitView;

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self creatUI];
}

-(void)creatUI{
    self.titleLable.text = @"绑定支付宝";
    self.toTopHeightConstant.constant = SafeAreaTopHeight + 15;
    if (self.isBank) {
        self.titleLable.text = @"绑定银行卡";
        self.nameTextfield.placeholder = @"请输入开户人名字";
        self.accountTextfield.placeholder = @"请输入开户行帐号";
    }
}

-(void)changeFootViewColor{
    if (self.nameTextfield.text.length > 0 && self.accountTextfield.text.length > 0) { 
        self.submitView.backgroundColor = KNavColor;
    }else{
        self.submitView.backgroundColor = KNavColorHalf;
    }
}

- (IBAction)nameTextChange:(id)sender {
    [self changeFootViewColor];
}

- (IBAction)accountTextChange:(id)sender {
    [self changeFootViewColor];
}

@end
