//
//  MapViewController.m
//  péBaixo
//
//  Created by Matheus Becker on 19/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "MapViewController.h"

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapaView;
@synthesize loja;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapaView.showsUserLocation = YES;
    
    self.title = loja.nome;
    self.mapaView.delegate = self;
    
    CLLocationCoordinate2D centroCoordenada = CLLocationCoordinate2DMake([self.loja.latitude doubleValue],[self.loja.longitude doubleValue]);
    CLLocationDistance centerToBorderMeters = 5000;
    MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance (centroCoordenada, centerToBorderMeters * 2, centerToBorderMeters * 2);
    [mapaView setRegion:rgn animated:YES];

    //Ponto de destino
    MKPointAnnotation *pin = [[MKPointAnnotation alloc]init];
    [pin setCoordinate:centroCoordenada];
    [pin setTitle:[NSString stringWithFormat:@"%@", self.loja.nome]];
    [self.mapaView addAnnotation:pin];
}

- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    NSInteger count = [mapaView.annotations count];
    if ( count == 0) { return; }
    
    MKMapPoint points[count];
    for( int i=0; i<count; i++ )
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self zoomMapViewToFitAnnotations:self.mapaView animated:animated];
    
    //Origem
    //Posicao atual
    
    //Destino
    CLLocationCoordinate2D coordenadaDestino = CLLocationCoordinate2DMake([self.loja.latitude doubleValue],[self.loja.longitude doubleValue]);
    
    //Destino MKPlacemark
    MKPlacemark *placemarkDestino = [[MKPlacemark alloc] initWithCoordinate:coordenadaDestino
                                                          addressDictionary:nil];
    
    // Origem Destino MKMapItem
    MKMapItem *itemDestino = [[MKMapItem alloc] initWithPlacemark:placemarkDestino];
    MKMapItem *itemInicio  = [MKMapItem mapItemForCurrentLocation];
    
    //requisições
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = itemInicio;
    request.destination = itemDestino;
    request.requestsAlternateRoutes = YES;
    
    //recebe request
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    //Calculo de erro
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
     {
         if (error) return;
         
         if ([response.routes count] > 0)
         {
             MKRoute *route = [response.routes objectAtIndex:0];
             NSLog(@"distancia: %.2f metros", route.distance);
             
             [self.mapaView addOverlay:route.polyline];
         }
     }];
}

#pragma mark - MKMapViewDelegate

//cria linha da rota
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.lineWidth = 3.0;
        routeRenderer.strokeColor = [UIColor redColor];
        return routeRenderer;
    }
    else {
        return nil;
    }
}

@end
