//
//  ListaTableViewController.h
//  péBaixo
//
//  Created by Matheus Becker on 02/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ListaTableViewController : UITableView{
    
    NSMutableArray *ListaProdutos;
    
}

@property(nonatomic, weak) IBOutlet UITableView *tableView;




@end
