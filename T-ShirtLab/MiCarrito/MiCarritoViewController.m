//
//  MiCarritoViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 28/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "MiCarritoViewController.h"
#import "utilidades.h"

#import "MiCuentaViewController.h"
#import "MisPedidosViewController.h"
#import "MisDireccionesViewController.h"
#import "RegistroViewController.h"

#import "SedesViewController.h"
#import "NovedadesViewController.h"
#import "QuienesSomosViewController.h"
#import "ContactenosViewController.h"
#import "PresentacionViewController.h"
#import "InicioViewController.h"
#import "NSMutableAttributedString+Color.h"

@interface MiCarritoViewController (){
    UITableViewCell *celdaActiva;
    int tagCellSelected;
    int tagAnterior;
    int accionContinuar;
    BOOL mostrarOcultarCuenta;
    BOOL mostrarOcultarSedesMas;
    int tagDelete;
}

@end

@implementation MiCarritoViewController

-(void)viewWillAppear:(BOOL)animated
{
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
    
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"1" forKey:@"tabselect"];
    if (mostrarOcultarCuenta) {
        [self.vistaCuenta setHidden:TRUE];
        self.vistaCuenta = nil;
        mostrarOcultarCuenta = NO;
    }
    if (mostrarOcultarSedesMas) {
        [self.vistaSedesMas setHidden:TRUE];
        self.vistaSedesMas = nil;
        mostrarOcultarSedesMas = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"1" forKey:@"tabselect"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saberStep:)
                                                 name:@"SaberStepNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarOcultarCuenta)
                                                 name:@"mostrarOcultarCuentaMiCarrito"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarOcultarSedesMas)
                                                 name:@"mostrarOcultarSedesMasMiCarrito"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarAlertaCarrito:)
                                                 name:@"mostrarAlertaCarrito"
                                               object:nil];
    
    accionContinuar = 0;
    mostrarOcultarCuenta = NO;
    mostrarOcultarSedesMas = NO;
    self.widthBackButtonConstraint.constant = 0;
    [self.view layoutIfNeeded];
    tagCellSelected = -1;
    [[NSBundle mainBundle] loadNibNamed:@"FooterMiCarrito" owner:self options:nil];
    self.tblProducts.tableFooterView = self.footerTable;
    
    /*HardCode*/
    
    _data = [[NSMutableArray alloc] init];
    for (int i = 0; i<6; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        if (i % 2 == 0) {
            [dataInsert setObject:@"http://t-shirtlab.com/images/ju_cached_images/Home-BannerPrincipal_3b4214f200a629cb3f231eef8b4a6b1b_920x375.resized.jpg" forKey:@"image"];
            [dataInsert setObject:@"1" forKey:@"categoria"];
            [dataInsert setObject:@"12" forKey:@"s"];
            [dataInsert setObject:@"0" forKey:@"m"];
            [dataInsert setObject:@"0" forKey:@"l"];
            [dataInsert setObject:@"20" forKey:@"xl"];
            [dataInsert setObject:@"Camiseta WOW polo verde oscuro de hombre" forKey:@"articulo"];
            [dataInsert setObject:@"Polo verde Estampado Bolsillo" forKey:@"subtitulo"];
            [dataInsert setObject:@"CPHGMVO" forKey:@"referencia"];
            [dataInsert setObject:@"25.000" forKey:@"vunidad"];
        }else{
            [dataInsert setObject:@"http://t-shirtlab.com/images/novedades/forro.png" forKey:@"image"];
            [dataInsert setObject:@"2" forKey:@"categoria"];
            [dataInsert setObject:@"12" forKey:@"cantidad"];
            [dataInsert setObject:@"Mug Wow Clasico" forKey:@"articulo"];
            [dataInsert setObject:@"Mug Wow Clasico est. IZQ" forKey:@"subtitulo"];
            [dataInsert setObject:@"CPHGMVO" forKey:@"referencia"];
            [dataInsert setObject:@"25.000" forKey:@"vunidad"];
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    [self.tblProducts reloadData];
}

-(void)notificacionesNavegacioNext:(int)opcion{
    if (opcion == 0) {
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:_data forKey:@"arrayPedidos"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MetodosEnvio" object:nil];
        accionContinuar = 1;
        self.widthBackButtonConstraint.constant = 28;
        [self.view layoutIfNeeded];
    }else if (opcion == 1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Resumen" object:nil];
    }else if (opcion == 2){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MetodosPago" object:nil];
    }
}

-(void)mostrarAlertaCarrito:(NSNotification*)aNotification{
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Mi Carrito" forKey:@"Title"];
    [msgDict setValue:@"Producto añadido a mi carrito" forKey:@"Message"];
    [msgDict setValue:@"" forKey:@"Aceptar"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
    [self performSelector:@selector(onTick:) withObject:nil afterDelay:5.0];
}

-(void)onTick:(NSTimer *)timer {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actualizar Valores Prendas

-(NSMutableDictionary *)actualizarValores:(int)index{
    
    int cantidaS = [[[_data objectAtIndex:index] objectForKey:@"s"] intValue];
    
    int cantidaM = [[[_data objectAtIndex:index] objectForKey:@"m"] intValue];
    
    int cantidaL = [[[_data objectAtIndex:index] objectForKey:@"l"] intValue];
    
    int cantidaXl = [[[_data objectAtIndex:index] objectForKey:@"xl"] intValue];
    
    int cantidadTotal = cantidaS + cantidaM + cantidaL + cantidaXl;
    
    int valor = [[[_data objectAtIndex:index] objectForKey:@"vunidad"] intValue] * cantidadTotal;
    
    int totalCompra = valor;
    
    NSMutableDictionary * dataReturn = [[NSMutableDictionary alloc] init];
    [dataReturn setObject:[NSString stringWithFormat:@"%@",[utilidades decimalNumberFormat:totalCompra]] forKey:@"totalCompra"];
    [dataReturn setObject:[NSString stringWithFormat:@"%i",cantidadTotal] forKey:@"cantidadTotal"];
    
    return dataReturn;
}

-(void)actualizarValoresCelda{
    if (tagCellSelected != -1) {
        
        int index = tagCellSelected*10;
        
        UITableViewCell *cell = [self.tblProducts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tagCellSelected inSection:0]];
        
        NSMutableDictionary * datosKey = [_data objectAtIndex:tagCellSelected];
        
        UITextField *txtTallaSPrenda = (UITextField *)[cell viewWithTag:index+1];
        if ([txtTallaSPrenda.text isEqualToString:@""]) {
            txtTallaSPrenda.text = @"0";
        }
        
        [datosKey setObject:txtTallaSPrenda.text forKey:@"s"];
        
        UITextField *txtTallaMPrenda = (UITextField *)[cell viewWithTag:index+2];
        if ([txtTallaMPrenda.text isEqualToString:@""]) {
            txtTallaMPrenda.text = @"0";
        }
        
        [datosKey setObject:txtTallaMPrenda.text forKey:@"m"];
        
        UITextField *txtTallaLPrenda = (UITextField *)[cell viewWithTag:index+3];
        if ([txtTallaLPrenda.text isEqualToString:@""]) {
            txtTallaLPrenda.text = @"0";
        }
        
        [datosKey setObject:txtTallaLPrenda.text forKey:@"l"];
        
        UITextField *txtTallaXlPrenda = (UITextField *)[cell viewWithTag:index+4];
        if ([txtTallaXlPrenda.text isEqualToString:@""]) {
            txtTallaXlPrenda.text = @"0";
        }
        [datosKey setObject:txtTallaXlPrenda.text forKey:@"xl"];
        
        UILabel *lblTotal = (UILabel *)[cell viewWithTag:index+6];
        
        NSMutableDictionary * dataUpdate = [self actualizarValores:tagCellSelected];
        
        NSString * total = [dataUpdate objectForKey:@"totalCompra"];
        
        [lblTotal setText:total];
        
        NSLog(@"%@",lblTotal.text);
        
        UITextField *txtTallaTotalPrenda = (UITextField *)[cell viewWithTag:index+5];
        
        txtTallaTotalPrenda.text = [dataUpdate objectForKey:@"cantidadTotal"];
    }
}

#pragma mark - Actualizar Valores Objetos

-(NSString *)actualizarValoresObjetos:(int)index{
    
    int cantidadTotal = [[[_data objectAtIndex:index] objectForKey:@"cantidad"] intValue];
    
    int valor = [[[_data objectAtIndex:index] objectForKey:@"vunidad"] intValue] * cantidadTotal;
    
    int totalCompra = valor;
    
    return [utilidades decimalNumberFormat:totalCompra];
}

-(void)actualizarValoresCeldaObjetos{
    if (tagCellSelected != -1) {
        
        int index = tagCellSelected*10;
        
        UITableViewCell *cell = [self.tblProducts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tagCellSelected inSection:0]];
        
        NSMutableDictionary * datosKey = [_data objectAtIndex:tagCellSelected];
        
        UITextField *txtCantidad = (UITextField *)[cell viewWithTag:index+7];
        if ([txtCantidad.text isEqualToString:@""]) {
            txtCantidad.text = @"0";
        }
        
        [datosKey setObject:txtCantidad.text forKey:@"cantidad"];
        
        UILabel *lblTotal = (UILabel *)[cell viewWithTag:index+8];
        
        NSString * total = [self actualizarValoresObjetos:tagCellSelected];
        
        [lblTotal setText:total];
        
        NSLog(@"%@",lblTotal.text);
    }
}

#pragma mark - IBAciotns

-(IBAction)backButton:(id)sender{
    if (accionContinuar == 1) {
        accionContinuar = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BackNotificationMetodosEnvio" object:nil];
        [self performSelector:@selector(hiddenConteninerView) withObject:nil afterDelay:0.2];
        self.widthBackButtonConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }else if (accionContinuar == 2){
        accionContinuar = 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BackNotificationResumen" object:nil];
    }else if (accionContinuar == 3){
        accionContinuar = 2;
        [self.btnContinuar setHidden:FALSE];
        self.heigthViewCarConstraint.constant = 30;
        self.heigthViewStoreConstraint.constant = 30;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BackNotificationPagos" object:nil];
    }
}

-(IBAction)segmentedButtons:(id)sender{
    int tag = (int)[sender tag];
    if (tag == 1) {
        [self.tabBarController setSelectedIndex:0];
    }else{
        [self.tabBarController setSelectedIndex:1];
    }
}

-(void)hiddenConteninerView{
    [self.conteinerView setHidden:TRUE];
}

-(IBAction)continuarComprando:(id)sender{
    [self.conteinerView setHidden:FALSE];
    [self notificacionesNavegacioNext:accionContinuar];
}

-(void)eliminarProductos:(id)sender{
    tagDelete = (int)[sender tag];
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Eliminar Producto" forKey:@"Title"];
    [msgDict setValue:@"¿Esta seguro que desea eliminar este producto?" forKey:@"Message"];
    [msgDict setValue:@"Si" forKey:@"Aceptar"];
    [msgDict setValue:@"No" forKey:@"Cancel"];
    [msgDict setValue:@"102" forKey:@"Tag"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
}

- (void)doneClicked:(id)sender
{
    
    if (tagCellSelected != -1) {
        NSString * categoria = [[_data objectAtIndex:tagCellSelected] objectForKey:@"categoria"];
        if ([categoria isEqualToString:@"1"]) {
            [self actualizarValoresCelda];
        }else{
            [self actualizarValoresCeldaObjetos];
        }
    }
    
    if ([_txtSelected.text isEqualToString:@""]) {
        _txtSelected.text = @"0";
    }
    tagCellSelected = -1;
    [self.view endEditing:YES];
}

-(IBAction)seguirComprando:(id)sender{
    [self.tabBarController setSelectedIndex:0];
}

-(IBAction)btnCuenta:(id)sender{
    int tagCuenta = (int)[sender tag];
    if (tagCuenta == 1) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MiCuentaViewController *vc = [story instantiateViewControllerWithIdentifier:@"MiCuentaViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (tagCuenta == 2){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MisDireccionesViewController *misDireccionesViewController = [story instantiateViewControllerWithIdentifier:@"MisDireccionesViewController"];
        [self.navigationController pushViewController:misDireccionesViewController animated:YES];
    }else if (tagCuenta == 3){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MisPedidosViewController *misPedidosViewController = [story instantiateViewControllerWithIdentifier:@"MisPedidosViewController"];
        [self.navigationController pushViewController:misPedidosViewController animated:YES];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"¿Desea cerrar la sesión actual?" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarOcultarCuenta];
}

-(IBAction)btnSedesMas:(id)sender{
    int tagCuenta = (int)[sender tag];
    if (tagCuenta == 1) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SedesViewController *sedesViewController = [story instantiateViewControllerWithIdentifier:@"SedesViewController"];
        [self.navigationController pushViewController:sedesViewController animated:YES];
    }else if (tagCuenta == 2){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InicioViewController *inicioViewController = [story instantiateViewControllerWithIdentifier:@"InicioViewController"];
        [self.navigationController pushViewController:inicioViewController animated:YES];
    }else if (tagCuenta == 3){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PresentacionViewController *presentacionViewController = [story instantiateViewControllerWithIdentifier:@"PresentacionViewController"];
        [self.navigationController pushViewController:presentacionViewController animated:YES];
    }else if (tagCuenta == 4){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        QuienesSomosViewController *quienesSomosViewController = [story instantiateViewControllerWithIdentifier:@"QuienesSomosViewController"];
        [self.navigationController pushViewController:quienesSomosViewController animated:YES];
    }else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContactenosViewController *contactenosViewController = [story instantiateViewControllerWithIdentifier:@"ContactenosViewController"];
        [self.navigationController pushViewController:contactenosViewController animated:YES];
    }
    [self mostrarOcultarSedesMas];
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * categoria = [[_data objectAtIndex:indexPath.row] objectForKey:@"categoria"];
    int indexPathRow = (int)indexPath.row;
    int index = indexPathRow*10;
    // Cell Prenda
    if ([categoria isEqualToString:@"1"]) {
        static NSString *CellIdentifier = @"CellMiCarritoPrendas";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"CellMiCarritoPrendas" owner:self options:nil];
            cell = _celdaTablaPrendas;
            self.celdaTablaPrendas = nil;
        }
        
        NSString * urlEnvio = [[self.data objectAtIndex:indexPath.row] objectForKey:@"image"];
        if ([urlEnvio isEqualToString:@""]) {
            [self.indicadorPrenda stopAnimating];
            [self.imgPrenda setFrame:CGRectMake(self.imgPrenda.frame.origin.x, self.imgPrenda.frame.origin.y - 15, self.imgPrenda.frame.size.width, self.imgPrenda.frame.size.height)];
        }else{
            NSURL *imageURL = [NSURL URLWithString:urlEnvio];
            NSString *key = [[[self.data objectAtIndex:indexPath.row] objectForKey:@"image"] MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                self.imgPrenda.image = image;
                [self.indicadorPrenda stopAnimating];
            } else {
                //imagen.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.indicadorPrenda stopAnimating];
                        self.imgPrenda.image = image;
                    });
                });
            }
        }
        self.imgPrenda.contentMode = UIViewContentModeScaleAspectFill;
        self.imgPrenda.clipsToBounds = YES;
    
        
        [self.viewTallaSPrenda.layer setCornerRadius:2];
        
        [self.viewTallaSPrenda.layer setBorderWidth:1];
        
        [self.viewTallaSPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        UITextField *txtTallaSPrenda = (UITextField *)[cell viewWithTag:1];
        
        [txtTallaSPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"s"]];
        
        [txtTallaSPrenda setTag:index+1];
        
        txtTallaSPrenda.delegate = self;
        
        txtTallaSPrenda.keyboardType = UIKeyboardTypeNumberPad;
        
        [self.viewTallaMPrenda.layer setCornerRadius:2];
        
        [self.viewTallaMPrenda.layer setBorderWidth:1];
        
        [self.viewTallaMPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        UITextField *txtTallaMPrenda = (UITextField *)[cell viewWithTag:2];
        
        [txtTallaMPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"m"]];
        
        [txtTallaMPrenda setTag:index+2];
        
        txtTallaMPrenda.delegate = self;
        
        txtTallaMPrenda.keyboardType = UIKeyboardTypeNumberPad;
        
        [self.viewTallaLPrenda.layer setCornerRadius:2];
        
        [self.viewTallaLPrenda.layer setBorderWidth:1];
        
        [self.viewTallaLPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        UITextField *txtTallaLPrenda = (UITextField *)[cell viewWithTag:3];
        
        [txtTallaLPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"l"]];
        
        [txtTallaLPrenda setTag:index+3];
        
        txtTallaLPrenda.delegate = self;
        
        txtTallaLPrenda.keyboardType = UIKeyboardTypeNumberPad;
        
        [self.txtTallaXlPrenda.layer setCornerRadius:2];
        
        [self.txtTallaXlPrenda.layer setBorderWidth:1];
        
        [self.txtTallaXlPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        UITextField *txtTallaXlPrenda = (UITextField *)[cell viewWithTag:4];
        
        [txtTallaXlPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"xl"]];
        
        [txtTallaXlPrenda setTag:index+4];
        
        txtTallaXlPrenda.delegate = self;
        
        txtTallaXlPrenda.keyboardType = UIKeyboardTypeNumberPad;
        
        [self.viewTallaTotalPrenda.layer setCornerRadius:2];
        
        [self.viewTallaTotalPrenda.layer setBorderWidth:1];
        
        [self.viewTallaTotalPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        UITextField *txtTallaTotalPrenda = (UITextField *)[cell viewWithTag:5];
        
        [txtTallaTotalPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"xl"]];
        
        [txtTallaTotalPrenda setTag:index+5];
        
        txtTallaTotalPrenda.delegate = self;
        
        txtTallaTotalPrenda.keyboardType = UIKeyboardTypeNumberPad;
        
        [self.lblTipoPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"articulo"]];
        
        [self.lblSubTipoPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"subtitulo"]];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Referencia: %@",[[_data objectAtIndex:indexPath.row] objectForKey:@"referencia"]]];
        [string setColorForText:@"Referencia:" withColor:[UIColor colorWithRed:237.0/255.0 green:39.0/255.0 blue:63.0/255.0 alpha:1]];
        [string setColorForText:[[_data objectAtIndex:indexPath.row] objectForKey:@"referencia"] withColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]];
        
        [self.lblReferenciaPrenda setAttributedText:string];
        
        [self.lblValorUnidadPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"vunidad"]];
        
        UILabel *lblValorTotalPrenda = (UILabel *)[cell viewWithTag:6];
        
        [lblValorTotalPrenda setTag:index+6];
        
        NSMutableDictionary * dataUpdate = [self actualizarValores:(int)indexPath.row];
        
        NSString * total = [dataUpdate objectForKey:@"totalCompra"];
        
        [lblValorTotalPrenda setText:total];
        
        [self.txtTallaTotalPrenda setText:[dataUpdate objectForKey:@"cantidadTotal"]];
        
        [self.btnDeletePrenda setTag:indexPath.row];
        
        [self.btnDeletePrenda addTarget:self action:@selector(eliminarProductos:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else{
        // Cell Objeto
        static NSString *CellIdentifier = @"CellCarritoObjetos";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"CellCarritoObjetos" owner:self options:nil];
            cell = _celdaTablaObjetos;
            self.celdaTablaObjetos = nil;
        }
        
        NSString * urlEnvio = [[self.data objectAtIndex:indexPath.row] objectForKey:@"image"];
        if ([urlEnvio isEqualToString:@""]) {
            [self.indicadorObjeto stopAnimating];
            [self.imgObjeto setFrame:CGRectMake(self.imgObjeto.frame.origin.x, self.imgObjeto.frame.origin.y - 15, self.imgObjeto.frame.size.width, self.imgObjeto.frame.size.height)];
        }else{
            NSURL *imageURL = [NSURL URLWithString:urlEnvio];
            NSString *key = [[[self.data objectAtIndex:indexPath.row] objectForKey:@"image"] MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                self.imgObjeto.image = image;
                [self.indicadorObjeto stopAnimating];
            } else {
                //imagen.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.indicadorObjeto stopAnimating];
                        self.imgObjeto.image = image;
                    });
                });
            }
        }
        self.imgObjeto.contentMode = UIViewContentModeScaleAspectFill;
        //self.imgObjeto.clipsToBounds = YES;
        
        [self.lblTipoObjeto setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"articulo"]];
        
        [self.lblSubTipoObjeto setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"subtitulo"]];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Referencia: %@",[[_data objectAtIndex:indexPath.row] objectForKey:@"referencia"]]];
        [string setColorForText:@"Referencia:" withColor:[UIColor colorWithRed:237.0/255.0 green:39.0/255.0 blue:63.0/255.0 alpha:1]];
        [string setColorForText:[[_data objectAtIndex:indexPath.row] objectForKey:@"referencia"] withColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]];
        
        [self.lblReferenciaObjeto setAttributedText:string];
        
        [self.lblValorTotalObjeto setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"vunidad"]];
        
        [self.btnDeleteObjeto setTag:indexPath.row];
        [self.btnDeleteObjeto addTarget:self action:@selector(eliminarProductos:) forControlEvents:UIControlEventTouchUpInside];
        
        UITextField *cantidadObjeto = (UITextField *)[cell viewWithTag:7];
        [cantidadObjeto setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"cantidad"]];
        [cantidadObjeto setTag:index+7];
        [cantidadObjeto setDelegate:self];
        cantidadObjeto.keyboardType = UIKeyboardTypeNumberPad;
        
        UILabel *lblValorTotalObjeto = (UILabel *)[cell viewWithTag:8];
        
        [lblValorTotalObjeto setTag:index+8];
        
        [lblValorTotalObjeto setText:[self actualizarValoresObjetos:(int)indexPath.row]];
        
    }
    cell.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[_data objectAtIndex:indexPath.row] objectForKey:@"link"]]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * categoria = [[_data objectAtIndex:indexPath.row] objectForKey:@"categoria"];
    if ([categoria isEqualToString:@"1"]) {
        return 374;
    }
    return 349;
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([_txtSelected.text isEqualToString:@""]) {
        _txtSelected.text = @"0";
    }
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
    _txtSelected = textField;
    keyboardDoneButtonView = nil;
    doneButton = nil;
    negativeSeparator = nil;
    keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    negativeSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"
                                                  style:UIBarButtonItemStylePlain target:self
                                                 action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:negativeSeparator,doneButton, nil]];
    textField.inputAccessoryView = keyboardDoneButtonView;
    
    float origenTagTemp = (float)[textField tag]/10;
    int origenIndex = truncf(origenTagTemp);
    
    UITableViewCell *cell = [self.tblProducts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:origenIndex inSection:0]];
    celdaActiva = cell;
    tagCellSelected = origenIndex;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:TRUE];
    return true;
}

