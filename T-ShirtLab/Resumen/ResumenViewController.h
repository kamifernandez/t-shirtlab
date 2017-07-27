//
//  ResumenViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 29/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"


@interface ResumenViewController : UIViewController

@property(nonatomic,weak)NSString * modoEnvio;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,weak)UITextField * txtSelected;

// Header Tableview

@property(nonatomic,weak)IBOutlet UIView * viewHeader;

@property(nonatomic,weak)IBOutlet UIView * viewFacturacion;

@property(nonatomic,weak)IBOutlet UIView * viewEnvio;

@property(nonatomic,weak)IBOutlet UIView * viewMetodoEnvio;

    //View Facturación

@property(nonatomic,weak)IBOutlet UILabel * txtDepartamentoFacturacion;

@property(nonatomic,weak)IBOutlet UILabel * txtCiudadFacturacion;

@property(nonatomic,weak)IBOutlet UITextField * txtDireccionFacturacion;

@property(nonatomic,weak)IBOutlet UITextField * txtCelularFacturacion;

@property(nonatomic,weak)IBOutlet UITextField * txtFijoFacturacion;

    //View Envío

@property(nonatomic,weak)IBOutlet UILabel * txtDepartamentoEnvio;

@property(nonatomic,weak)IBOutlet UILabel * txtCiudadEnvio;

@property(nonatomic,weak)IBOutlet UITextField * txtDireccionEnvio;

@property(nonatomic,weak)IBOutlet UITextField * txtCelularEnvio;

@property(nonatomic,weak)IBOutlet UITextField * txtFijoEnvio;

    //View Metodo Envío

@property(nonatomic,weak)IBOutlet UIImageView * iconoMetodoEnvio;

@property(nonatomic,weak)IBOutlet UILabel * lblMetodoEnvio;

//Tabla

@property(nonatomic,strong)NSMutableArray * data;

@property(nonatomic,strong)NSMutableArray * dataPicker;

@property(nonatomic,weak)IBOutlet UITableView * tblProducts;
@property (nonatomic,weak) IBOutlet UITableViewCell * celdaTablaPrendas;

@property (nonatomic,weak) IBOutlet UITableViewCell * celdaTablaObjetos;

// Celda Prendas

@property (weak, nonatomic) IBOutlet UIImageView *imgPrenda;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicadorPrenda;

@property (weak, nonatomic) IBOutlet UITextField *txtTallaSPrenda;
@property (weak, nonatomic) IBOutlet UITextField *txtTallaMPrenda;
@property (weak, nonatomic) IBOutlet UITextField *txtTallaLPrenda;
@property (weak, nonatomic) IBOutlet UITextField *txtTallaXlPrenda;
@property (weak, nonatomic) IBOutlet UITextField *txtTallaTotalPrenda;

@property (weak, nonatomic) IBOutlet UIView *viewTallaSPrenda;
@property (weak, nonatomic) IBOutlet UIView *viewTallaMPrenda;
@property (weak, nonatomic) IBOutlet UIView *viewTallaLPrenda;
@property (weak, nonatomic) IBOutlet UIView *viewTallaXlPrenda;
@property (weak, nonatomic) IBOutlet UIView *viewTallaTotalPrenda;

@property (weak, nonatomic) IBOutlet UILabel *lblTipoPrenda;

@property (weak, nonatomic) IBOutlet UILabel *lblSubTipoPrenda;
@property (weak, nonatomic) IBOutlet UILabel *lblReferenciaPrenda;
@property (weak, nonatomic) IBOutlet UILabel *lblValorUnidadPrenda;
@property (weak, nonatomic) IBOutlet UILabel *lblValorTotalPrenda;

// Celda Objetos

@property (weak, nonatomic) IBOutlet UIImageView *imgObjeto;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicadorObjeto;

@property (weak, nonatomic) IBOutlet UILabel *lblCantidadObjeto;
@property (weak, nonatomic) IBOutlet UILabel *lblTipoObjeto;

@property (weak, nonatomic) IBOutlet UILabel *lblSubTipoObjeto;
@property (weak, nonatomic) IBOutlet UILabel *lblReferenciaObjeto;
@property (weak, nonatomic) IBOutlet UILabel *lblValorUnidadObjeto;
@property (weak, nonatomic) IBOutlet UILabel *lblValorTotalObjeto;

// Footer Table

@property (weak, nonatomic) IBOutlet UIView *viewFooterTable;

@property (weak, nonatomic) IBOutlet UILabel *lblSubTotal;

@property (weak, nonatomic) IBOutlet UILabel *lblIva;

@property (weak, nonatomic) IBOutlet UILabel *lblTotal;

@property (weak, nonatomic) IBOutlet UILabel *lblValorSubTotal;

@property (weak, nonatomic) IBOutlet UILabel *lblValorIva;

@property (weak, nonatomic) IBOutlet UILabel *lblValorTotal;

//View Picker

@property(nonatomic,weak)IBOutlet UIView * vistaPicker;
@property(nonatomic,weak)IBOutlet UIView * vistaContentPicker;

@property(nonatomic,weak)IBOutlet UIPickerView * pickerView;

// Vista agregar Dirección

@property(nonatomic,weak)IBOutlet UIView * viewAgregarDireccion;

@property(nonatomic,weak)IBOutlet UIView * viewContentAgregarDireccion;

@property(nonatomic,weak)IBOutlet UIView * viewNegraAgregarDireccion;

@property(nonatomic,weak)IBOutlet UIScrollView * scrollDireccion;

@property(nonatomic,weak)IBOutlet UIButton * btnCrearDireccion;

@property(nonatomic,weak)IBOutlet UITextField * txtDepartamento;

@property(nonatomic,weak)IBOutlet UITextField * txtCiudad;

@property(nonatomic,weak)IBOutlet UITextField * txtDireccion;

@property(nonatomic,weak)IBOutlet UITextField * txtNombre;

@property(nonatomic,weak)IBOutlet UITextField * txtCorreo;

@property(nonatomic,weak)IBOutlet UITextField * txtCelular;

@property(nonatomic,weak)IBOutlet UITextField * txtFijo;

@end
