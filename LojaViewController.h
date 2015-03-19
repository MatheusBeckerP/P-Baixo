//
//  LojaUIView.h
//  péBaixo
//
//  Created by Matheus Becker on 09/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loja.h"
#import "Produto.h"

@interface LojaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *LogoLoja;

@property (weak, nonatomic) IBOutlet UILabel *distanciaLabel;
@property (weak, nonatomic) IBOutlet UILabel *telefoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *enderecoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Activyte;

- (IBAction)ComoChegar:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titulo;

@property(nonatomic, strong) Loja *loja;
@property(nonatomic, strong) NSString *produto_id;
@property(nonatomic, strong) Produto *produto;

@end
