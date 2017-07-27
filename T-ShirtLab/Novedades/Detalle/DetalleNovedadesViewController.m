//
//  DetalleNovedadesViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 16/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "DetalleNovedadesViewController.h"

@interface DetalleNovedadesViewController ()

@end

@implementation DetalleNovedadesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.scroll setContentSize:CGSizeMake(0, self.lblDescription.frame.origin.y + self.lblDescription.frame.size.height + 10)];
    //[self.contentScroll setFrame:CGRectMake(0, 0, self.scroll.frame.size.width,self.lblDescription.frame.origin.y + self.lblDescription.frame.size.height + 10)];
}

-(void)configurerView{
    // Imagen Header
    
    NSString * urlEnvio = [self.data objectForKey: @"imagen"];
    if ([urlEnvio isEqualToString:@""]) {
        [self.indicatorHeader stopAnimating];
    }else{
        NSURL *imageURL = [NSURL URLWithString:urlEnvio];
        NSString *key = [[self.data objectForKey: @"imagen"] MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            [self.indicatorHeader stopAnimating];
            UIImage *image = [UIImage imageWithData:data];
            self.imgHeader.image = image;
        } else {
            //imagen.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.indicatorHeader stopAnimating];
                    self.imgHeader.image = image;
                });
            });
        }
    }
    
    self.imgHeader.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.imgHeader.layer setMasksToBounds:YES];
    
    // Imagen Description
    
    NSMutableDictionary * temp = [_data objectForKey:@"contenido"];
    NSMutableArray * tempArray = [temp objectForKey:@"imagenes"];
    urlEnvio = [tempArray objectAtIndex:0];
    if ([urlEnvio isEqualToString:@""]) {
        [self.indicatorDescription stopAnimating];
    }else{
        NSURL *imageURL = [NSURL URLWithString:urlEnvio];
        NSString *key = [[tempArray objectAtIndex:0] MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            [self.indicatorDescription stopAnimating];
            UIImage *image = [UIImage imageWithData:data];
            self.imgDetail.image = image;
        } else {
            //imagen.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.indicatorDescription stopAnimating];
                    self.imgDetail.image = image;
                });
            });
        }
    }
    
    self.imgDetail.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.imgDetail.layer setMasksToBounds:YES];
    
    [self.lblTitulo setText:[self.data objectForKey:@"titulo"]];
    
    [self.lblDescription setText:[self.data objectForKey:@"texto"]];
}

#pragma mark - IBActions

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
