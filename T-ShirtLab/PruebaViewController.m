//
//  PruebaViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 13/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "PruebaViewController.h"
#import "SearchViewController.h"

@interface PruebaViewController ()

@end

@implementation PruebaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setControllerPass:)
                                                 name:@"ReloadSearchNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Prueba

-(IBAction)pass:(id)sender{
    /*UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SedesViewController *vc = [story instantiateViewControllerWithIdentifier:@"SedesViewController"];
    //UIViewController *parentVC = self.parentViewController;
    [self.navigationController pushViewController:vc animated:YES];
    //[self.tabBarController setSelectedIndex:0];*/
}

#pragma mark - Custom Delegates

- (void)setControllerPass:(NSNotification*)notification{
    NSDictionary* userInfo = notification.object;
    NSString* pantalla = (NSString*)userInfo[@"pantalla"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchViewController = [story instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchViewController.pantalla = pantalla;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

@end
