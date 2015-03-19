//
//  LojaUIView.m
//  péBaixo
//
//  Created by Matheus Becker on 09/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "LojaViewController.h"
#import "AFNetworking.h"
#import "MapViewController.h"

@interface LojaViewController()<UIAlertViewDelegate>

@end

@implementation LojaViewController{
    NSString *distancia;
    NSString *id_loja;
    NSString *id_produto;
    NSString *tempo;
    NSMutableArray *lojas;
}
@synthesize loja;
@synthesize produto_id;
@synthesize produto;
@synthesize distanciaLabel;
@synthesize telefoneLabel;
@synthesize enderecoLabel;
@synthesize LogoLoja;
@synthesize titulo;
@synthesize Activyte;

-(void)viewDidLoad{
    [super viewDidLoad];
    distancia = loja.distancia;
    id_loja = loja.loja_id;
    id_produto = produto_id;
    tempo = loja.tempo;
    [self carregaDados];
}

-(void)carregaDados{
    [self requisicaoJson];
     [Activyte startAnimating];
}

-(void)requisicaoJson{
    loja = [[Loja alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://api.pebaixo.com.br/get_store" parameters:@{@"id_loja": id_loja, @"id_produto": id_produto, @"distance": distancia, @"time": tempo}
     
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSLog(@"JSON: %@", responseObject);
              
//              NSDictionary *dictLoja;
              
                  Loja *l = [[Loja alloc]init];
                  l.loja_id = [responseObject objectForKey:@"store_id"];
                  l.nome = [responseObject objectForKey:@"fantasia"];
                  l.urlImagemLoja = [responseObject objectForKey:@"store_logo"];
                  l.distancia = [responseObject objectForKey:@"distance"];
                  l.tempo = [responseObject objectForKey:@"time"];
                  l.fone = [responseObject objectForKey:@"telefone"];
                  l.endereco = [responseObject objectForKey:@"endereco"];
                  l.latitude = [responseObject objectForKey:@"latitude"];
                  l.longitude = [responseObject objectForKey:@"longitude"];
                  l.status = [responseObject objectForKey:@"status"];
              loja = l;
              
              //titulo
              titulo.text = loja.nome;
              
              //distancia
              NSString *dst = loja.distancia;
              NSString *disString = [NSString stringWithFormat:@"à %@ de você", dst];
              NSLog(@"distancia: %@", disString);
              distanciaLabel.text = disString;
              
              //telefone
              telefoneLabel.text = loja.fone;
              
              //endereco
              
              
              enderecoLabel.lineBreakMode = NSLineBreakByWordWrapping;
              enderecoLabel.numberOfLines = 0;
              enderecoLabel.text = loja.endereco;
              
              //logo
              NSString *URL = [NSString stringWithFormat:@"%@", loja.urlImagemLoja];
              NSLog(@"%@", URL);
              NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
              UIImage *imagem = [[UIImage alloc]initWithData:data];
              LogoLoja.image = imagem;
              [Activyte stopAnimating];
              Activyte.hidden = YES;
              
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
              [Activyte stopAnimating];
              Activyte.hidden = YES;
          }];
    Activyte.hidden = NO;
    [Activyte stopAnimating];
}

# pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"map"]) {
        MapViewController *map = segue.destinationViewController;
        map.loja = self.loja;
    }
}

- (IBAction)ComoChegar:(id)sender {
}
@end
