//
//  JLKFLuanchViewController.m
//  BaseProject
//
//  Created by 一路走一路寻 on 17/6/27.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "JLKFLuanchViewController.h"
#import "AppDelegate.h"
#import "JLKFBaseNavigationController.h"
#import "LaunchModel.h"

@interface JLKFLuanchViewController ()<UIScrollViewDelegate>
{
    int j;
}
@property (nonatomic,strong)UIScrollView *luanchScro;

@property (nonatomic,strong)UIView *luanchBcView;

@property (nonatomic, strong) NSMutableArray *imgArr;

@property (nonatomic,strong)UIPageControl *luanchPage;
@end

@implementation JLKFLuanchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgArr = [NSMutableArray array];

//    [self getPicData];
    [self butAction];
}

-(void)getPicData{
//    //test
//    self.imgArr = [NSMutableArray array];
//    for (NSInteger i = 0; i < 3; i ++) {
//        ANTHomeBannerModel *model = [[ANTHomeBannerModel alloc]init];
//        model.bannerImg = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=550869952,2458242240&fm=26&gp=0.jpg";
//        [self.imgArr addObject:model.bannerImg];
//    }
//    [self setGuidePage:self.imgArr.count];
//    //test end
//    return;

    
    /*
     
    [NetManager getBannerWithtype:@"2" complete:^(HYNetworkResult *result) {
        if (result.isSuccess) {
            for (NSDictionary *dic in result.data) {
                ANTHomeBannerModel *model = [ANTHomeBannerModel modelWithDictionary:dic];
                [self.imgArr addObject:model.bannerImg];
            }
            [self setGuidePage:self.imgArr.count];

            if (self.imgArr.count > 0) {
            }else{
                self.imgArr = [[NSMutableArray alloc]initWithObjects:@"",nil];
                [self butAction];
            }

        }else{
            [JRToast showWithText:result.error.hint];
            self.imgArr = [[NSMutableArray alloc]initWithObjects:@"",nil];
            [self butAction];
        }
    }];
     
     */
}

/**
 *  设置引导页
 *
 *  @param num 引导页数
 */
-(void)setGuidePage:(NSInteger)num{

    if (num > 0) {

        //底部View
        _luanchBcView = [[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_luanchBcView];

        _luanchScro = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _luanchScro.contentSize = CGSizeMake(_luanchScro.bounds.size.width * self.imgArr.count, _luanchScro.bounds.size.height);
        _luanchScro.pagingEnabled = YES;
        _luanchScro.bounces = NO;
        _luanchScro.showsHorizontalScrollIndicator = NO;
        // 隐藏垂直方向的滚动条
        _luanchScro.showsVerticalScrollIndicator = NO;
        _luanchScro.delegate = self;
        // 锁定方向，当确定一个方向之后就不能向另外一个方向滑动
        _luanchScro.directionalLockEnabled = YES;

        [_luanchBcView addSubview:_luanchScro];

//        [self addPage:self.imgArr.count];

        //加入图片
        for (int i = 0; i < self.imgArr.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_luanchScro.bounds.size.width * i, 0, _luanchScro.bounds.size.width, _luanchScro.bounds.size.height)];
            //网络请求的图片
//            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[i]] placeholderImage:[UIImage imageNamed:@"启动页1"]];
            //            imageView.image = KImageName(self.imgArr[i]);
            imageView.userInteractionEnabled = YES;
            [_luanchScro addSubview:imageView];

            UIImageView *titleImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RELX_big_logo"]];
            titleImg.frame = CGRectMake(0, 72.5, 21*(titleImg.image.size.width/titleImg.image.size.height), 21);
            titleImg.centerX = SCREEN_WIDTH/2.0;
            [imageView addSubview:titleImg];

            float startY = CGRectGetMaxY(titleImg.frame) + 36.5;
            UIImageView *tureImg = [[UIImageView alloc]init];
            tureImg.backgroundColor = SYHEXCOLOR(@"#1F2530");            
            tureImg.frame = CGRectMake(35.0,startY,SCREEN_WIDTH - 35.0 * 2.0, SCREEN_HEIGHT - 236.0 - startY);
            tureImg.centerX = SCREEN_WIDTH/2.0;
            [imageView addSubview:tureImg];
            [tureImg sd_setImageWithURL:[NSURL URLWithString:self.imgArr[i]] placeholderImage:[UIImage imageNamed:@"启动页1"]];

            startY = CGRectGetMaxY(tureImg.frame) + 23.0;
            UIView *pageView = [[UIImageView alloc]init];
            pageView.frame = CGRectMake(0,startY,0, 4);
            [imageView addSubview:pageView];
            float startX = 0;
            for (int j = 0; j < self.imgArr.count; j++){
                UIImageView *img = [[UIImageView alloc]init];
                if (j == i) {
                    [img setImage:KImageName(@"—_blue")];
                }else{
                    [img setImage:KImageName(@"—_gray")];
                }
                img.frame = CGRectMake(startX,0,20, 4);
                [pageView addSubview:img];
                imageView.userInteractionEnabled = pageView.userInteractionEnabled = YES;
                img.userInteractionEnabled = YES;
//                WEAKSELF
                [img setTapActionWithBlock:^{
//                    STRONGSELF
                    [self.luanchScro setContentOffset:CGPointMake(kScreenWidth*j,0) animated:YES];
                }];

                startX =CGRectGetMaxX(img.frame) + 8;
                pageView.width = CGRectGetMaxX(img.frame);
            }
            pageView.centerX = imageView.width / 2.0;

            if (i == self.imgArr.count - 1) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(35.0, kScreenHeight - 87.0 - 56.0, kScreenWidth - 35.0 * 2.0, 56.0);
                [button setTitle:@"开始使用" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.backgroundColor = SYHEXCOLOR(@"#0FA9DF");
                button.layer.cornerRadius = 25.0;
                button.clipsToBounds = YES;
                [button addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:button];
                imageView.userInteractionEnabled = YES;
            }
        }

    }else{//没有引导图 直接进入首页

    }
}

//加入page
- (void)addPage:(NSInteger)num
{
    //page视图
    _luanchPage = [UIPageControl new];

    //设置页数
    _luanchPage.numberOfPages = num;
    //当前page的颜色
    _luanchPage.currentPageIndicatorTintColor = [UIColor whiteColor];

    [_luanchBcView addSubview:_luanchPage];

    _luanchPage.frame = CGRectMake(kScreenWidth/2.0 - 30, kScreenHeight - 50, 60, 30);

}
#pragma mark - 定时器
//创建定时器
- (void)initTimer
{
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
}
//定时器执行的方法
- (void)timerChanged
{
    if (j <= 2)
    {
        j++;
    }
    if (_luanchScro.contentOffset.x < 2 *_luanchScro.bounds.size.width)
    {
        // 改变scrollView的偏移量
        [_luanchScro setContentOffset:CGPointMake(j * _luanchScro.bounds.size.width, 0) animated:YES];
    }



}
#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获取当前的点
    int currIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    // 修改当前点
    _luanchPage.currentPage = currIndex;
}


#pragma mark - 进入按钮

- (void)butAction
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoadGuide"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del initRootViewController];
}


@end

