//
//  LojaCell.h
//  péBaixo
//
//  Created by Matheus Becker on 09/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LojaCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *cellNomeLoja;
@property(nonatomic, strong) IBOutlet UILabel *cellDistanciaLoja;
@property(nonatomic, strong) IBOutlet UILabel *cellValorLoja;
@property(nonatomic, strong) IBOutlet UIImageView *cellImgLoja;

@end
