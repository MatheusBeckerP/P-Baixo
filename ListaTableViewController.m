//
//  ListaTableViewController.m
//  péBaixo
//
//  Created by Matheus Becker on 02/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "ListaTableViewController.h"

@implementation ListaTableViewController

-(void)viewDidLoad{
    
//    AppDelegate *valores_AppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//    
//    ListaProdutos = [[NSMutableArray alloc]init];
    
    //ListaProdutos = valores_AppDelegate.produtosTabela;
    
    NSLog(@"%@", ListaProdutos);
}


#pragma mark tableview (required - metodos obrigatorios)
//-- Informa ao datasorce o numero de celulas que deve criar
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.posts.count; //-- retorna a quantidade de objetos adicionados
    return 1;
}


//-- Cria as celulas
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
//    cell.textLabel.text = [self.posts objectAtIndex:indexPath.row];
//    cell.detailTextLabel.text = @"clique para ver mais detalhes.";
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    NSInteger line = indexPath.row; //-- Pega o valor da celula
//    
//    if (line % 2 == 0) {
//        // Se for par
//        cell.backgroundColor = [UIColor cyanColor];
//    }else{
//        // Senao impar
//        cell.backgroundColor = [UIColor greenColor];
//    }
    
    return cell;
}

#pragma mark tableview (optional - metodos opcionais)
//-- Define o tamanho de cada celula
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


////-- Metodo é chamado quando clicado em alguma celula
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];//-- deixa de manter a celula selecionada
//    
//    NSLog(@"index : %d", indexPath.row);//-- Pega o index da celula clicada
//}
@end
