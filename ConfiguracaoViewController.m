//
//  ConfiguracaoViewController.m
//  péBaixo
//
//  Created by Matheus Becker on 22/10/14.
//  Copyright (c) 2014 Matheus Becker. All rights reserved.
//

#import "ConfiguracaoViewController.h"
#import "Preferencia.h"

@interface ConfiguracaoViewController (){
    NSString *valorSliderString;
}

@end

@implementation ConfiguracaoViewController
@synthesize ordem;
@synthesize LabelMetros;

int distanciaMetros = 200;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //slider
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *strValue = [defaults objectForKey:@"Slider"];
    if (strValue.floatValue == 0) {
        _slider.value = 200;
        valorSliderString = [[NSString alloc] initWithFormat:@"%i", 200];
        LabelMetros.text = valorSliderString;
        DISTANCIA = valorSliderString;
        NSLog(@"DISTANCIA : %@", DISTANCIA);
    }else{
        _slider.value = strValue.floatValue;
        valorSliderString = [[NSString alloc] initWithFormat:@"%i", strValue.intValue];
        LabelMetros.text = valorSliderString;
        DISTANCIA = valorSliderString;
        NSLog(@"DISTANCIA : %@", DISTANCIA);
    }
    
    //segment
    if (ordem == nil) {
        ordem = @"PMAX";
    }
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if([settings objectForKey:@"Segment"] != nil) {
    _ordemacao.selectedSegmentIndex = [settings integerForKey:@"Segment"];
    }
}

- (IBAction)SliderDistancia:(id)sender {
    
    UISlider *slider = (UISlider *) sender;
    int valorSlider = slider.value;
    valorSliderString = [[NSString alloc] initWithFormat:@"%i", valorSlider];
    LabelMetros.text = valorSliderString;
    DISTANCIA = valorSliderString;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithFloat:slider.value] forKey:@"Slider"];
    [defaults synchronize];
}

- (IBAction)ok:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NO];
    DISTANCIA = valorSliderString;
    ORDENACAO = ordem;
    NSLog(@"Distancia: %@", DISTANCIA);
    NSLog(@"Ordem: %@", ORDENACAO);
}


#pragma mark - Segment Control

- (IBAction)ordenacao:(id)sender {
        NSInteger idx = ((UISegmentedControl*)sender).selectedSegmentIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:idx forKey:@"Segment"];
    
    [defaults synchronize];
    
    switch (idx) {
        case 0:
            self.ordem = @"PMAX";
             NSLog(@">Preço");
            ORDENACAO = @"PMAX";
            break;
        case 1:
            self.ordem = @"PMIN";
             NSLog(@"<Preço");
            ORDENACAO = @"PMIN";
            break;
    }
    [Preferencia setInteger:idx chave:@"tipoIdx"];
    [Preferencia setString:ordem chave:@"tipoString"];
}


@end
