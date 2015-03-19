//
//  TabBarController.m
//  péBaixo
//
//  Created by Matheus Becker on 21/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "TabBarController.h"
#import "FavoritosViewController.h"
#import "Favoritos.h"
#import "AppDelegate.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Navigation

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    Favoritos *db = [Favoritos alloc];
    [db abrir:@"produtos"];
    [db getProdutos];
    [db fechar];
    FAVORITOS = db.proFavorites;
}

@end
