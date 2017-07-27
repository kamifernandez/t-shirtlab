//
//  SedesViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 15/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SedesViewController : UIViewController

@property(nonatomic,weak)IBOutlet UITableView * tblSedes;
@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;

// Celda Tabla

@property (nonatomic,retain) IBOutlet UILabel * lblTitulo;
@property (nonatomic,retain) IBOutlet UILabel * lblDireccion;
@property (nonatomic,retain) IBOutlet UILabel * lblTelefono;
@property (nonatomic,retain) IBOutlet UILabel * lblHorario;

@property(nonatomic,strong) NSMutableDictionary * data;

@property(nonatomic,strong) NSMutableArray * dataSedes;


// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicadorWait;

//Footer

@property (nonatomic,retain) IBOutlet UIView * viewWebMapa;
@property (nonatomic,retain) IBOutlet UIWebView * webMapa;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView * indicator;


@end
