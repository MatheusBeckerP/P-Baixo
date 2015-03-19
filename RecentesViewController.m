//
//  RecentesViewController.m
//  péBaixo
//
//  Created by Matheus Becker on 21/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import "RecentesViewController.h"
#import "AFNetworking.h"
#import "Produto.h"
#import "ProdutoCell.h"
#import "DetalheProdutoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ConfiguracaoViewController.h"


@interface RecentesViewController ()<CLLocationManagerDelegate, UIAlertViewDelegate, UITabBarDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *loc;
@end

@implementation RecentesViewController{
    NSMutableArray *produtos;
    NSString *latitudeString;
    NSString *longitudeString;
    NSError *_lastLocationError;
    BOOL _updatingLocation;
    BOOL _performingReverseGeocoding;
    CLGeocoder *_geocoder;
    NSError *_lastGeocodingError;
    CLPlacemark *_placemark;
    NSString *termoDeBusca;
}

@synthesize produtos;
@synthesize loading;


- (void)viewDidLoad {
    [super viewDidLoad];
   
        termoDeBusca = @"Sandalia Azaleia";

    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *strValue = [defaults objectForKey:@"Slider"];
        
        NSString *valorSliderString = [[NSString alloc] initWithFormat:@"%i", strValue.intValue];
        DISTANCIA = valorSliderString;
        NSLog(@"%@", DISTANCIA);
        if ([DISTANCIA  isEqual: @"0"]) {
            DISTANCIA = @"200";
    
        }
    
        NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
        NSInteger idx = [settings integerForKey:@"Segment"];
        switch (idx) {
            case 0:
                ORDENACAO = @"PMAX";
                break;
            case 1:
                ORDENACAO = @"PMIN";
                break;
        }
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    _segmento = @"1";
    [self getLocalizacao];
    _tableViewRecentes.hidden = YES;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        _locationManager = [[CLLocationManager alloc]init];
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


-(void)getLocalizacao{
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestAlwaysAuthorization];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
                 [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Request" message:@"To use this feature you need to turn on Location Service." delegate:self cancelButtonTitle:@"Nope" otherButtonTitles:@"Go to Settings", nil];
            [alert show];
        }
    }
    [self.locationManager startUpdatingLocation];
    _updatingLocation = YES;
}


-(void)carregaDados{
    [self requisicaoJson];
    [self.tableViewRecentes reloadData];
}


-(void)requisicaoJson{
    produtos = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://api.pebaixo.com.br/search"
       parameters:@{@"lat": LAT, @"lng" : LON, @"raio" : DISTANCIA, @"gen" : _segmento, @"termo" : termoDeBusca, @"modo" : @"driving", @"order": ORDENACAO}
     
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
              [loading stopAnimating];
              loading.hidden = YES;
              _tableViewRecentes.hidden = NO;
              [self.tableViewRecentes reloadData];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ops..." message:@"nenhum produto encontrado, tente ser mais expecifico." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
              
              [loading stopAnimating];
              loading.hidden = YES;
              [alert show];//nsjsonserialization
              
          }];
    
    NSLog(@"Produtos: %lu", (unsigned long)[produtos count]);
    loading.hidden = NO;
    [loading startAnimating];
    _tableViewRecentes.hidden = YES;
}

