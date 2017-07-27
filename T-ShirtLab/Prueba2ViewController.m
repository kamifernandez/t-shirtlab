//
//  Prueba2ViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 13/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "Prueba2ViewController.h"
#import "MetodosEnvioViewController.h"

@interface Prueba2ViewController ()

@end

@implementation Prueba2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setControllerPass:)
                                                 name:@"MetodosEnvio"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setControllerPass:(NSNotification*)notification{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MetodosEnvioViewController *metodosEnvioViewController = [story instantiateViewControllerWithIdentifier:@"MetodosEnvioViewController"];
    [self.navigationController pushViewController:metodosEnvioViewController animated:YES];
}

@end
