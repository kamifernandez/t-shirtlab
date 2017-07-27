//
//  ResumenViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 29/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "ResumenViewController.h"
#import "utilidades.h"
#import "MetodosPagoViewController.h"
#import "NSMutableAttributedString+Color.h"

@interface ResumenViewController (){
    int selectedPicker;
    BOOL vistaDirecciones;
}

@end

@implementation ResumenViewController

-(void)viewWillAppear:(BOOL)animated
{
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(back)
                                                 name:@"BackNotificationResumen"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setControllerPass:)
                                                 name:@"MetodosPago"
                                               object:nil];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    vistaDirecciones = NO;
    [[NSBundle mainBundle] loadNibNamed:@"HeaderResumen" owner:self options:nil];
    if ([self.modoEnvio isEqualToString:@"2"]) {
        [self.viewEnvio setHidden:TRUE];
        [self.viewMetodoEnvio setFrame:CGRectMake(0, 263, self.viewMetodoEnvio.frame.size.width, self.viewMetodoEnvio.frame.size.height)];
        CGRect newFrame = self.viewHeader.frame;
        newFrame.size.height = 396;
        [self.viewHeader setFrame:newFrame];
        [self.iconoMetodoEnvio setImage:[UIImage imageNamed:@"t-shirt.png"]];
        [self.lblMetodoEnvio setText:@"Recoger en t-shirt lab"];
    }
    
    self.tblProducts.tableHeaderView = self.viewHeader;
    
    [[NSBundle mainBundle] loadNibNamed:@"FooterResumen" owner:self options:nil];
    
    self.tblProducts.tableFooterView = self.viewFooterTable;
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneClicked:)];
    UIBarButtonItem *negativeSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:negativeSeparator,doneButton, nil]];
    self.txtFijoEnvio.inputAccessoryView = keyboardDoneButtonView;
    self.txtFijoFacturacion.inputAccessoryView = keyboardDoneButtonView;
    
    UIToolbar * keyboardDoneButtonViewTwo = [[UIToolbar alloc] init];
    [keyboardDoneButtonViewTwo sizeToFit];
    UIBarButtonItem *doneButtonTwo = [[UIBarButtonItem alloc] initWithTitle:@"Siguiente"
                                                  style:UIBarButtonItemStylePlain target:self
                                                 action:@selector(nextClicked:)];
    UIBarButtonItem *negativeSeparatorTwo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonViewTwo setItems:[NSArray arrayWithObjects:negativeSeparatorTwo,doneButtonTwo, nil]];
    self.txtCelularFacturacion.inputAccessoryView = keyboardDoneButtonViewTwo;
    self.txtCelularEnvio.inputAccessoryView = keyboardDoneButtonViewTwo;
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    _data = [[NSMutableArray alloc]initWithArray:[_defaults objectForKey:@"arrayPedidos"]];
    if (_data) {
        [self.tblProducts reloadData];
    }
    
    /*+++++Harcode+++++++*/
    _dataPicker = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"Bogota DC" forKey:@"departamento"];
        }else{
            [dataInsert setObject:@"Cundinamarca" forKey:@"departamento"];
        }
        [_dataPicker addObject:dataInsert];
        dataInsert = nil;
    }
}

#pragma mark - Actualizar Valores Prendas

-(NSString *)actualizarValores:(int)index{
    
    int cantidaS = [[[_data objectAtIndex:index] objectForKey:@"s"] intValue];
    
    int cantidaM = [[[_data objectAtIndex:index] objectForKey:@"m"] intValue];
    
    int cantidaL = [[[_data objectAtIndex:index] objectForKey:@"l"] intValue];
    
    int cantidaXl = [[[_data objectAtIndex:index] objectForKey:@"xl"] intValue];
    
    int cantidadTotal = cantidaS + cantidaM + cantidaL + cantidaXl;
    
    int valor = [[[_data objectAtIndex:index] objectForKey:@"vunidad"] intValue] * cantidadTotal;
    
    int totalCompra = valor;
    
    return [utilidades decimalNumberFormat:totalCompra];
}

