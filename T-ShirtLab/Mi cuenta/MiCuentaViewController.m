//
//  MiCuentaViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 14/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "MiCuentaViewController.h"
#import "utilidades.h"
#import "RegistroViewController.h"
#import "MisDireccionesViewController.h"
#import "MisPedidosViewController.h"
#import "RequestUrl.h"

@interface MiCuentaViewController (){
    int tag;
    int tagDepartamento;
    int tagCiudad;
}

@end

@implementation MiCuentaViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES; 
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(configurerLayout) withObject:nil afterDelay:0.001];
    [self configurerView];
}

-(void)configurerView{
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Siguiente"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(nextClick:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexible,doneButton, nil]];
    self.txtCedulaNit.inputAccessoryView = keyboardDoneButtonView;
    
    self.txtFijo.inputAccessoryView = keyboardDoneButtonView;
    
    keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexible,doneButton, nil]];
    
    self.txtCelular.inputAccessoryView = keyboardDoneButtonView;
    
    self.scroll.translatesAutoresizingMaskIntoConstraints  = NO;
    [self.scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, 2000)];
    /*+++++Harcode+++++++*/
    /*_data = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"Bogota DC" forKey:@"departamento"];
        }else{
            [dataInsert setObject:@"Cundinamarca" forKey:@"departamento"];
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    
    _data2 = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"Bogota DC" forKey:@"ciudad"];
        }else{
            [dataInsert setObject:@"Bogotá" forKey:@"ciudad"];
        }
        [_data2 addObject:dataInsert];
        dataInsert = nil;
    }*/
    
    [self requestServerObtenerUsuario];
    
    if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.trailingMisDirecciones.constant = self.trailingMisDirecciones.constant + 15;
        self.landingCerrarSesion.constant = self.landingCerrarSesion.constant + 15;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.trailingMisDirecciones.constant = self.trailingMisDirecciones.constant + 15;
        self.landingCerrarSesion.constant = self.landingCerrarSesion.constant + 15;
    }
    [self.view layoutIfNeeded];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerLayout{
    
    UIColor *color = [UIColor darkGrayColor];
    self.txtNombres.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nombres" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtApellidos.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Apellidos" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtCorreo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtCedulaNit.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirmar Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtContrasena.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtCiudad.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtDepartamento.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtFijo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtDireccion.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtCelular.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Celular" attributes:@{NSForegroundColorAttributeName: color}];
    
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.width);
    if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_viewContentScroll attribute: NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:375.0]];
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_viewContentScroll attribute: NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:414.0]];
    }
}

#pragma mark Own Methods

-(void)ponerInformacion{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [self.lblTituloTipo setText:[[_defaults objectForKey:@"tipoPersona"] capitalizedString]];
    if ([[_defaults objectForKey:@"tipoPersona"] isEqualToString:@"persona"]) {
        [self.txtNombres setText:[_dataUsuario objectForKey:@"name"]];
        [self.txtApellidos setText:[_dataUsuario objectForKey:@"apellidos"]];
        [self.txtCedulaNit setText:[_dataUsuario objectForKey:@"identificacion"]];
    }else{
        [self.txtNombres setText:[_dataUsuario objectForKey:@"empresa"]];
        [self.txtApellidos setText:[_dataUsuario objectForKey:@"name"]];
        [self.txtCedulaNit setText:[_dataUsuario objectForKey:@"identificacion"]];
        [self.imgIconNombreEmpresa setImage:[UIImage imageNamed:@"company_ico.png"]];
    }
    [self.txtContrasena setText:[_defaults objectForKey:@"password"]];
    [self.txtCorreo setText:[_dataUsuario objectForKey:@"email"]];
    [self.txtDireccion setText:[_dataUsuario objectForKey:@"direccion"]];
    [self.txtDepartamento setText:[_dataUsuario objectForKey:@"direccion"]];
    [self.txtCiudad setText:[_dataUsuario objectForKey:@"ciudad"]];
    [self.txtFijo setText:[_dataUsuario objectForKey:@"telefono"]];
    [self.txtCelular setText:[_dataUsuario objectForKey:@"celular"]];
}

