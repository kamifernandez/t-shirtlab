//
//  NovedadesViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 15/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface NovedadesViewController : UIViewController

// Tabla

@property(nonatomic,weak)IBOutlet UITableView * tblNovedades;
@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;

// Celda Tabla

@property (nonatomic,retain) IBOutlet UIImageView * imgProduct;
@property (nonatomic,retain) IBOutlet UILabel * lblTittle;
@property (nonatomic,retain) IBOutlet UILabel * lblDescription;
@property (nonatomic,retain) IBOutlet UIButton * btnSeeMore;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView * indicatorCell;

// NSMutableArray

@property(nonatomic,strong)IBOutlet NSMutableArray * data;

@property(nonatomic,strong)IBOutlet NSMutableDictionary * dataNovedades;

// Vista Mi cuenta

@property (nonatomic,retain) IBOutlet UIView * vistaCuenta;

@property (nonatomic,retain) IBOutlet UIView * vistaContentCuenta;

// Vista Sedes y Mas

@property (nonatomic,retain) IBOutlet UIView * vistaSedesMas;

@property (nonatomic,retain) IBOutlet UIView * vistaContentSedesMas;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
