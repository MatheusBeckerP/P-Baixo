//
//  ViewFavoritos.m
//  péBaixo
//
//  Created by Matheus Becker on 29/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "FavoritosViewController.h"
#import "Favoritos.h"
#import "DetalheProdutoViewController.h"
#import "ProdutoCell.h"
#import "BuscaViewController.h"
#import "AppDelegate.h"

@interface FavoritosViewController ()

@end

@implementation FavoritosViewController{
    NSMutableArray *produtos;
}
@synthesize produtos;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    Favoritos *db = [Favoritos alloc];
    [db abrir:@"produtos"];
    [db getProdutos];
    FAVORITOS = db.proFavorites;
    
    [db fechar];
    
    if([FAVORITOS count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Você não favoritou nenhum produto ainda!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //[tableView reloadData];
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
    // This is just Programatic method you can also do that by xib !
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetalheProdutoViewController *destViewController = segue.destinationViewController;
        
        
        destViewController.produto = [FAVORITOS objectAtIndex:indexPath.row];
        destViewController.latitude = LAT;
        destViewController.longitude = LON;
        destViewController.favoritado = 3;
        
        NSLog(@"%@", LAT);
        NSLog(@"%@", LON);

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Produtos: %lu", (unsigned long)[produtos count]);
    return [FAVORITOS count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIndentifier = @"Cell";
    ProdutoCell *cell = (ProdutoCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell == nil) {
        cell = [[ProdutoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    
    
    Produto *produto = nil;
    produto = [FAVORITOS objectAtIndex:indexPath.row];
    
    
    //nome
    cell.cellNome.text = produto.descricao;
    
    
    //distancia
    NSString *dst = produto.distancia;
    NSString *distanciaString = [NSString stringWithFormat:@"à %@ de você",dst];
    cell.cellDistancia.text = distanciaString;
    
    
    //valor
    double valorFormatado = [produto.preco doubleValue];
    NSString *valor = [NSString stringWithFormat:@"R$ %.2f", valorFormatado];
    cell.cellValor.text = valor;
    
    
    //foto
    NSString *URL = [NSString stringWithFormat:@"%@", produto.urlImagemProduto];
    NSLog(@"%@", URL);
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    UIImage *imagem = [[UIImage alloc]initWithData:data];
    cell.cellImg.image = imagem;
    
    //Tempo
    NSString *time = produto.tempo;
    NSString *timeString = [NSString stringWithFormat:@"%@",time];
    cell.cellTempo.text = timeString;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //[produtos removeObjectAtIndex:indexPath.row];
    
    Produto *produto = nil;
    produto = [FAVORITOS objectAtIndex:indexPath.row];
    
    Favoritos *db = [Favoritos alloc];
    [db abrir:@"produtos"];
    [db deletar:produto];
    [FAVORITOS removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    
    if( db.alertaDeAcao == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Ocorreu um erro quando o app tentou excluir este produto, pro favor tente ser mais mais tarde." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (db.alertaDeAcao == YES){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Produto excluido da sua lista de favoritos!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        
    }
    
    [db fechar];
    
}

- (IBAction)Recarregar:(id)sender {
    Favoritos *db = [Favoritos alloc];
    [db abrir:@"produtos"];
    [db getProdutos];
    FAVORITOS = db.proFavorites;
    [db fechar];

    [self.tableView reloadData];
}

@end
