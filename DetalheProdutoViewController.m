//
//  DetalheProdutoViewController.m
//  péBaixo
//
//  Created by Matheus Becker on 08/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "DetalheProdutoViewController.h"
#import "Produto.h"
#import "LojaCell.h"
#import "AFNetworking.h"
#import "Loja.h"
#import "LojaViewController.h"
#import "Favoritos.h"

@interface DetalheProdutoViewController ()

@end

@implementation DetalheProdutoViewController{
    NSMutableArray *lojas;
    NSString *id_produto;
}
@synthesize produto;
@synthesize imagem;
@synthesize lojas;
@synthesize longitude;
@synthesize latitude;
@synthesize login = _login;




- (void)viewDidLoad{
    [super viewDidLoad];
    _login.hidden = YES;
    _tableViewLojas.hidden = YES;
    id_produto = produto.produto_id;
    [self requisicaoJson];
    NSLog(@"Lojas: %lu", (unsigned long)[lojas count]);

    //Titulo
    self.title = produto.descricao;
    
    //Imagem
    NSString *URL = [NSString stringWithFormat:@"%@", produto.urlImagemProduto];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    UIImage *imagemT = [[UIImage alloc]initWithData:data];
    imagem.image = imagemT;

    [self.tableViewLojas reloadData];
    
    if (_favoritado == 3) {
                [_FavoritarButton setImage:[UIImage imageNamed:@ "star_02.png"]
                          forState:UIControlStateNormal];

        
    }else{
        [_FavoritarButton setImage:[UIImage imageNamed:@ "favourites.png"]
                          forState:UIControlStateNormal];

            }

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)requisicaoJson{
    lojas = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://api.pebaixo.com.br/get_stores_near_me"parameters:@{@"lat": LAT, @"lng": LON, @"raio": DISTANCIA, @"product_id": id_produto, @"modo" : @"driving"}
     
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSLog(@"JSON: %@", responseObject);
              NSArray *jsonLojas = [responseObject objectForKey:@"stores"];
              
              for (NSDictionary *dictLojas in jsonLojas) {
                  Loja *l = [[Loja alloc]init];
                  l.nome = [dictLojas objectForKey:@"fantasia"];
                  l.loja_id = [dictLojas objectForKey:@"store_id"];
                  l.preco = [dictLojas objectForKey:@"price"];
                  l.tempo = [dictLojas objectForKey:@"time"];
                  l.status = [dictLojas objectForKey:@"status"];
                  l.urlImagemLoja = [dictLojas objectForKey:@"store_logo"];
                  l.distancia = [dictLojas objectForKey:@"distance"];
                  [lojas addObject:l];
              }
              NSLog(@"%@", lojas);
              [_login stopAnimating];
              _login.hidden = YES;
              _tableViewLojas.hidden = NO;
            [self.tableViewLojas reloadData];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [_login stopAnimating];
              _login.hidden = YES;
          }];
    NSLog(@"Lojas: %lu", (unsigned long)[lojas count]);
    _login.hidden = NO;
    [_login startAnimating];
    _tableViewLojas.hidden = YES;
}

- (IBAction)Favoritar:(id)sender {
    
      Favoritos *db = [Favoritos alloc];
      [db abrir:@"produtos"];
      [db salvar:self.produto];
    if( db.alertaDeAcao == NO)
    {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Ocorreu um erro quando o app tentou favoritar este produto, pro favor tente ser mais mais tarde." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        _favoritado = 1;
    }else if (db.alertaDeAcao == YES){
        
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Produto inserido em sua lista de favoritos!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        _favoritado = 0;
        
        
    }
    
    [db fechar];
    if (_favoritado == 1) {
        [_FavoritarButton setImage:[UIImage imageNamed:@ "favourites.png"]
                          forState:UIControlStateNormal];
        
    }else{
        
        [_FavoritarButton setImage:[UIImage imageNamed:@ "star_02.png"]
                          forState:UIControlStateNormal];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Lojas: %lu", (unsigned long)[lojas count]);
    return [lojas count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"CellLoja";
    LojaCell *cell = (LojaCell *)[self.tableViewLojas dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell == nil) {
        cell = [[LojaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    
    Loja *loja = nil;
    loja = [lojas objectAtIndex:indexPath.row];
    
    
    
    //nome
    cell.cellNomeLoja.text = loja.nome;
    
    
    //distancia
    NSString *dst = loja.distancia;
    NSString *distanciaString = [NSString stringWithFormat:@"à %@ de você", dst];
    cell.cellDistanciaLoja.text = distanciaString;
    
    
    //valor
    double valorFormatado = [loja.preco doubleValue];
    NSString *valor = [NSString stringWithFormat:@"R$ %.2f", valorFormatado];
    cell.cellValorLoja.text = valor;
    
    
    //foto
    NSString *URL = [NSString stringWithFormat:@"%@", loja.urlImagemLoja];
    NSLog(@"%@", URL);
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    UIImage *imagem = [[UIImage alloc]initWithData:data];
    cell.cellImgLoja.image = imagem;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showLoja"]) {
        NSIndexPath *indexPath = [self.tableViewLojas indexPathForSelectedRow];
        LojaViewController *destViewController = segue.destinationViewController;
        destViewController.loja = [lojas objectAtIndex:indexPath.row];
        destViewController.produto_id = id_produto;
    }
}


@end
