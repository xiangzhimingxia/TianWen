//
//  WebViewViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/23.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self creatUI];
}

-(void)creatUI{
    self.titleLable.text = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight)];
//    [self.webView sizeToFit];
//    self.webView.scalesPageToFit = YES;
//    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    switch (self.type) {
        case 0:{
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
        }
            break;
        case 1:{
            self.titleLable.text = @"计费规则";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"设置1计费规则.docx" ofType:nil];
            NSData *data = [NSData dataWithContentsOfFile:path];
            [self.webView loadData:data MIMEType:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document" textEncodingName:@"UTF-8" baseURL:nil];
            [self.webView sizeToFit];
            self.webView.scalesPageToFit = YES;
        }
            break;
        case 2:{
            self.titleLable.text = @"帮助中心";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"设置2帮助中心.docx" ofType:nil];
            NSData *data = [NSData dataWithContentsOfFile:path];
            [self.webView loadData:data MIMEType:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document" textEncodingName:@"UTF-8" baseURL:nil];
            [self.webView sizeToFit];
            self.webView.scalesPageToFit = YES;
        }
            break;
        case 3:{
            self.titleLable.text = @"联系我们";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"设置3联系我们.docx" ofType:nil];
            NSData *data = [NSData dataWithContentsOfFile:path];
            [self.webView loadData:data MIMEType:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document" textEncodingName:@"UTF-8" baseURL:nil];
            [self.webView sizeToFit];
            self.webView.scalesPageToFit = YES;
        }
            break;
        case 4:{
            self.titleLable.text = @"先问辅导用户服务协议";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"用户注册协议及隐私政.docx" ofType:nil];
            NSData *data = [NSData dataWithContentsOfFile:path];
            [self.webView loadData:data MIMEType:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document" textEncodingName:@"UTF-8" baseURL:nil];
            [self.webView sizeToFit];
            self.webView.scalesPageToFit = YES;
        }
            break;
        default:
            break;
    }
}

@end
