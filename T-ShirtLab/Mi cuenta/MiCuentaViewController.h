//
//  MiCuentaViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 14/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiCuentaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property(nonatomic,weak)IBOutlet UIView * viewContentScroll;

@property(nonatomic,weak)UIView * tViewSeleccionado;
@property(nonatomic,weak)UITextField * txtSeleccionado;

@property(nonatomic,weak)IBOutlet UILabel * lblTituloTipo;
@property(nonatomic,weak)IBOutlet UITextField * txtNombres;
@property(nonatomic,weak)IBOutlet UITextField * txtApellidos;
@property(nonatomic,weak)IBOutlet UITextField * txtCorreo;
@property(nonatomic,weak)IBOutlet UITextField * txtContrasena;
@property(nonatomic,weak)IBOutlet UITextField * txtCedulaNit;
@property(nonatomic,weak)IBOutlet UITextField * txtDireccion;
@property(nonatomic,weak)IBOutlet UITextField * txtDepartamento;
@property(nonatomic,weak)IBOutlet UITextField * txtCiudad;
@property(nonatomic,weak)IBOutlet UITextField * txtCelular;
@property(nonatomic,weak)IBOutlet UITextField * txtFijo;

@property(nonatomic,weak)IBOutlet UIImageView * imgIconNombreEmpresa;

@property(nonatomic,weak)IBOutlet UIImageView * imgIconCedulaNit;

//View Picker

@property(nonatomic,weak)IBOutlet UIView * vistaPicker;
@property(nonatomic,weak)IBOutlet UIView * vistaContentPicker;

@property(nonatomic,weak)IBOutlet UIPickerView * pickerView;

@property(nonatomic,strong)NSMutableArray * data;
@property(nonatomic,strong)NSMutableArray * data2;
@property(nonatomic,strong)NSMutableDictionary * dataUsuario;
@property(nonatomic,strong)NSMutableArray * dataDepartamentos;
@property(nonatomic,strong)NSMutableArray * dataCiudad;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * trailingMisDirecciones;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * landingCerrarSesion;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
