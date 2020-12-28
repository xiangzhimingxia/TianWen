//
//  FeedbankViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/11.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "FeedbankViewController.h"

@interface FeedbankViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;
@property (weak, nonatomic) IBOutlet UILabel *holdLb;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UILabel *numLb;

@end

@implementation FeedbankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

-(void)creatUI{
    self.titleLable.text = @"意见反馈";
    self.view.backgroundColor = MainBackgroundColor;
    self.toTopHeightConstant.constant = SafeAreaTopHeight + 20;
    self.submitView.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [self.submitView setTapActionWithBlock:^{
        [weakSelf submitAction];
    }];
}

-(void)submitAction{
    [self.view endEditing:YES];
    self.submitView.userInteractionEnabled = NO;
    [HttpManager postNotHeadWithURL:feedback_Mine andParams:@{@"token":User.token,@"content":self.textView.text} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            [MBProgressHUD showMessage:@"您的反馈已收到"];
            self.textView.text = nil;
            self.holdLb.hidden = NO;
            self.numLb.text = @"0/100";
            self.submitView.backgroundColor = KNavColorHalf;
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
            self.submitView.userInteractionEnabled = YES;
        }
    }];
}

-(void)changeFootViewColor{
    if (self.textView.text.length > 0) {
        self.submitView.backgroundColor = KNavColor;
        self.submitView.userInteractionEnabled = YES;
    }else{
        self.submitView.backgroundColor = KNavColorHalf;
        self.submitView.userInteractionEnabled = NO;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    
    [self changeFootViewColor];
    
    self.holdLb.hidden = textView.text.length > 0 ? YES : NO;
    
    float MAXSTRINGLENGTH = 100;//限定输入长度 不减1有bug 实际成了101了
    NSString *lang = [[[UITextInputMode activeInputModes] firstObject] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *range = [textView markedTextRange];
        UITextPosition *start = range.start;
        UITextPosition*end = range.end;
        NSInteger selectLength = [textView offsetFromPosition:start toPosition:end];
        NSInteger contentLength = textView.text.length - selectLength;
        
        if (contentLength > MAXSTRINGLENGTH) {
            textView.text = [textView.text substringToIndex:MAXSTRINGLENGTH];
            contentLength = MAXSTRINGLENGTH;
        }
        
        self.numLb.text = [NSString stringWithFormat:@"%lu/100",contentLength];
    }else{
        if (textView.text.length > MAXSTRINGLENGTH){
            textView.text = [textView.text substringToIndex:MAXSTRINGLENGTH];
        }
        
        self.numLb.text = [NSString stringWithFormat:@"%lu/100",textView.text.length];
    }
}

@end
