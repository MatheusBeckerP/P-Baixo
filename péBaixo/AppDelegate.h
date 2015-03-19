//
//  AppDelegate.h
//  péBaixo
//
//  Created by Matheus Becker on 02/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *DISTANCIA;

NSString *LON;

NSString *LAT;

NSMutableArray *FAVORITOS;

NSString *ORDENACAO;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) NSString *DISTANCIA;

@property(nonatomic) NSString *LON;

@property(nonatomic) NSString *LAT;

@property(nonatomic) NSString *OREDENACAO;

@property (strong, nonatomic) UIWindow *window;



@end