- (IBAction)SelecaoSexo:(id)sender {
    if ( _Segmented.selectedSegmentIndex == 0) {
        _segmento = @"1";
        termoDeBusca = @"Sandalia Azaleia";
        NSLog(@"F");
        [self carregaDados];
    }
    else if (_Segmented.selectedSegmentIndex == 1) {
        _segmento = @"2";
        termoDeBusca = @"Jorgito";
        NSLog(@"M");
        [self carregaDados];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Produtos: %lu", (unsigned long)[produtos count]);
    return [produtos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIndentifier = @"Cell";
    ProdutoCell *cell = (ProdutoCell *)[self.tableViewRecentes dequeueReusableCellWithIdentifier:CellIndentifier];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark - CLLocationManagerDelegate Methods


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    NSLog(@"didUpdateLocations %@", newLocation);
    // Se o momento em que o novo objecto foi determinada localização é muito longo
    // Atrás (5 segundos no presente caso), então este é um resultado em cache. Vamos ignorar
    // Esses locais em cache, pois eles podem estar desatualizados.
    
    if ([newLocation.timestamp timeIntervalSinceNow] < -5.0)
    {
        return;
    }
    // Ignorar medições inválidos.
    if (newLocation.horizontalAccuracy < 0) {
        return;
    }
    // Calcule a distância entre a nova leitura e do antigo. Se esta
    // É a primeira leitura, então não há local anterior para comparar
    // E vamos definir o raio de um número muito grande (MAXFLOAT).
    CLLocationDistance distance = MAXFLOAT;
    if (_loc != nil) {
        distance = [newLocation distanceFromLocation:_loc];
    }
    // Executar o código a seguir somente se a nova localização oferece uma forma mais
    // Leitura precisa do que a anterior, ou se é a primeira.
    if (_loc == nil || _loc.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // Coloque as novas coordenadas na tela.
        _lastLocationError = nil;
        _loc = newLocation;
        // Terminamos se a nova localização é precisa o suficiente.
        if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
            NSLog(@"*** we're done!");
            [self stopLocationManager];
            // Vamos forçar uma geocodificação reversa para esse resultado final se
            // Não tiver feito este local.
            if (distance > 0) {
                _performingReverseGeocoding = NO;
            }
        }
        // Não é suposto para executar mais de uma geocodificação reversa
        // Pedido ao mesmo tempo, tão somente continuar, se já não estiver ocupado.
        if (!_performingReverseGeocoding) {
            NSLog(@"*** Going to geocode");
            
            // Iniciar uma nova solicitação de geocodificação reversa e atualizar a tela
            // Com os resultados (um novo marcador ou mensagem de erro).
            _performingReverseGeocoding = YES;
            
            [_geocoder reverseGeocodeLocation:_loc completionHandler:^(NSArray *placemarks, NSError *error){
                NSLog(@"*** Found placemarks: %@, error: %@",
                      placemarks, error);
                _lastGeocodingError = error;
                if (error == nil && [placemarks count] > 0) {
                    _placemark = [placemarks lastObject];
                }else{
                    _placemark = nil;
                }
                _performingReverseGeocoding = NO;
            }];
        }
        // Se a distância não se alterou significativamente desde a última vez e tem
        // Sido um tempo desde que recebemos a leitura anterior (10 segundos), em seguida,
        // Assumir este é o melhor que vai ser e parar de buscar a localização.
        latitudeString = [NSString stringWithFormat:@"%.8f",  _loc.coordinate.latitude];
        longitudeString = [NSString stringWithFormat:@"%.8f", _loc.coordinate.longitude];
        LAT = latitudeString;
        LON = longitudeString;
        [self carregaDados];
    }else if (distance < 1.0){
        NSTimeInterval timeInterval = [newLocation.timestamp timeIntervalSinceDate:_loc.timestamp];
        if (timeInterval > 10) {
            NSLog(@"*** Force done!");
            [self stopLocationManager];
        }
    }
    
    latitudeString = [NSString stringWithFormat:@"%.8f",  _loc.coordinate.latitude];
    longitudeString = [NSString stringWithFormat:@"%.8f", _loc.coordinate.longitude];
    
    NSLog(@"Sua latitude é: %@", latitudeString);
    NSLog(@"Sua longitude é: %@", longitudeString);
    NSLog(@"Location Object: %@", _loc);
    
    LAT = latitudeString;
    NSLog(@"%@", LAT);
    LON = longitudeString;
    NSLog(@"%@", LON);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"%@", error.localizedDescription);
    NSLog(@"%@", error);
    if (error.code == kCLErrorLocationUnknown) {
        return;
    }
    [self stopLocationManager];
    _lastLocationError = error;
    
}

-(void)stopLocationManager{
    if (_updatingLocation) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTimeOut:) object:nil];
        [self.locationManager stopUpdatingLocation];
        _locationManager.delegate = nil;
        _updatingLocation = NO;
    }
}


-(void)didTimeOut:(id)obj{
    NSLog(@"*** Time out");
    
    // Temos aqui se temos obtido um local ou não. Se não há
    // Localização foi obtido por esta altura, então paramos o gerente de locação
    // De nos dar atualizações e vamos mostrar uma mensagem de erro para o usuário.
    if(_loc == nil){
        [self stopLocationManager];
        
        // Criar um objeto NSError para que a interface do usuário mostra uma mensagem de erro.
        _lastLocationError = [NSError errorWithDomain:@"MyLocationErrorDomain" code:1 userInfo:nil];
        
    }
}


# pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        NSIndexPath *indexPath = [self.tableViewRecentes indexPathForSelectedRow];
        DetalheProdutoViewController *destViewController = segue.destinationViewController;
        destViewController.produto = [produtos objectAtIndex:indexPath.row];
        destViewController.latitude = latitudeString;
        destViewController.longitude = longitudeString;
    }
}


@end
