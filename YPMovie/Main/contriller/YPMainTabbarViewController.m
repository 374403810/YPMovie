//
//  YPMainTabbarViewController.m
//  YPMovie
//
//  Created by apple on 2017/4/21.
//  Copyright © 2017年 SP. All rights reserved.
//

#import "YPMainTabbarViewController.h"
#import "YPHomeViewController.h"
#import "YPTicketViewController.h"
#import "YPCinemaViewController.h"
#import "YPMeViewController.h"

@interface YPMainTabbarViewController ()

@end

@implementation YPMainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundColor=YPSYSTEMCOLOR(whiteColor);
    [self initFrame];
}

- (void)initFrame{
    //1 初始化子控制器
    YPHomeViewController * home = [[YPHomeViewController alloc]init];
    YPTicketViewController * ticket = [[YPTicketViewController alloc]init];
    YPCinemaViewController * cinema= [[YPCinemaViewController alloc]init];
    YPMeViewController * me = [[YPMeViewController alloc]init];
    
    UINavigationController * homeNav = [[UINavigationController alloc]initWithRootViewController:home];
    UINavigationController * ticketNav = [[UINavigationController alloc]initWithRootViewController:ticket];
    UINavigationController * cinemaNav = [[UINavigationController alloc]initWithRootViewController:cinema];
    UINavigationController * meNav = [[UINavigationController alloc]initWithRootViewController:me];
    
    //2 子控制器加入根控制器
    NSArray * viewContrs = @[homeNav,ticketNav,cinemaNav,meNav];
    [self setViewControllers:viewContrs animated:YES];
    UITabBar * tabbar = self.tabBar;
    
    [self setUpChildViewController:homeNav andTitle:@"首页" andNormalImageName:@"tab_home_normal" andSelectImageName:@"tab_home_select" andTabbar:tabbar andIndex:0];
    
    [self setUpChildViewController:ticketNav andTitle:@"购票" andNormalImageName:@"tab_ticket_normal" andSelectImageName:@"tab_ticket_select" andTabbar:tabbar andIndex:1];
    
    [self setUpChildViewController:cinemaNav andTitle:@"影院" andNormalImageName:@"tab_cinema_normal" andSelectImageName:@"tab_cinema_select" andTabbar:tabbar andIndex:2];
    
    [self setUpChildViewController:meNav andTitle:@"我" andNormalImageName:@"tab_me_normal" andSelectImageName:@"tab_me_select" andTabbar:tabbar andIndex:3];
    //改变字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YPCOLOR(43, 177, 223), NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
}
#pragma mark - 自定义tabbar按钮
- (void)setUpChildViewController:(UIViewController *)childVC andTitle:(NSString *)title andNormalImageName:(NSString *)normalImageName andSelectImageName:(NSString *)selectImageName andTabbar:(UITabBar *)tabbar andIndex:(NSInteger)index{
    childVC.title=title;
    UITabBarItem * item = [tabbar.items objectAtIndex:index];
    UIImage * normalImage = [UIImage imageNamed:selectImageName];
    UIImage * selectImage = [UIImage imageNamed:normalImageName];
    //不设置渲染
    [item setImage:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

@end
