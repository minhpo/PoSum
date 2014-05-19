//
//  TabBarControllerViewController.m
//  PoSum
//
//  Created by Po Sam on 19/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "TabBarControllerViewController.h"

@interface TabBarControllerViewController ()

@end

@implementation TabBarControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTabBarIcons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTabBarIcons {
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName:TabBarTextFont, NSForegroundColorAttributeName:LifesumGreen } forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName:TabBarTextFont } forState:UIControlStateNormal];
    
    UITabBarItem *categoryTabBarItem = self.tabBar.items[0];
    categoryTabBarItem.image = [[UIImage imageNamed:@"TabCategory-Passive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    categoryTabBarItem.selectedImage = [[UIImage imageNamed:@"TabCategory"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *foodTabBarItem = self.tabBar.items[1];
    foodTabBarItem.image = [[UIImage imageNamed:@"TabFood-Passive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    foodTabBarItem.selectedImage = [[UIImage imageNamed:@"TabFood"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *exerciseTabBarItem = self.tabBar.items[2];
    exerciseTabBarItem.image = [[UIImage imageNamed:@"TabExercise-Passive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    exerciseTabBarItem.selectedImage = [[UIImage imageNamed:@"TabExercise"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
