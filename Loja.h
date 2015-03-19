//
//  Loja.h
//  péBaixo
//
//  Created by Matheus Becker on 08/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loja : NSObject

@property(nonatomic,retain)NSString *loja_id;
@property(nonatomic,retain)NSString *nome;
@property(nonatomic,retain)NSString *urlImagemLoja;
@property(nonatomic,retain)NSString *distancia;
@property(nonatomic,retain)NSString *tempo;
@property(nonatomic,retain)NSString *fone;
@property(nonatomic,retain)NSString *endereco;
@property(nonatomic,retain)NSString *latitude;
@property(nonatomic,retain)NSString *longitude;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *preco;

-(id)initWithAttributes:(NSDictionary *)attributes;

@end
