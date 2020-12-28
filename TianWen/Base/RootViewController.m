//
//  RootViewController.m
//
//
//  Created by Xcode on 16/8/4.
//  Copyright © 2016年 Xcode. All rights reserved.
//

#import "RootViewController.h"
#import "JLKFBaseNavigationController.h"
#import "BGTabBar.h"
#import "UIImage+image.h"
#import "Toolbox.h"
#import "AppDelegate.h"
#import "StudentsHomeViewController.h"
#import "AskViewController.h"
#import "StudentsMineViewController.h"
#import "TeacherHomeViewController.h"
#import "TeacherMineViewController.h"

//static const CGFloat kDefaultPlaySoundInterval = 3.0;
//static NSString *kMessageType = @"MessageType";
//static NSString *kConversationChatter = @"ConversationChatter";
//
//#define RONGCLOUD_IM_Token @"OzIcdjL78xsbJHKKxw1OZGQwOQGWIiJqRIKeE6D2ouExqovUJZGTj4hgoHJx15GyDl5XXbx7KIr+GjzJEWn67AC0RRHN79WVCpSRpZaFMx1ANR5SInfzBOhjWEgfdE9e+z93AYADvAs="

#define TabBar_T_Color JColorFromRGB(0x0f0f0f)
//#define RGB(r, g, b)     RGBA(r, g, b, 1.0f)
//#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@interface RootViewController ()<UITabBarDelegate,UINavigationControllerDelegate>
{
    
    JLKFBaseNavigationController * homeNavC;
    JLKFBaseNavigationController * askNavC;
    JLKFBaseNavigationController * personNavC;
    JLKFBaseNavigationController * answerNavC;
}


@end

@implementation RootViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    UIView *backView=[[UIView alloc]initWithFrame:self.view.frame];
//    backView.backgroundColor=[UIColor whiteColor];
//
//    [self.tabBar insertSubview:backView atIndex:0];
//    self.tabBar.opaque=YES;

    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;

    self.tabBar.tintColor=TabBar_T_Color;
    
    //    添加所有子控制器
    [self setupChildController];
    
    //    修改tabbar上面分割线的大小和颜色，两个方法缺一不可
    UIImage *shadowImage = [Toolbox createImageWithColor:[UIColor clearColor]];
    [self.tabBar setShadowImage:shadowImage];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    self.tabBar.translucent = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 创建tabBar控制器

- (void)setupChildController{
    
//    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    /*
    CGRect rect = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *clearImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     */
    
    NSMutableArray *childVCArray = [[NSMutableArray alloc] initWithCapacity:5];
    if (User.isAnswer) {
        
        StudentsHomeViewController *homeVC = [[StudentsHomeViewController alloc] init];
        //    HomePageViewController *homeVC = [[HomePageViewController alloc] init];
        homeVC.title = @"先问辅导";
        homeNavC =[[JLKFBaseNavigationController alloc]initWithRootViewController:homeVC];
        [self setUpOneChildController:homeNavC image:[UIImage imageWithRenderImage:@"icon_product_inactive"] selectedImage:[UIImage imageWithRenderImage:@"icon_product_active"] title:@"首页"];
        [childVCArray addObject:homeNavC];
        
        
        TeacherHomeViewController *answerVC = [[TeacherHomeViewController alloc] init];
        answerVC.title = @"解答";
        answerNavC =[[JLKFBaseNavigationController alloc]initWithRootViewController:answerVC];
        [self setUpOneChildController:answerNavC image:[UIImage imageWithRenderImage:@"icon_social_inactive"] selectedImage:[UIImage imageWithRenderImage:@"icon_question_active"] title:@"解答"];
        [childVCArray addObject:answerNavC];
        
        //个人中心
        TeacherMineViewController *personVC = [[TeacherMineViewController alloc] init];
        personVC.title = @"我的";
        personNavC =[[JLKFBaseNavigationController alloc]initWithRootViewController:personVC];
        [self setUpOneChildController:personNavC image:[UIImage imageWithRenderImage:@"icon_mine_inactive"] selectedImage:[UIImage imageWithRenderImage:@"icon_mine_active"] title:@"我的"];
        
        [childVCArray addObject:personNavC];
        
    }else{
    
    StudentsHomeViewController *homeVC = [[StudentsHomeViewController alloc] init];
    //    HomePageViewController *homeVC = [[HomePageViewController alloc] init];
    homeVC.title = @"先问辅导";
    homeNavC =[[JLKFBaseNavigationController alloc]initWithRootViewController:homeVC];
    [self setUpOneChildController:homeNavC image:[UIImage imageWithRenderImage:@"icon_product_inactive"] selectedImage:[UIImage imageWithRenderImage:@"icon_product_active"] title:@"首页"];
    [childVCArray addObject:homeNavC];
    
    
    AskViewController *chatListVC = [[AskViewController alloc]init];
    chatListVC.title = @"提问";
    askNavC = [[JLKFBaseNavigationController alloc] initWithRootViewController:chatListVC];
    [self setUpOneChildController:askNavC image:[UIImage imageWithRenderImage:@"icon_social_inactive"] selectedImage:[UIImage imageWithRenderImage:@"icon_question_active"] title:@"提问"];
    
    [childVCArray addObject:askNavC];
    
    //个人中心
    StudentsMineViewController *personVC = [[StudentsMineViewController alloc] init];
    personVC.title = @"我的";
    personNavC =[[JLKFBaseNavigationController alloc]initWithRootViewController:personVC];
    [self setUpOneChildController:personNavC image:[UIImage imageWithRenderImage:@"icon_mine_inactive"] selectedImage:[UIImage imageWithRenderImage:@"icon_mine_active"] title:@"我的"];
    
    [childVCArray addObject:personNavC];
    
    }
    
//    BGTabBar *tabBar = [[BGTabBar alloc]initWithFrame:self.tabBar.frame];
//    [self setValue:tabBar forKeyPath:@"tabBar"];

    self.delegate = self;

    /*
    未登录设置
    */
//    BOOL isAlredyLogin = [DemoGlobalClass sharedInstance].isLogin;
//
//    if(!isAlredyLogin) {
//
//        LoginViewController *loginVC = [LoginViewController new];
//
//        [homeNavC pushViewController:loginVC animated:YES];
//    }
}


