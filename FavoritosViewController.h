//
//  ViewFavoritos.h
//  péBaixo
//
//  Created by Matheus Becker on 29/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritosViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property(nonatomic, strong) NSMutableArray *produtos;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)Recarregar:(id)sender;

@end