#pragma mark - Actualizar Valores Objetos

-(NSString *)actualizarValoresObjetos:(int)index{
    
    int cantidadTotal = [[[_data objectAtIndex:index] objectForKey:@"cantidad"] intValue];
    
    int valor = [[[_data objectAtIndex:index] objectForKey:@"vunidad"] intValue] * cantidadTotal;
    
    int totalCompra = valor;
    
    return [utilidades decimalNumberFormat:totalCompra];
}

#pragma mark IBActions

-(void)back{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneClicked:(id)sender
{
    if ([_txtSelected isEqual:_txtFijo]) {
        [self.tabBarController.view endEditing:YES];
    }
    [self.view endEditing:YES];
}

- (void)nextClicked:(id)sender
{
    if ([_txtSelected isEqual:_txtCelularFacturacion]) {
        [_txtFijoFacturacion becomeFirstResponder];
    }else if ([_txtSelected isEqual:_txtCelularEnvio]) {
        [_txtFijoEnvio becomeFirstResponder];
    }else{
        [_txtFijo becomeFirstResponder];
    }
}

-(IBAction)seePickerView:(id)sender{
    int tag = (int)[sender tag];
    selectedPicker = tag;
    [self.view endEditing:true];
    [self.tabBarController.view endEditing:YES];
    [[NSBundle mainBundle] loadNibNamed:@"PickerView" owner:self options:nil];
    [self.vistaPicker setAlpha:0.0];
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    [letterTapRecognizer setNumberOfTapsRequired:1];
    [self.vistaPicker addGestureRecognizer:letterTapRecognizer];
    if (vistaDirecciones) {
        [self.viewAgregarDireccion addSubview:self.vistaPicker];
        [self.vistaContentPicker setFrame:CGRectMake(0, self.view.window.frame.size.height - 190, self.view.frame.size.width, self.vistaContentPicker.frame.size.height)];
    }else{
        [self.view addSubview:self.vistaPicker];
        [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height - 190, self.view.frame.size.width, self.vistaContentPicker.frame.size.height)];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.vistaPicker setAlpha:1.0];
    }completion:^(BOOL finished){
        [self.pickerView reloadAllComponents];
    }];
}

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    [self selectPikcerButton:nil];
}

-(IBAction)selectPikcerButton:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{
        if (vistaDirecciones) {
            [self.vistaContentPicker setFrame:CGRectMake(0, self.view.window.frame.size.height, self.vistaContentPicker.frame.size.width, self.vistaContentPicker.frame.size.height)];
        }else{
            [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height, self.vistaContentPicker.frame.size.width, self.vistaContentPicker.frame.size.height)];
        }
    }completion:^(BOOL finished){
        [self.vistaPicker removeFromSuperview];
        self.vistaPicker = nil;
    }];
}

/// Acá Voy