#pragma mark Metodos Teclado

-(void)mostrarTeclado:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width-60, 0.0);
    _tblProducts.contentInset = contentInsets;
    _tblProducts.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = _tblProducts.frame;
    aRect.size.height -= kbSize.width;
    if (!CGRectContainsPoint(aRect, celdaActiva.frame.origin) ) {
        // El 160 es un parametro que depende de la vista en la que se encuentra, se debe ajustar dependiendo del caso
        float tamano = 0.0;
        
        float version=[[UIDevice currentDevice].systemVersion floatValue];
        if(version <7.0){
            tamano = celdaActiva.frame.origin.y-100;
        }else{
            tamano = celdaActiva.frame.origin.y-100;
        }
        if(tamano<0)
            tamano=0;
        CGPoint scrollPoint = CGPointMake(0.0, tamano);
        if (tagCellSelected != tagAnterior) {
            [_tblProducts setContentOffset:scrollPoint animated:YES];
        }
        tagAnterior = tagCellSelected;
    }
}

-(void)ocultarTeclado:(NSNotification*)aNotification
{
    [ UIView animateWithDuration:0.4f animations:^
     {
         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
         _tblProducts.contentInset = contentInsets;
         _tblProducts.scrollIndicatorInsets = contentInsets;
     }completion:^(BOOL finished){
         
     }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)activeScrollView {
    if (tagCellSelected != -1) {
        NSString * categoria = [[_data objectAtIndex:tagCellSelected] objectForKey:@"categoria"];
        if ([categoria isEqualToString:@"1"]) {
            [self actualizarValoresCelda];
        }else{
            [self actualizarValoresCeldaObjetos];
        }
    }
    tagCellSelected = -1;
    if ([_txtSelected.text isEqualToString:@""]) {
        _txtSelected.text = @"0";
    }
    [self.view endEditing:TRUE];
}

#pragma mark Custom Delegate

- (void)saberStep:(NSNotification *)step{
    NSDictionary * data = step.object;
    accionContinuar = [[data objectForKey:@"step"] intValue];
    if (accionContinuar == 3) {
        [self.btnContinuar setHidden:TRUE];
        self.heigthViewCarConstraint.constant = 0;
        self.heigthViewStoreConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }
}

-(void)mostrarOcultarCuenta{
    if (mostrarOcultarSedesMas) {
        [self.vistaSedesMas setHidden:TRUE];
        self.vistaSedesMas = nil;
        mostrarOcultarSedesMas = NO;
    }
    
    if (mostrarOcultarCuenta) {
        [self.vistaCuenta setHidden:TRUE];
        self.vistaCuenta = nil;
        mostrarOcultarCuenta = NO;
    }else{
        [[NSBundle mainBundle] loadNibNamed:@"OpcionesTabCuenta" owner:self options:nil];
        [self.view addSubview:self.vistaCuenta];
        [self.vistaCuenta setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)];
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeViewCuenta:)];
        [letterTapRecognizer setNumberOfTapsRequired:1];
        [self.vistaContentCuenta addGestureRecognizer:letterTapRecognizer];
        mostrarOcultarCuenta = YES;
    }
}

