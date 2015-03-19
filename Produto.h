//
//  Produto.h
//  péBaixo
//
//  Created by Matheus Becker on 02/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Produto : NSObject

@property(nonatomic,retain)NSString *generoProduto;
@property(nonatomic, retain)NSString *descricao;
@property(nonatomic, retain)NSString *distancia;
@property(nonatomic, retain)NSString *preco;
@property(nonatomic, retain)NSString *produto_id;
@property(nonatomic, retain)NSString *urlImagemProduto;
@property(nonatomic, retain)NSString *tempo;
@property(nonatomic, retain)NSString *status;

-(id)initWithAttributes:(NSDictionary *)attributes;

@end