-(IBAction)agregarDireccion:(id)sender{
    [self.view endEditing:true];
    vistaDirecciones = TRUE;
    [[NSBundle mainBundle] loadNibNamed:@"VistaAgregarDireccion" owner:self options:nil];
    [self.viewAgregarDireccion setAlpha:0.0];
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAgregarDireccion:)];
    [letterTapRecognizer setNumberOfTapsRequired:1];
    [self.viewNegraAgregarDireccion addGestureRecognizer:letterTapRecognizer];
    [self.tabBarController.view addSubview:self.viewAgregarDireccion];
    [self.viewContentAgregarDireccion.layer setCornerRadius:10];
    [self.viewAgregarDireccion setFrame:self.view.window.frame];
    
    int heigthContentDirecciones = 380;
    int restHeigthContentDirecciones = 380;
    if (([[UIScreen mainScreen] bounds].size.height == 568)) {
        heigthContentDirecciones = 420;
        restHeigthContentDirecciones = 120;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        heigthContentDirecciones = self.btnCrearDireccion.frame.origin.y + self.btnCrearDireccion.frame.size.height + 10;
        restHeigthContentDirecciones = 120;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        heigthContentDirecciones = self.btnCrearDireccion.frame.origin.y + self.btnCrearDireccion.frame.size.height + 50;
        restHeigthContentDirecciones = 120;
    }
    
    [self.viewContentAgregarDireccion setFrame:CGRectMake(self.viewContentAgregarDireccion.frame.origin.x, self.viewContentAgregarDireccion.frame.size.height/2 - restHeigthContentDirecciones, self.viewContentAgregarDireccion.frame.size.width, heigthContentDirecciones)];
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneClicked:)];
    UIBarButtonItem *negativeSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:negativeSeparator,doneButton, nil]];
    self.txtFijo.inputAccessoryView = keyboardDoneButtonView;
    UIToolbar * keyboardDoneButtonViewTwo = [[UIToolbar alloc] init];
    [keyboardDoneButtonViewTwo sizeToFit];
    UIBarButtonItem *doneButtonTwo = [[UIBarButtonItem alloc] initWithTitle:@"Siguiente"
                                                                      style:UIBarButtonItemStylePlain target:self
                                                                     action:@selector(nextClicked:)];
    UIBarButtonItem *negativeSeparatorTwo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonViewTwo setItems:[NSArray arrayWithObjects:negativeSeparatorTwo,doneButtonTwo, nil]];
    self.txtCelular.inputAccessoryView = keyboardDoneButtonViewTwo;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.viewAgregarDireccion setAlpha:1.0];
    }completion:^(BOOL finished){
        [self.scrollDireccion setContentSize:CGSizeMake(0, self.btnCrearDireccion.frame.origin.y + self.btnCrearDireccion.frame.size.height + 5)];
    }];
}

- (void)closeAgregarDireccion:(UITapGestureRecognizer*)sender {
    [self.viewAgregarDireccion removeFromSuperview];
    self.viewAgregarDireccion = nil;
    vistaDirecciones = FALSE;
}

