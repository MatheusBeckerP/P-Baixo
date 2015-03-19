//
//  ProdutoCellTableViewCell.m
//  tableView Storyboard
//
//  Created by Matheus Becker on 15/08/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "ProdutoCell.h"

@implementation ProdutoCell
@synthesize cellDistancia, cellImg, cellNome, cellValor;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
    }
    return self;
}
@end
