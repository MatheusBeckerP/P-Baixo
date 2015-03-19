//
//  DetalheProdutoViewController.h
//  péBaixo
//
//  Created by Matheus Becker on 08/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Produto.h"
#import "AppDelegate.h"

@interface DetalheProdutoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSString *latitude;
@property(nonatomic, strong) NSString *longitude;
@property(nonatomic, strong) NSMutableArray *lojas;
@property(nonatomic) int favoritado;

@property(nonatomic, strong) Produto *produto;

@property (weak, nonatomic) IBOutlet UIImageView *imagem;

@property (weak, nonatomic) IBOutlet UITableView *tableViewLojas;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *login;

- (IBAction)Favoritar:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *FavoritarButton;

@end
