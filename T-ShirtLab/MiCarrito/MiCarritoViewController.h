//
//  MiCarritoViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 28/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"
#import "MetodosEnvioViewController.h"


@class MiCarritoViewController;

@interface MiCarritoViewController : UIViewController<UITextFieldDelegate,MetodosEnvioViewControllerDelegate>{
    UIToolbar *keyboardDoneButtonView;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *negativeSeparator;
}

// Namutable array

@property(nonatomic,strong)NSMutableArray * data;

@property(nonatomic,weak)UITextField * txtSelected;

@property(nonatomic,weak)IBOutlet UITableView * tblProducts;
@property (nonatomic,weak) IBOutlet UITableViewCell * celdaTablaPrendas;

@property (nonatomic,weak) IBOutlet UITableViewCell * celdaTablaObjetos;

@property (nonatomic,weak) IBOutlet UIView * footerTable;

@property (nonatomic,weak) IBOutlet UIView * viewStore;

@property (nonatomic,weak) IBOutlet UIView * viewCar;

@property (nonatomic,weak) IBOutlet UIButton * btnBack;

@property (nonatomic,weak) IBOutlet UIButton * btnContinuar;

@property (nonatomic,weak) IBOutlet UIView * conteinerView;

@property (nonatomic,weak) IBOutlet UIButton * btnDeletePrenda;

@property (nonatomic,weak) IBOutlet UIButton * btnDeleteObjeto;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthBackButtonConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthViewStoreConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthViewCarConstraint;


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

// Vista Mi cuenta

@property (nonatomic,retain) IBOutlet UIView * vistaCuenta;

@property (nonatomic,retain) IBOutlet UIView * vistaContentCuenta;

// Vista Sedes y Mas

@property (nonatomic,retain) IBOutlet UIView * vistaSedesMas;

@property (nonatomic,retain) IBOutlet UIView * vistaContentSedesMas;

@end
