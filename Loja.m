//
//  Loja.m
//  péBaixo
//
//  Created by Matheus Becker on 08/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "Loja.h"

@implementation Loja

-(id)initWithAttributes:(NSDictionary *)attributes{
    
    if (self = [super init]) {
        NSLog(@" Dicionário - %@", attributes);
        
        self.loja_id = attributes[@"store_id"];
        self.tempo = attributes[@"time"];
        self.nome = attributes[@"fantasia"];
        self.distancia = attributes[@"distance"];
        self.fone = attributes[@"telefone"];
        self.status = attributes[@"status"];
        self.urlImagemLoja = attributes[@"store_logo"];
        self.endereco = attributes [@"endereco"];
        self.latitude = attributes [@"latitude"];
        self.longitude = attributes [@"longitude"];
        self.preco = attributes [@"price"];
        
    }
    return self;
}

@end
