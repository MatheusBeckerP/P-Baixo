//
//  ProdutoCellTableViewCell.h
//  tableView Storyboard
//
//  Created by Matheus Becker on 15/08/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdutoCell : UITableViewCell{
}

@property(nonatomic, strong) IBOutlet UILabel *cellNome;
@property(nonatomic, strong) IBOutlet UILabel *cellDistancia;
@property(nonatomic, strong) IBOutlet UILabel *cellValor;
@property(nonatomic, strong) IBOutlet UIImageView *cellImg;
@property(nonatomic, strong) IBOutlet UILabel *cellTempo;

@end