- (void)hiddeViewCuenta:(UITapGestureRecognizer*)sender {
    [self mostrarOcultarCuenta];
}

-(void)mostrarOcultarSedesMas{
    if (mostrarOcultarCuenta) {
        [self.vistaCuenta setHidden:TRUE];
        self.vistaCuenta = nil;
        mostrarOcultarCuenta = NO;
    }
    
    if (mostrarOcultarSedesMas) {
        [self.vistaSedesMas setHidden:TRUE];
        self.vistaSedesMas = nil;
        mostrarOcultarSedesMas = NO;
    }else{
        [[NSBundle mainBundle] loadNibNamed:@"OpcionesTabSedesMas" owner:self options:nil];
        [self.view addSubview:self.vistaSedesMas];
        [self.vistaSedesMas setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)];
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeViewSedesMas:)];
        [letterTapRecognizer setNumberOfTapsRequired:1];
        [self.vistaContentSedesMas addGestureRecognizer:letterTapRecognizer];
        mostrarOcultarSedesMas = YES;
    }
}

- (void)hiddeViewSedesMas:(UITapGestureRecognizer*)sender {
    [self mostrarOcultarSedesMas];
}

#pragma mark - showAlert metodo

-(void)showAlert:(NSMutableDictionary *)msgDict
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[msgDict objectForKey:@"Title"]
                                 message:[msgDict objectForKey:@"Message"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    if ([[msgDict objectForKey:@"Cancel"] length]>0) {
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]) {
                                            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
                                            [_defaults setObject:@"NO" forKey:@"login"];
                                            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.parentViewController.navigationController viewControllers]];
                                            for (UIViewController *aViewController in allViewControllers) {
                                                if ([aViewController isKindOfClass:[RegistroViewController class]]) {
                                                    [self.parentViewController.navigationController popToViewController:aViewController animated:YES];
                                                }
                                            }
                                        }else if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"102"]){
                                            [self.data removeObjectAtIndex:tagDelete];
                                            [self.tblProducts reloadData];
                                        }
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[msgDict objectForKey:@"Cancel"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
    }else{
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
