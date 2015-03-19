//
//  SQLite.m
//  péBaixo
//
//  Created by Matheus Becker on 23/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "SQLite.h"

@implementation SQLite

-(NSString *)caminhoDoArquivo:(NSString *)nomeBanco{
    NSString *db = [NSString stringWithFormat:@"%@.sqlite3", nomeBanco];
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *caminhoArquivo = [documentsDirectory stringByAppendingPathComponent:db];
    NSLog(@"DB %@", caminhoArquivo);
    return caminhoArquivo;
}

- (void) abrir:(NSString *)nomeBanco {
    int result = sqlite3_open([[self caminhoDoArquivo:nomeBanco] UTF8String], &bancoDeDados);
    if (result == SQLITE_OK) {
        // Se o banco foi aberto com successo
        // Solicita a sub-classe para retornar o SQL para a criação da tabela
        NSString *sql = [self getSQLCreate];
        char *erroMsg;
        // Executa o SQL para criar a tabela, se necessário
        int resultado = sqlite3_exec (bancoDeDados, [sql UTF8String],NULL, NULL, &erroMsg);
        if (resultado == SQLITE_OK) {
            // Tabela criada com successo
        } else {
            NSString *error = [NSString stringWithCString:erroMsg encoding:NSUTF8StringEncoding];
            NSLog(@"Erro ao criar a tabela %d - %@", result, error);
        }
    } else {
        NSLog(@"Erro ao abrir o banco de dados");
    }
}
// Fecha o banco de dados
- (void) fechar {
    sqlite3_close(bancoDeDados);
}
// Método que retorna o SQL utilizado para criar a tabela
- (NSString *)getSQLCreate {
    // Sub-classes precisam implementar
    return nil;
}
@end






