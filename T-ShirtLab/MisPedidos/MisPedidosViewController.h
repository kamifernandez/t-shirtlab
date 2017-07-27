//
//  MisPedidosViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 3/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MisPedidosViewController : UIViewController

// Footter

@property(nonatomic,weak)IBOutlet UIView * viewHeader;

//Table

@property(nonatomic,weak)IBOutlet UITableView * tblPedidos;

@property(nonatomic,weak)IBOutlet UITableViewCell * CellMisPedidos;


/// Cell

@property(nonatomic,weak)IBOutlet UILabel * lblNumero;

@property(nonatomic,weak)IBOutlet UILabel * lblFecha;

@property(nonatomic,weak)IBOutlet UILabel * lblEstado;

@property(nonatomic,weak)IBOutlet UILabel * lblTotal;

@property(nonatomic,weak)IBOutlet UIButton * btnBorrar;

/// HardCode

@property(nonatomic,strong)NSMutableArray * data;

@end
