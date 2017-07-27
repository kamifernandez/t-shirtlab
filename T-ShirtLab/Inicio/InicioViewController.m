//
//  InicioViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 4/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "InicioViewController.h"

@interface InicioViewController ()

@end

@implementation InicioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

-(void)configurerView{
    NSString *urlString = @"http://t-shirtlab.com/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:urlRequest];
    [self.view addSubview:self.web];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark WebView Delegates

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //Check here if still webview is loding the content
    if (webView.isLoading)
        return;
    
    //after code when webview finishes
    [self.indicador stopAnimating];
}


@end
