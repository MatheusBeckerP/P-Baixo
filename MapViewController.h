//
//  MapViewController.h
//  péBaixo
//
//  Created by Matheus Becker on 19/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Loja.h"

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic, strong) Loja *loja;

@property (nonatomic, strong) IBOutlet MKMapView *mapaView;

@end
