//
//  InicioViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 4/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InicioViewController : UIViewController

@property(nonatomic,weak)IBOutlet UITableView * tblInicio;

@property(nonatomic,weak)IBOutlet UITableViewCell * cellInicio;

// Celda

@property(nonatomic,weak)IBOutlet UIImageView * imgProductos;

/// HardCode

@property(nonatomic,strong)NSMutableArray * data;

@property(nonatomic,weak)IBOutlet UIWebView * web;

@property(nonatomic,weak)IBOutlet UIActivityIndicatorView * indicador;

@end
