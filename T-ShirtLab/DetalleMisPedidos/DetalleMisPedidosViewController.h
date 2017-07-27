//
//  DetalleMisPedidosViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 3/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetalleMisPedidosViewController : UIViewController

// Vista Header Table

@property (weak, nonatomic) IBOutlet UIView *viewDetallePedidos;
@property (weak, nonatomic) IBOutlet UILabel *lblNumeroPedido;
@property (weak, nonatomic) IBOutlet UILabel *lblFecha;
@property (weak, nonatomic) IBOutlet UILabel *lblEstado;

@property (weak, nonatomic) IBOutlet UILabel *lblDepartamentoCliente;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailCliente;
@property (weak, nonatomic) IBOutlet UILabel *lblNombreEmpresaCliente;
@property (weak, nonatomic) IBOutlet UILabel *lblApellidoContactoCliente;
@property (weak, nonatomic) IBOutlet UILabel *lblCedulaNitCliente;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccionCliente;
@property (weak, nonatomic) IBOutlet UILabel *lblCiudadCliente;
@property (weak, nonatomic) IBOutlet UILabel *lblPaisCliente;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefonoCliente;
@property (weak, nonatomic) IBOutlet UILabel *lblCelularCliente;

@property (weak, nonatomic) IBOutlet UILabel *lblnombreEmpresaDestino;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccionDestino;
@property (weak, nonatomic) IBOutlet UILabel *lblCiudadDestino;
@property (weak, nonatomic) IBOutlet UILabel *lblPaisDestino;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefonoDestino;
@property (weak, nonatomic) IBOutlet UILabel *lblCelularDestino;


@property (weak, nonatomic) IBOutlet UILabel *lblTransporteDetalle;
@property (weak, nonatomic) IBOutlet UILabel *lblMetodoEnvio;
@property (weak, nonatomic) IBOutlet UILabel *lblValorEnvio;


// TableView

@property(nonatomic,weak)IBOutlet UITableView * tblDetallePedidos;

@property(nonatomic,weak)IBOutlet UITableViewCell * CellDetalleMisPedidos;


//Celda Articulos

@property (weak, nonatomic) IBOutlet UILabel *lblCantidad;
@property (weak, nonatomic) IBOutlet UILabel *lblSku;

@property (weak, nonatomic) IBOutlet UILabel *lblArticulo;
@property (weak, nonatomic) IBOutlet UILabel *lblPrecioUnidad;
@property (weak, nonatomic) IBOutlet UILabel *lblPrecioTotal;

/// HardCode

@property(nonatomic,strong)NSMutableArray * data;

/// Footer

@property(nonatomic,strong)IBOutlet UIView * viewFooter;

@property(nonatomic,strong)IBOutlet UILabel * lblSubtotal;
@property(nonatomic,strong)IBOutlet UILabel * lblIva;
@property(nonatomic,strong)IBOutlet UILabel * lblEnvio;
@property(nonatomic,strong)IBOutlet UILabel * lblTotalFinal;
@property (weak, nonatomic) IBOutlet UIButton *btnVolver;


@end
