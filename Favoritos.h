//
//  Favoritos.h
//  péBaixo
//
//  Created by Matheus Becker on 23/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SQLite.h"
#import "Produto.h"

@interface Favoritos : SQLite

//retorna o SQL para criar o produto
-(NSString *)getSQLCreate;

//Salva um novo produto ou atualiza um já existente pelo_id
-(void) salvar:(Produto *)produto;

//Deleta o produto
-(void) deletar:(Produto *)produto;

//Busca produtos
- (NSMutableArray *)getProdutos;

@property(nonatomic)NSMutableArray *proFavorites;

@property (nonatomic) BOOL alertaDeAcao;

@end
