//
//  ConfiguracaoViewController.h
//  péBaixo
//
//  Created by Matheus Becker on 22/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ConfiguracaoViewController : UIViewController

@property(weak, nonatomic) NSString *ordem;

@property (weak, nonatomic) IBOutlet UILabel *LabelMetros;

@property (strong, nonatomic) IBOutlet UISlider *slider;

- (IBAction)SliderDistancia:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *ordemacao;

- (IBAction)ordenacao:(id)sender;

- (IBAction)ok:(id)sender;

@end
