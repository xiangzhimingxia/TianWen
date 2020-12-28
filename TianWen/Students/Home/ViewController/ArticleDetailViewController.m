//
//  ArticleDetailViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleModel.h"

@interface ArticleDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewWidthConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

kUI(ArticleModel, model);

@end

@implementation ArticleDetailViewController

-(ArticleModel *)model{
    if (!_model) {
        _model = [ArticleModel new];
    }
    return _model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self requestData];
}

-(void)creatUI{
    self.titleLable.text = @"文章详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.backViewWidthConstant.constant = KMainScreenWidth;
    self.backViewHeightConstant.constant = KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight;
    self.toTopHeightConstant.constant = SafeAreaTopHeight;
 
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.bounces = NO;
}

-(void)requestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager getWithURL:questionDetails_Home andParams:@{@"token":User.token,@"questionId":self.questionId} returnBlcok:^(NSError *error, id obj) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.model = [ArticleModel mj_objectWithKeyValues:obj[dataKey][@"question"]];
            [self setUIAction];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}

-(void)setUIAction{
    
    self.titleLb.text = self.model.questionName;
    [self.webView loadHTMLString:self.model.answer baseURL:nil];
    //            [self.webView sizeToFit];
    //            self.webView.scalesPageToFit = YES;
    if ([self.model.isFollow integerValue] == 1) {
        self.focusBtn.selected = YES;
    }else{
        self.focusBtn.selected = NO;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.focusBtn setTapActionWithBlock:^{
        [weakSelf postFocusWith:weakSelf.focusBtn.isSelected WithBtn:weakSelf.focusBtn WithId:self.model.questionId];
    }];
    
}

-(void)postFocusWith:(BOOL)isSelect WithBtn:(UIButton *)sender WithId:(NSString *)userID{
    sender.enabled = NO;
    [HttpManager postNotHeadWithURL:follow_Home andParams:@{@"token":User.token,@"followType":@"1",@"relationId":userID,@"relationType":@"0"} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            sender.enabled = YES;
            sender.selected = !isSelect;
            if (self.block) {
                self.block();
            }
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}

@end
