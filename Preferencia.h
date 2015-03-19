//
//  Preferencia.h
//  péBaixo
//
//  Created by Matheus Becker on 23/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Preferencia : NSObject

+(void)setString:(NSString *)valor chave:(NSString *)chave;

+(NSString *) getString:(NSString *)chave;

+(void) setInteger:(NSInteger)valor chave:(NSString *)chave;

+(NSInteger)getInteger:(NSString *)chave;

@end