#pragma mark LayoutsScroll

-(void)viewDidLayoutSubviews
{
    [self.scroll setContentSize:CGSizeMake(0, 2000)];
    self.scroll.contentSize = self.viewContentScroll.bounds.size;
}

#pragma mark IBActions

- (void)nextClick:(id)sender
{
    if ([_txtSeleccionado isEqual:self.txtCedulaNit]) {
        [self.txtDireccion becomeFirstResponder];
    }else if ([_txtSeleccionado isEqual:self.txtFijo]){
        [self.txtCelular becomeFirstResponder];
    }
}

- (void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

-(IBAction)seePickerView:(id)sender{
    [self.view endEditing:true];
    tag = (int)[sender tag];
    if (tag == 1) {
        if ([self.txtDepartamento.text isEqualToString:@""]) {
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor selecciona primero un departamento" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else{
            [self requestServerCiudades];
        }
    }else{
        if (_dataDepartamentos) {
            [[NSBundle mainBundle] loadNibNamed:@"PickerView" owner:self options:nil];
            [self.vistaPicker setAlpha:0.0];
            UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
            [letterTapRecognizer setNumberOfTapsRequired:1];
            [self.vistaPicker addGestureRecognizer:letterTapRecognizer];
            [self.view addSubview:self.vistaPicker];
            [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height - 194, self.view.frame.size.width, self.vistaContentPicker.frame.size.height)];
            [UIView animateWithDuration:0.5 animations:^{
                [self.vistaPicker setAlpha:1.0];
            }completion:^(BOOL finished){
                [self.pickerView reloadAllComponents];
            }];
        }else{
            [self requestServerDepartamentos];
        }
    }
}

-(IBAction)selectPikcerButton:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{
        [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height, self.vistaContentPicker.frame.size.width, self.vistaContentPicker.frame.size.height)];
    }completion:^(BOOL finished){
        [self.vistaPicker removeFromSuperview];
        self.vistaPicker = nil;
    }];
}

-(IBAction)validarCampos:(id)sender{
    if ([utilidades verifyEmpty:self.viewContentScroll]){
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([utilidades validateEmailWithString:self.txtCorreo.text]){
            [self requestServerActualizarUsuario];
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

-(IBAction)misDirecciones:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MisDireccionesViewController *misDireccionesViewController = [story instantiateViewControllerWithIdentifier:@"MisDireccionesViewController"];
    [self.navigationController pushViewController:misDireccionesViewController animated:YES];
}

-(IBAction)cerrarSesion:(id)sender{
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Atención" forKey:@"Title"];
    [msgDict setValue:@"¿Desea cerrar la sesión actual?" forKey:@"Message"];
    [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
    [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
    [msgDict setValue:@"101" forKey:@"Tag"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
}

-(IBAction)backButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _tViewSeleccionado = textField.superview;
    _txtSeleccionado = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtNombres isEqual:textField]) {
        [_txtApellidos becomeFirstResponder];
    }else if ([_txtApellidos isEqual:textField]){
        [_txtCorreo becomeFirstResponder];
    }else if ([_txtCorreo isEqual:textField]){
        [_txtContrasena becomeFirstResponder];
    }else if ([_txtContrasena isEqual:textField]){
        [_txtCedulaNit becomeFirstResponder];
    }else if ([_txtCedulaNit isEqual:textField]){
        [_txtDireccion becomeFirstResponder];
    }else if ([_txtDireccion isEqual:textField]){
        [self.view endEditing:TRUE];
    }else if ([_txtFijo isEqual:textField]){
        [_txtCelular becomeFirstResponder];
    }else if ([_txtCelular isEqual:textField]){
        [self.view endEditing:TRUE];
    }
    return true;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField isEqual:_txtFijo]){
        NSUInteger maxLength = 0;
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        maxLength = 6;
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= maxLength || returnKey;
    }else if([textField isEqual:_txtCelular]){
        NSUInteger maxLength = 0;
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        maxLength = 10;
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= maxLength || returnKey;
    }else if([textField isEqual:_txtCedulaNit]){
        NSUInteger maxLength = 0;
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        maxLength = 15;
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= maxLength || returnKey;
    }
    return YES;
}