-(IBAction)btnAgregarDireccion:(id)sender{
    if ([self.txtDepartamento.text isEqualToString:@""] || [self.txtCiudad.text isEqualToString:@""] || [self.txtDireccion.text isEqualToString:@""] || [self.txtNombre.text isEqualToString:@""] || [self.txtCorreo.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor llena la información necesaria de los campos para poder realizar esta acción" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([utilidades validateEmailWithString:self.txtCorreo.text]){
            [self.txtDepartamentoEnvio setText:self.txtDepartamento.text];
            [self.txtCiudadEnvio setText:self.txtCiudad.text];
            [self.txtDireccionEnvio setText:self.txtDireccion.text];
            [self.txtCelularEnvio setText:self.txtCelular.text];
            [self.txtFijoEnvio setText:self.txtFijo.text];
            [self closeAgregarDireccion:nil];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor verifica el campo correo sea valido" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }
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
        static NSString *CellIdentifier = @"CellMiCarritoPrendasResumen";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"CellMiCarritoPrendasResumen" owner:self options:nil];
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
        
        
        /*[self.viewTallaSPrenda.layer setCornerRadius:2];
        
        [self.viewTallaSPrenda.layer setBorderWidth:1];
        
        [self.viewTallaSPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];*/
        
        UITextField *txtTallaSPrenda = (UITextField *)[cell viewWithTag:1];
        
        [txtTallaSPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"s"]];
        
        [txtTallaSPrenda setTag:index+1];
        
        /*[self.viewTallaMPrenda.layer setCornerRadius:2];
        
        [self.viewTallaMPrenda.layer setBorderWidth:1];
        
        [self.viewTallaMPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];*/
        
        UITextField *txtTallaMPrenda = (UITextField *)[cell viewWithTag:2];
        
        [txtTallaMPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"m"]];
        
        [txtTallaMPrenda setTag:index+2];
        
        /*[self.viewTallaLPrenda.layer setCornerRadius:2];
        
        [self.viewTallaLPrenda.layer setBorderWidth:1];
        
        [self.viewTallaLPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];*/
        
        UITextField *txtTallaLPrenda = (UITextField *)[cell viewWithTag:3];
        
        [txtTallaLPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"l"]];
        
        [txtTallaLPrenda setTag:index+3];
        
        /*[self.txtTallaXlPrenda.layer setCornerRadius:2];
        
        [self.txtTallaXlPrenda.layer setBorderWidth:1];
        
        [self.txtTallaXlPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];*/
        
        UITextField *txtTallaXlPrenda = (UITextField *)[cell viewWithTag:4];
        
        [txtTallaXlPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"xl"]];
        
        [txtTallaXlPrenda setTag:index+4];
        
        /*[self.viewTallaTotalPrenda.layer setCornerRadius:2];
        
        [self.viewTallaTotalPrenda.layer setBorderWidth:1];
        
        [self.viewTallaTotalPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];*/
        
        UITextField *txtTallaTotalPrenda = (UITextField *)[cell viewWithTag:5];
        
        [txtTallaTotalPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"xl"]];
        
        [txtTallaTotalPrenda setTag:index+5];
        
        [self.lblTipoPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"articulo"]];
        
        [self.lblSubTipoPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"subtitulo"]];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Referencia: %@",[[_data objectAtIndex:indexPath.row] objectForKey:@"referencia"]]];
        [string setColorForText:@"Referencia:" withColor:[UIColor colorWithRed:237.0/255.0 green:39.0/255.0 blue:63.0/255.0 alpha:1]];
        [string setColorForText:[[_data objectAtIndex:indexPath.row] objectForKey:@"referencia"] withColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]];
        
        [self.lblReferenciaPrenda setAttributedText:string];
        
        [self.lblValorUnidadPrenda setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"vunidad"]];
        
        UILabel *lblValorTotalPrenda = (UILabel *)[cell viewWithTag:6];
        
        [lblValorTotalPrenda setTag:index+6];
        
        [lblValorTotalPrenda setText:[self actualizarValores:(int)indexPath.row]];
        
        int cantidaS = [[[_data objectAtIndex:indexPath.row] objectForKey:@"s"] intValue];
        
        int cantidaM = [[[_data objectAtIndex:indexPath.row] objectForKey:@"m"] intValue];
        
        int cantidaL = [[[_data objectAtIndex:indexPath.row] objectForKey:@"l"] intValue];
        
        int cantidaXl = [[[_data objectAtIndex:indexPath.row] objectForKey:@"xl"] intValue];
        
        int cantidadPrendas = cantidaS + cantidaM + cantidaL + cantidaXl;
        
        [self.txtTallaTotalPrenda setText:[NSString stringWithFormat:@"%i",cantidadPrendas]];
        
        
    }else{
        // Cell Objeto
        static NSString *CellIdentifier = @"CellCarritoObjetosResumen";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"CellCarritoObjetosResumen" owner:self options:nil];
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
        
        UITextField *cantidadObjeto = (UITextField *)[cell viewWithTag:7];
        [cantidadObjeto setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"cantidad"]];
        [cantidadObjeto setTag:index+7];
        
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
        return 333;
    }
    return 292;
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _tViewSeleccionado = textField.superview;
    _txtSelected = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtDireccionFacturacion isEqual:textField]) {
        [_txtCelularFacturacion becomeFirstResponder];
    }else if ([_txtCelularFacturacion isEqual:textField]){
        [_txtFijoFacturacion becomeFirstResponder];
    }else if ([_txtFijoFacturacion isEqual:textField]){
        [self.view endEditing:TRUE];
    }else if ([_txtDireccionEnvio isEqual:textField]){
        [_txtCelularEnvio becomeFirstResponder];
    }else if ([_txtCelularEnvio isEqual:textField]){
        [_txtFijoEnvio becomeFirstResponder];
    }else if ([_txtFijoEnvio isEqual:textField]){
        [self.view endEditing:TRUE];
    }else if ([_txtDireccion isEqual:textField]){
        [_txtNombre becomeFirstResponder];
    }else if ([_txtNombre isEqual:textField]){
        [_txtCorreo becomeFirstResponder];
    }else if ([_txtCorreo isEqual:textField]){
        [_txtCelular becomeFirstResponder];
    }else if ([_txtCelular isEqual:textField]){
        [_txtFijo becomeFirstResponder];
    }else if ([_txtFijo isEqual:textField]){
        [self.view endEditing:TRUE];
    }
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
    if (!CGRectContainsPoint(aRect, _tViewSeleccionado.frame.origin) ) {
        // El 160 es un parametro que depende de la vista en la que se encuentra, se debe ajustar dependiendo del caso
        float tamano = 0.0;
        
        float version=[[UIDevice currentDevice].systemVersion floatValue];
        if(version <7.0){
            tamano = _tViewSeleccionado.frame.origin.y-100;
        }else{
            tamano = _tViewSeleccionado.frame.origin.y-130;
        }
        if(tamano<0)
            tamano=0;
        CGPoint scrollPoint = CGPointMake(0.0, tamano);
        if (vistaDirecciones) {
            [_scrollDireccion setContentOffset:scrollPoint animated:YES];
        }else{
            [_tblProducts setContentOffset:scrollPoint animated:YES];
        }
    }
}