- (void)setTabBarBackGroundImage{
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);  
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"BG_IMG"]];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    BGTabBar *tabBar = [self valueForKey:@"tabBar"];
//    if(tabBarController.selectedIndex == 2){
//
//        //切换回原来的状态 不跳转
//         tabBarController.selectedIndex = self.oldSelectIndex;
//        NSLog(@"发布视频和图片");
//        [self PublishButtonClicked:nil];
//
//    }
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    return YES;
//    if (tabBarController.selectedIndex == 2) {
//        return NO;
//    }else{
//        return YES;
//    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSLog(@"item = %@",item);
    
    //     [self setupUnreadMessageCount];
    
}

#pragma mark 添加每一个子控制器的属性
- (void)setUpOneChildController: (UIViewController *)vc image: (UIImage *)image selectedImage: (UIImage *)selectedImage title: (NSString *)title{
    
    vc.tabBarItem.title = title;
    
    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);

    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
//    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:JColorFromRGB(0xfc3973), NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightThin]} forState:UIControlStateSelected];

    //正常状态
    NSMutableDictionary * normalAtts = [NSMutableDictionary dictionary];
    normalAtts[NSFontAttributeName] = [UIFont fontWithName:@"HiraginoSansGB-W3" size:12];

    normalAtts[NSForegroundColorAttributeName] = JColorFromRGB(0x666666);
    [vc.tabBarItem setTitleTextAttributes:normalAtts forState:UIControlStateNormal];

    //选中状态
    NSMutableDictionary *selectAtts = [NSMutableDictionary dictionary];
    selectAtts[NSFontAttributeName] = [UIFont fontWithName:@"HiraginoSansGB-W3" size:12];
    selectAtts[NSForegroundColorAttributeName] = JColorFromRGB(0x49CA6D);
    [vc.tabBarItem setTitleTextAttributes:selectAtts forState:UIControlStateSelected];
    [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];

    [self addChildViewController:vc];
}


-(UIViewController *)currentViewController
{

    UIViewController * currVC = nil;
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    UIViewController * Rootvc = keyWin.rootViewController;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);


    return currVC;
}

- (void)dealloc {
    
    //移除观察者 self
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIViewController*)SY_currentViewController
{
    UIViewController* vc = self ;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tab = (UITabBarController*)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* nav = (UINavigationController*)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        }
        else {
            return tab.selectedViewController;
        }
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = (UINavigationController*)vc;
        return [nav.viewControllers lastObject];
    }
    else {
        return vc;
    }
    return nil;
}

@end
