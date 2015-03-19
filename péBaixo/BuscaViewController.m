//
//  ViewController.m
//  péBaixo
//
//  Created by Matheus Becker on 02/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

//#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "BuscaViewController.h"
#import "AFNetworking.h"
#import "Produto.h"
#import "ProdutoCell.h"
#import "DetalheProdutoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ConfiguracaoViewController.h"


@interface BuscaViewController ()<CLLocationManagerDelegate, UIAlertViewDelegate, UITabBarDelegate>


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *loc;
@property(nonatomic, strong) UIActivityIndicatorView *spinner;


@end

@implementation BuscaViewController{
    NSMutableArray *produtos;
    NSString *latitudeString;
    NSString *longitudeString;
    
    NSError *_lastLocationError;
    BOOL _updatingLocation;
    BOOL _performingReverseGeocoding;
    CLGeocoder *_geocoder;
    NSError *_lastGeocodingError;
    CLPlacemark *_placemark;
}

@synthesize produtos;
@synthesize login = _login;
@synthesize lonPropety;
@synthesize latPropety;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Distancia : %@", DISTANCIA);
    NSLog(@"%@", DISTANCIA);
    
    if (DISTANCIA == nil) {
        //DISTANCIA = @"200";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *strValue = [defaults objectForKey:@"Slider"];
        NSString *valorSliderString = [[NSString alloc] initWithFormat:@"%i", strValue.intValue];
        DISTANCIA = valorSliderString;
    }
    
    if (ORDENACAO == nil) {
        ORDENACAO = @"PMAX";
    }
    
    NSLog(@"%@", DISTANCIA);
    _login.hidden = YES;
    _tableView.hidden = YES;
    _segmento = @"1";
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        _locationManager = [[CLLocationManager alloc]init];
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

-(IBAction)clikBackgroud:(id)sender{
    [_busca resignFirstResponder];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _termoBusca = _busca.text;
    
    [self carregaDados];
}

-(void)carregaDados{
    _tableView.hidden = YES;
    [self requisicaoJson];
    NSLog(@"Produtos: %lu", (unsigned long)[produtos count]);
    _termoBusca = nil;
    NSLog(@"%@", _termoBusca);
    [self.tableView reloadData];
    NSLog(@"aqui");
    
    
}

-(void)requisicaoJson{
    NSLog(@"Distancia %@", DISTANCIA);
    produtos = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://api.pebaixo.com.br/search"
       parameters:@{@"lat": LAT, @"lng" : LON, @"raio" : DISTANCIA ,@"gen" : _segmento, @"order":ORDENACAO , @"termo" : _termoBusca, @"modo" : @"driving"}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              NSArray * jsonProdutos = [responseObject objectForKey:@"products"] ;
              for (NSDictionary *dictProdutos in jsonProdutos) {
                  Produto *p = [[Produto alloc]init];
                  p.descricao = [dictProdutos objectForKey:@"description"];
                  p.produto_id = [dictProdutos objectForKey:@"prod_id"];
                  p.preco = [dictProdutos objectForKey:@"price"];
                  p.tempo = [dictProdutos objectForKey:@"time"];
                  p.status = [dictProdutos objectForKey:@"status"];
                  p.urlImagemProduto = [dictProdutos objectForKey:@"photo"];
                  p.distancia = [dictProdutos objectForKey:@"distance"];
                  [produtos addObject:p];
              }
              [_login stopAnimating];
              _login.hidden = YES;
              _tableView.hidden = NO;
            [self.tableView reloadData];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ops..." message:@"nenhum produto encontrado, tente ser mais expecifico." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
              
              [_login stopAnimating];
              _login.hidden = YES;
              [alert show];
              
          }];
    
    NSLog(@"Produtos: %lu", (unsigned long)[produtos count]);
    _termoBusca = nil;
    _login.hidden = NO;
    [_login startAnimating];
    _tableView.hidden = YES;
}


- (IBAction)segmentoSelecao:(id)sender {
    if ( _segmented.selectedSegmentIndex == 0) {
        _segmento = @"1";
        NSLog(@"F");
    }
    else if (_segmented.selectedSegmentIndex == 1) {
        _segmento = @"2";
        NSLog(@"M");
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetalheProdutoViewController *destViewController = segue.destinationViewController;
        destViewController.produto = [produtos objectAtIndex:indexPath.row];
        destViewController.latitude = latitudeString;
        destViewController.longitude = longitudeString;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        NSLog(@"Produtos: %lu", (unsigned long)[produtos count]);
        return [produtos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIndentifier = @"Cell";
    ProdutoCell *cell = (ProdutoCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell == nil) {
        cell = [[ProdutoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    
    Produto *produto = nil;
    produto = [produtos objectAtIndex:indexPath.row];
    
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

# pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


@end