-(void)ocultarTeclado:(NSNotification*)aNotification
{
    [ UIView animateWithDuration:0.4f animations:^
     {
         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
         if (vistaDirecciones) {
             _scrollDireccion.contentInset = contentInsets;
             _scrollDireccion.scrollIndicatorInsets = contentInsets;
         }else{
             _tblProducts.contentInset = contentInsets;
             _tblProducts.scrollIndicatorInsets = contentInsets;
         }
     }completion:^(BOOL finished){
         
     }];
}

#pragma mark UiPicker Delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataPicker count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = @"";
    
    title=[[_dataPicker objectAtIndex:row] objectForKey:@"departamento"];
    
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = @"";
    title=[[_dataPicker objectAtIndex:row] objectForKey:@"departamento"];
    if (selectedPicker == 1) {
        [self.txtDepartamentoFacturacion setText:title];
    }else if (selectedPicker == 2){
        [self.txtCiudadFacturacion setText:title];
    }else if (selectedPicker == 3){
        [self.txtDepartamentoEnvio setText:title];
    }else if (selectedPicker == 4){
        [self.txtCiudadEnvio setText:title];
    }else if (selectedPicker == 5){
        [self.txtDepartamento setText:title];
    }else{
        [self.txtCiudad setText:title];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

#pragma mark - Custom Delegates

- (void)setControllerPass:(NSNotification*)notification{
    if ([self.txtDepartamentoFacturacion.text isEqualToString:@""] || [self.txtCiudadFacturacion.text isEqualToString:@""] || [self.txtDireccionFacturacion.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor llena la información necesaria de los campos facturación para poder realizar esta acción" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([self.txtDepartamentoEnvio.text isEqualToString:@""] || [self.txtCiudadEnvio.text isEqualToString:@""] || [self.txtDireccionEnvio.text isEqualToString:@""]) {
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor llena la información necesaria de los campos facturación para poder realizar esta acción" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            [msgDict setValue:@"" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else{
            NSDictionary* userInfo = @{@"step": @"3"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SaberStepNotification" object:userInfo];
            [self.view endEditing:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MetodosPagoViewController *metodosPagoViewController = [story instantiateViewControllerWithIdentifier:@"MetodosPagoViewController"];
            [self.navigationController pushViewController:metodosPagoViewController animated:YES];
        }
    }
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
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[msgDict objectForKey:@"Cancel"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
    }else{
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]) {
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