#pragma mark Metodos Teclado

-(void)mostrarTeclado:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width-60, 0.0);
    _scroll.contentInset = contentInsets;
    _scroll.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = _scroll.frame;
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
        [_scroll setContentOffset:scrollPoint animated:YES];
    }
}

-(void)ocultarTeclado:(NSNotification*)aNotification
{
    [ UIView animateWithDuration:0.4f animations:^
     {
         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
         _scroll.contentInset = contentInsets;
         _scroll.scrollIndicatorInsets = contentInsets;
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
    if (tag == 0) {
        return [_dataDepartamentos count];
    }
    return [_dataCiudad count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = @"";
    if (tag == 0) {
        title=[[_dataDepartamentos objectAtIndex:row] objectForKey:@"nombre"];
    }else
        title=[[_dataCiudad objectAtIndex:row] objectForKey:@"nombre"];
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = @"";
    if (tag == 0) {
        title=[[_dataDepartamentos objectAtIndex:row] objectForKey:@"nombre"];
        [self.txtDepartamento setText:title];
        tagDepartamento = [[[_dataDepartamentos objectAtIndex:row] objectForKey:@"id"] intValue];
    }else{
        title=[[_dataCiudad objectAtIndex:row] objectForKey:@"nombre"];
        [self.txtCiudad setText:title];
        tagCiudad = [[[_dataCiudad objectAtIndex:row] objectForKey:@"id"] intValue];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

#pragma mark Gesture Recognizer

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    [self selectPikcerButton:nil];
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
                                            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                                            for (UIViewController *aViewController in allViewControllers) {
                                                if ([aViewController isKindOfClass:[RegistroViewController class]]) {
                                                    [self.navigationController popToViewController:aViewController animated:YES];
                                                }
                                            }
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

#pragma mark - WebServices
#pragma mark - RequestServer ObtenerUsuario

-(void)requestServerObtenerUsuario{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerObtenerUsuario) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerObtenerUsuario{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dataSend = [[NSMutableDictionary alloc]init];
    [dataSend setObject:[_defaults objectForKey:@"uid"] forKey:@"uid"];
    
    _dataUsuario = [RequestUrl obtenerUsuario:dataSend];
    [self performSelectorOnMainThread:@selector(ocultarCargandoObtenerUsuario) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoObtenerUsuario{
    if ([_dataUsuario count]>0) {
        if ([_dataUsuario objectForKey:@"id"]) {
            [self ponerInformacion];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"No tiene información para mostrar" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Algo sucedió, por favor intenta de nuevo" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - RequestServer Actualizar Usuario

-(void)requestServerActualizarUsuario{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerActualizarUsuario) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerActualizarUsuario{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dataSend = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",[_defaults objectForKey:@"tipoPersona"]);
    [dataSend setObject:[_defaults objectForKey:@"tipoPersona"] forKey:@"tipo"];
    NSString * keyNombre = @"nombre";
    if ([[_defaults objectForKey:@"tipoPersona"] isEqualToString:@"empresa"]) {
        keyNombre = @"empresa";
    }
    [dataSend setObject:self.txtNombres.text forKey:keyNombre];
    
    if ([self.txtContrasena.text isEqualToString:@""]) {
        [dataSend setObject:[_defaults objectForKey:@"password"] forKey:@"password"];
    }else{
        [dataSend setObject:self.txtContrasena.text forKey:@"password"];
    }
    
    NSString * keyDocumento = @"cedula";
    
    if ([[_defaults objectForKey:@"tipoPersona"] isEqualToString:@"empresa"]) {
        keyDocumento = @"nit";
    }
    
    [dataSend setObject:self.txtCedulaNit.text forKey:keyDocumento];
    
    [dataSend setObject:self.txtDireccion.text forKey:@"direccion"];
    [dataSend setObject:[NSString stringWithFormat:@"%i",tagCiudad] forKey:@"ciudad"];
    [dataSend setObject:self.txtFijo.text forKey:@"telefono"];
    [dataSend setObject:self.txtCelular.text forKey:@"celular"];
    
    NSString * keyApellido = @"apellidos";
    if ([[_defaults objectForKey:@"tipoPersona"] isEqualToString:@"empresa"]) {
        keyApellido = @"contacto";
    }
    
    [dataSend setObject:self.txtApellidos.text forKey:keyApellido];
    _dataUsuario = nil;
    _dataUsuario = [RequestUrl actualizarUsuario:dataSend];
    [self performSelectorOnMainThread:@selector(ocultarCargandoActualizarUsuario) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoActualizarUsuario{
    if ([_dataUsuario count]>0) {
        int status = [[_dataUsuario objectForKey:@"status"] intValue];
        if (status == 200) {
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:[_dataUsuario objectForKey:@"message"] forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:[_dataUsuario objectForKey:@"message"] forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Algo sucedió, por favor intenta de nuevo" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - RequestServer Departamentos

-(void)requestServerDepartamentos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerDepartamentos) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerDepartamentos{
    _dataDepartamentos = [RequestUrl obtenerDepartamentos];
    [self performSelectorOnMainThread:@selector(ocultarCargandoDepartamentos) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoDepartamentos{
    if ([_dataDepartamentos count]>0) {
        [[NSBundle mainBundle] loadNibNamed:@"PickerView" owner:self options:nil];
        [self.vistaPicker setAlpha:0.0];
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        [letterTapRecognizer setNumberOfTapsRequired:1];
        [self.vistaPicker addGestureRecognizer:letterTapRecognizer];
        [self.view addSubview:self.vistaPicker];
        [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height - 194, self.view.frame.size.width, self.vistaContentPicker.frame.size.height)];
        [UIView animateWithDuration:0.5 animations:^{
            [self.vistaPicker setAlpha:1.0];
        }completion:^(BOOL finished){
            [self.pickerView reloadAllComponents];
        }];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Algo sucedió, por favor intenta de nuevo" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - RequestServer Ciudades

-(void)requestServerCiudades{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerCiudades) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerCiudades{
    _dataCiudad = [RequestUrl obtenerCiudades:[NSString stringWithFormat:@"%i",tagDepartamento]];
    [self performSelectorOnMainThread:@selector(ocultarCargandoCiudades) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoCiudades{
    if ([_dataCiudad count]>0) {
        [[NSBundle mainBundle] loadNibNamed:@"PickerView" owner:self options:nil];
        [self.vistaPicker setAlpha:0.0];
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        [letterTapRecognizer setNumberOfTapsRequired:1];
        [self.vistaPicker addGestureRecognizer:letterTapRecognizer];
        [self.view addSubview:self.vistaPicker];
        [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height - 194, self.view.frame.size.width, self.vistaContentPicker.frame.size.height)];
        [UIView animateWithDuration:0.5 animations:^{
            [self.vistaPicker setAlpha:1.0];
        }completion:^(BOOL finished){
            [self.pickerView reloadAllComponents];
        }];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Algo sucedió, por favor intenta de nuevo" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - Metodos Vista Cargando

-(void)mostrarCargando{
    @autoreleasepool {
        if (_vistaWait.hidden == TRUE) {
            _vistaWait.hidden = FALSE;
            CALayer * l = [_vistaWait layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10.0];
            // You can even add a border
            [l setBorderWidth:1.5];
            [l setBorderColor:[[UIColor whiteColor] CGColor]];
            
            [_indicador startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicador stopAnimating];
        }
    }
}

@end
