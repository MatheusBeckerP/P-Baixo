//
//  SQLite.h
//  péBaixo
//
//  Created by Matheus Becker on 23/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface SQLite : NSObject{
    sqlite3 *bancoDeDados;
}

//Abre o banco de dados
-(void)abrir:(NSString *)nomeBanco;

//Fecha o banco de dados
-(void)fechar;

//retorna o sql para criar a tabela (deve ser implementada pela sub-classe)
-(NSString *)getSQLCreate;

@end
