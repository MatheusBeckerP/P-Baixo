//
//  Preferencia.m
//  péBaixo
//
//  Created by Matheus Becker on 23/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "Preferencia.h"

@interface Preferencia ()

@end

@implementation Preferencia

+(void)setString:(NSString *)valor chave:(NSString *)chave{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:valor forKey:chave];
    [prefs synchronize];
}

+(NSString *) getString:(NSString *)chave{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *valor = [prefs stringForKey:chave];
    return valor;
}

+(void) setInteger:(NSInteger)valor chave:(NSString *)chave{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:valor forKey:chave];
    [prefs synchronize];
}

+(NSInteger)getInteger:(NSString *)chave{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger i = [prefs integerForKey:chave];
    return i;
}
@end
