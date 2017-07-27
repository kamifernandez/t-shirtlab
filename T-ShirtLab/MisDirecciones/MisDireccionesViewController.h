//
//  MisDireccionesViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 2/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MisDireccionesViewController : UIViewController

@property(nonatomic,weak)IBOutlet UITableView * tblDirecciones;

@property(nonatomic,weak)IBOutlet UITableViewCell * cellDirecciones;

@property(nonatomic,weak)IBOutlet UIButton * btnContinuar;

@property(nonatomic,strong)NSMutableArray * data;

@property(nonatomic,strong)NSMutableDictionary * dataUnaDireccion;

// Cell

@property(nonatomic,weak)IBOutlet UILabel * lblName;

@property(nonatomic,weak)IBOutlet UITextField * txtDireccion;

@property(nonatomic,weak)IBOutlet UITextField * txtDepartment;

@property(nonatomic,weak)IBOutlet UITextField * txtCity;

@property(nonatomic,weak)IBOutlet UIButton * btnEliminar;

@property(nonatomic,weak)IBOutlet UIButton * btnEditar;

// Footer

@property(nonatomic,weak)IBOutlet UIView * viewFootter;

@property(nonatomic,weak)IBOutlet UIButton * btnCrearDireccion;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicadorWait;

@end
