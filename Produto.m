//
//  Produto.m
//  péBaixo
//
//  Created by Matheus Becker on 02/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "Produto.h"

@implementation Produto

-(id)initWithAttributes:(NSDictionary *)attributes{
    
    if (self = [super init]) {
        NSLog(@" Dicionário - %@", attributes);
        
        self.produto_id = attributes[@"prod_id"];
        self.tempo = attributes[@"time"];
        self.descricao = attributes[@"description"];
        self.distancia = attributes[@"distance"];
        self.preco = attributes[@"price"];
        self.status = attributes[@"status"];
        self.urlImagemProduto = attributes[@"photo"];
        self.generoProduto = attributes [@"gen"];
    }
    return self;
}

@end
