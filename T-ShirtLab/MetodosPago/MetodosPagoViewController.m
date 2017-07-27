//
//  MetodosPagoViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 30/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "MetodosPagoViewController.h"

@interface MetodosPagoViewController ()

@end

@implementation MetodosPagoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(back)
                                                 name:@"BackNotificationPagos"
                                               object:nil];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_viewContentAll attribute: NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:660]];
}

#pragma mark IBActions

-(void)back{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)pagosOnline:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://t-shirtlab.com/index.php/component/users/?view=reset"]];
}

-(IBAction)pagosBancolombia:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://t-shirtlab.com/index.php/component/users/?view=reset"]];
}

-(IBAction)pagosBaloto:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://t-shirtlab.com/index.php/component/users/?view=reset"]];
}

@end
