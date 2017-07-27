//
//  EditarMisDireccionesViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 2/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditarMisDireccionesViewController : UIViewController

@property(nonatomic,weak)IBOutlet UITextField * txtDepartamento;

@property(nonatomic,weak)IBOutlet UITextField * txtCiudad;

@property(nonatomic,weak)IBOutlet UITextField * txtDireccion;

@property(nonatomic,weak)IBOutlet UITextField * txtNombre;

@property(nonatomic,weak)IBOutlet UITextField * txtCorreo;

@property(nonatomic,weak)IBOutlet UITextField * txtCelular;

@property(nonatomic,weak)IBOutlet UITextField * txtFijo;

@property(nonatomic,strong)IBOutlet UIScrollView * scroll;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,weak)UITextField * txtSeleccionado;

@property(nonatomic,strong)NSMutableDictionary * data;

@property(nonatomic,strong)NSMutableArray * dataPicker;

//View Picker

@property(nonatomic,weak)IBOutlet UIView * vistaPicker;
@property(nonatomic,weak)IBOutlet UIView * vistaContentPicker;

@property(nonatomic,weak)IBOutlet UIPickerView * pickerView;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicadorWait;

@end
