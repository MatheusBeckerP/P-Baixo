//
//  RecentesViewController.h
//  péBaixo
//
//  Created by Matheus Becker on 21/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecentesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSString *segmento;

@property(nonatomic, strong) NSMutableArray *produtos;

@property (weak, nonatomic) IBOutlet UITableView *tableViewRecentes;

@property (weak, nonatomic) IBOutlet UISegmentedControl *Segmented;

- (IBAction)SelecaoSexo:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

- (IBAction)recarregar:(id)sender;

@end
