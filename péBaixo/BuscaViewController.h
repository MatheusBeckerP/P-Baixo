//
//  ViewController.h
//  péBaixo
//
//  Created by Matheus Becker on 02/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuscaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


@property (weak, nonatomic) NSString *segmento;

@property(strong, nonatomic) NSString *termoBusca;

@property(nonatomic, strong) NSMutableArray *produtos;

@property(nonatomic, strong)NSString *latPropety;

@property(nonatomic, strong)NSString *lonPropety;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;

@property (strong, nonatomic) IBOutlet UISearchBar *busca;

- (IBAction)segmentoSelecao:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *login;



@end

