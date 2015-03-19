//
//  Favoritos.m
//  péBaixo
//
//  Created by Matheus Becker on 23/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "Favoritos.h"
#import "Produto.h"

@implementation Favoritos
@synthesize proFavorites;
@synthesize alertaDeAcao;

//Retorna o SQL para criar o produto
- (NSString *)getSQLCreate {
    NSString *sql = @"create table if not exists produto (produto_id integer primary key autoincrement, tempo text, descricao text, distancia text, status text, urlImagemProduto text, generoProduto text, preco text);";
    return sql;
}

//Salvar um novo produto ou atualizar um já existente pelo "produto_id"
-(void) salvar:(Produto *)produto{
    char *sql = "insert or replace into produto(produto_id, tempo, descricao, distancia, status, urlImagemProduto, generoProduto, preco) VALUES(?,?,?,?,?,?,?,?);";
    sqlite3_stmt *stmt;
    int resultado = sqlite3_prepare_v2(bancoDeDados, sql, -1, &stmt, nil);
    if (resultado == SQLITE_OK) {
        //se for nulo insere, senão atualiza
        if (produto.produto_id >0) {
            //informa o id para fazer update
            sqlite3_bind_int(stmt, 1, [produto.produto_id intValue]);
        }
        sqlite3_bind_text(stmt, 2, [produto.tempo UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [produto.descricao UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 4, [produto.distancia UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 5, [produto.status UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 6, [produto.urlImagemProduto UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 7, [produto.generoProduto UTF8String], -1, nil);
        NSLog(@"%@ preço", produto.preco);
        sqlite3_bind_double(stmt, 8, [produto.preco doubleValue]);
        //Executa o SQL
        resultado = sqlite3_step(stmt);
        if (resultado == SQLITE_DONE) {
            //Inserido com sucesso
            NSLog(@"Produto Inserido com sucesso");
            alertaDeAcao = YES;
        }
        sqlite3_finalize(stmt);
    }else{
        NSLog(@"Erro ao inserir produto %d", resultado);
        alertaDeAcao = NO;
        return;
    }
}

- (NSMutableArray *)getProdutos{
    // Array que vai armazenar a lista de produtos
    NSMutableArray* proFavoritos = [[NSMutableArray alloc] init] ;
    // SQL para selecionar todos os produtos pelo tipo informado
    NSString *query = @"select produto_id, tempo, descricao, distancia, status, urlImagemProduto, generoProduto, preco from produto;";
    sqlite3_stmt *stmt;
    // Cria o statement
    int resultado = sqlite3_prepare_v2(bancoDeDados, [query UTF8String],-1, &stmt, nil);
    if (resultado == SQLITE_OK) {
        
        // Enquanto existir produtos
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // Cria o carro para inserir na lista
            Produto *p = [Produto alloc];
            // Faz a leitura de cada coluna
            
            char *s = (char *)sqlite3_column_text(stmt, 0);
            p.produto_id = s != nil ? [NSString stringWithUTF8String:s]:nil;
            
            s = (char *)sqlite3_column_text(stmt, 1);
            p.tempo = s != nil ? [NSString stringWithUTF8String:s] : nil;
            
            s = (char *)sqlite3_column_text(stmt, 2);
            p.descricao = s != nil ? [NSString stringWithUTF8String:s] : nil;
            
            s = (char *)sqlite3_column_text(stmt, 3);
            p.distancia = s != nil ? [NSString stringWithUTF8String:s] : nil;
            
            s = (char *)sqlite3_column_text(stmt, 4);
            p.status = s != nil ? [NSString stringWithUTF8String:s] : nil;
            
            s = (char *)sqlite3_column_text(stmt, 5);
            p.urlImagemProduto = s != nil ? [NSString stringWithUTF8String:s] : nil;
            
            s = (char *)sqlite3_column_text(stmt, 6);
            p.generoProduto = s != nil ? [NSString stringWithUTF8String:s] : nil;
            
            s = (char *)sqlite3_column_text(stmt, 7);
            p.preco = s != nil ? [NSString stringWithUTF8String:s] : nil;
            
            // Adiciona no array
            [proFavoritos addObject:p];

        }
        // Finaliza o cursor
        sqlite3_finalize(stmt);
    }
    proFavorites = proFavoritos;
    return proFavorites;
}

//Deleta produto
-(void)deletar:(Produto *)produto{
    char *sql = "delete from produto where produto_id=?";
    sqlite3_stmt *stmt;
    int resultado = sqlite3_prepare_v2(bancoDeDados, sql, -1, &stmt, nil);
    if (resultado == SQLITE_OK){
        //informe o produto_id para deletar
        sqlite3_bind_int(stmt, 1, [produto.produto_id intValue]);
        //executa o SQL
        resultado = sqlite3_step(stmt);
        if (resultado == SQLITE_DONE) {
            //Deletado com sucesso
            NSLog(@"Deletado com sucesso");
            alertaDeAcao = YES;
        }
        sqlite3_finalize(stmt);
    }
}
@end
