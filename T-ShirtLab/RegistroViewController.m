//
//  RegistroViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 5/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "RegistroViewController.h"
#import "utilidades.h"
#import "ControlSedesMasViewController.h"
#import "ControladorCuentaViewController.h"
#import "RequestUrl.h"

@import FirebaseCrash;

@interface RegistroViewController ()

@end

@implementation RegistroViewController

-(void)viewWillAppear:(BOOL)animated
{
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(configurerLayout) withObject:nil afterDelay:0.001];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"login"] isEqualToString:@"SI"]) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"TabBar"];
        [vc setDelegate:self];
        [self.navigationController pushViewController:vc animated:NO];
    }
    [self configurarVista];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurarVista{
    self.personaEmpresa = @"persona";
    [self.txtNombres setPlaceholder:@"Nombres"];
    [self.txtApellidos setPlaceholder:@"Apellidos"];
    [self.txtCorreo setPlaceholder:@"Corro Electrónico"];
    [self.txtConfirmarCorreo setPlaceholder:@"Confirmar Corro Electrónico"];
    [self.txtContrasena setPlaceholder:@"Contraseña"];
    FIRCrashNSLog(@"ConfigurerView RegistroViewController");
    
    UIColor *color = [UIColor darkGrayColor];
    self.txtNombres.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nombres" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtApellidos.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Apellidos" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtCorreo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtConfirmarCorreo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirmar Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtContrasena.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
}

-(void)configurerLayout{
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.width);
    if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_viewContentScroll attribute: NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:375.0]];
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_viewContentScroll attribute: NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:414.0]];
    }
}

#pragma mark Own Methods

-(void)homeView{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"TabBar"];
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark IBActions

-(IBAction)personaEmpresa:(id)sender{
    int tag = (int)[sender tag];
    [self.txtNombres setText:@""];
    [self.txtApellidos setText:@""];
    [self.txtCorreo setText:@""];
    [self.txtConfirmarCorreo setText:@""];
    [self.txtContrasena setText:@""];
    [self.btnAceptarTerminos setImage:[UIImage imageNamed:@"chek.png"] forState:UIControlStateNormal];
    if (tag == 0) {
        self.personaEmpresa = @"persona";
        [self.btnPerson setImage:[UIImage imageNamed:@"person.png"] forState:UIControlStateNormal];
        [self.btnCompany setImage:[UIImage imageNamed:@"company_inactive.png"] forState:UIControlStateNormal];
        [self.iconPersonCompany setImage:[UIImage imageNamed:@"user.png"]];
        [self.txtNombres setPlaceholder:@"Nombres"];
        [self.txtApellidos setPlaceholder:@"Apellidos"];
        [self.txtCorreo setPlaceholder:@"Corro Electrónico"];
        [self.txtConfirmarCorreo setPlaceholder:@"Confirmar Corro Electrónico"];
        [self.txtContrasena setPlaceholder:@"Contraseña"];
        
        UIColor *color = [UIColor darkGrayColor];
        self.txtNombres.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nombres" attributes:@{NSForegroundColorAttributeName: color}];
        
        self.txtApellidos.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Apellidos" attributes:@{NSForegroundColorAttributeName: color}];
        
        self.txtCorreo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
        
        self.txtConfirmarCorreo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirmar Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
        
        self.txtContrasena.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
        
    }else{
        self.personaEmpresa = @"empresa";
        [self.btnPerson setImage:[UIImage imageNamed:@"person_inactive.png"] forState:UIControlStateNormal];
        [self.btnCompany setImage:[UIImage imageNamed:@"company.png"] forState:UIControlStateNormal];
        [self.iconPersonCompany setImage:[UIImage imageNamed:@"company_ico.png"]];
        [self.txtNombres setPlaceholder:@"Empresa"];
        [self.txtApellidos setPlaceholder:@"Contácto (Nombres y Apellidos)"];
        [self.txtCorreo setPlaceholder:@"Corro Electrónico"];
        [self.txtConfirmarCorreo setPlaceholder:@"Confirmar Corro Electrónico"];
        [self.txtContrasena setPlaceholder:@"Contraseña"];
        
        UIColor *color = [UIColor darkGrayColor];
        self.txtNombres.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nombres" attributes:@{NSForegroundColorAttributeName: color}];
        
        self.txtApellidos.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Apellidos" attributes:@{NSForegroundColorAttributeName: color}];
        
        self.txtCorreo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
        
        self.txtConfirmarCorreo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirmar Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
        
        self.txtContrasena.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
    }
}

-(IBAction)aceptarTerminos:(id)sender{
    UIImage * imgComprare = [UIImage imageNamed:@"chek.png"];
    NSData *imageDataCompare = UIImagePNGRepresentation(imgComprare);
    NSData *imageData = UIImagePNGRepresentation(self.btnAceptarTerminos.currentImage);
    if ([imageDataCompare isEqual:imageData]) {
        [self.btnAceptarTerminos setImage:[UIImage imageNamed:@"chekactive.png"] forState:UIControlStateNormal];
    }else{
        [self.btnAceptarTerminos setImage:[UIImage imageNamed:@"chek.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)validarCampos:(id)sender{
    if ([self.txtNombres.text isEqualToString:@""] || [self.txtApellidos.text isEqualToString:@""] || [self.txtCorreo.text isEqualToString:@""] || [self.txtConfirmarCorreo.text isEqualToString:@""] || [self.txtContrasena.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([utilidades validateEmailWithString:self.txtCorreo.text]){
            
            if (![self.txtCorreo.text isEqualToString:self.txtConfirmarCorreo.text]) {
                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                [msgDict setValue:@"Atención" forKey:@"Title"];
                [msgDict setValue:@"Por favor verifica que los campos de correo coincidan" forKey:@"Message"];
                [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                [msgDict setValue:@"" forKey:@"Cancel"];
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                    waitUntilDone:YES];
            }else{
                UIImage * imgComprare = [UIImage imageNamed:@"chek.png"];
                NSData *imageDataCompare = UIImagePNGRepresentation(imgComprare);
                NSData *imageData = UIImagePNGRepresentation(self.btnAceptarTerminos.currentImage);
                if ([imageDataCompare isEqual:imageData]) {
                    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                    [msgDict setValue:@"Atención" forKey:@"Title"];
                    [msgDict setValue:@"Antes de continuar por favor acepta los términos y condiciones" forKey:@"Message"];
                    [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                    [msgDict setValue:@"" forKey:@"Cancel"];
                    
                    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                        waitUntilDone:YES];
                }else{
                    [self requestServerRegistroUsuario];
                }
            }
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

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _tViewSeleccionado = textField.superview;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtNombres isEqual:textField]) {
        [_txtApellidos becomeFirstResponder];
    }else if ([_txtApellidos isEqual:textField]){
        [_txtCorreo becomeFirstResponder];
    }else if ([_txtCorreo isEqual:textField]){
        [_txtConfirmarCorreo becomeFirstResponder];
    }else if ([_txtConfirmarCorreo isEqual:textField]){
        [_txtContrasena becomeFirstResponder];
    }else if ([_txtContrasena isEqual:textField]){
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
                                            [self homeView];
                                        }
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Custom Tab

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 0)
    {
        // First Tab is selected do something
    }else if (tabBarController.selectedIndex == 1){
        NSLog(@"Prueba");
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[ControladorCuentaViewController class]]) {
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        if ([[_defaults objectForKey:@"tabselect"] isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarOcultarCuentaTienda" object:nil];
        }else if ([[_defaults objectForKey:@"tabselect"] isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarOcultarCuentaMiCarrito" object:nil];
        }else if ([[_defaults objectForKey:@"tabselect"] isEqualToString:@"4"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarOcultarCuentaNovedades" object:nil];
        }
        return NO;
    }else if ([viewController isKindOfClass:[ControlSedesMasViewController class]]){
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        if ([[_defaults objectForKey:@"tabselect"] isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarOcultarSedesMasTienda" object:nil];
        }else if ([[_defaults objectForKey:@"tabselect"] isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarOcultarSedesMasMiCarrito" object:nil];
        }else if ([[_defaults objectForKey:@"tabselect"] isEqualToString:@"4"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarOcultarSedesMasNovedades" object:nil];
        }
        return NO;
    }
    return YES;
}

#pragma mark - WebServices

#pragma mark - RequestServer Registro Usuario

-(void)requestServerRegistroUsuario{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerRegistroUsuario) object:nil];
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

-(void)envioServerRegistroUsuario{
    NSMutableDictionary * dataSend = [[NSMutableDictionary alloc]init];
    [dataSend setObject:self.personaEmpresa forKey:@"tipo"];
    
    NSString * keyNombre = @"nombre";
    if ([self.personaEmpresa isEqualToString:@"empresa"]) {
        keyNombre = @"empresa";
    }
    [dataSend setObject:self.txtNombres.text forKey:keyNombre];
    
    [dataSend setObject:self.txtCorreo.text forKey:@"email"];
    [dataSend setObject:self.txtContrasena.text forKey:@"password"];
    
    NSString * keyDocumento = @"cedula";
    
    if ([self.personaEmpresa isEqualToString:@"empresa"]) {
        keyDocumento = @"nit";
    }
    
    [dataSend setObject:@"-" forKey:keyDocumento];
    [dataSend setObject:@"-" forKey:@"direccion"];
    [dataSend setObject:@"-" forKey:@"ciudad"];
    [dataSend setObject:@"-" forKey:@"telefono"];
    [dataSend setObject:@"-" forKey:@"celular"];
    
    NSString * keyApellido = @"apellidos";
    if ([self.personaEmpresa isEqualToString:@"empresa"]) {
        keyApellido = @"contacto";
    }
    
    [dataSend setObject:self.txtApellidos.text forKey:keyApellido];
    
    if ([self.personaEmpresa isEqualToString:@"empresa"]) {
        [dataSend setObject:self.txtNombres.text forKey:@"nombre"];
    }
    
    _data = [RequestUrl crearUsuario:dataSend];
    [self performSelectorOnMainThread:@selector(ocultarCargandoRegistroUsuario) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoRegistroUsuario{
    if ([_data count]>0) {
        int status = [[_data objectForKey:@"status"] intValue];
        if (status == 200) {
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:[_data objectForKey:@"uid"] forKey:@"uid"];
            [_defaults setObject:self.personaEmpresa forKey:@"tipoPersona"];
            [_defaults setObject:self.txtContrasena.text forKey:@"password"];
            [self.txtNombres setText:@""];
            [self.txtApellidos setText:@""];
            [self.txtCorreo setText:@""];
            [self.txtConfirmarCorreo setText:@""];
            [self.txtContrasena setText:@""];
            [self.btnAceptarTerminos setImage:[UIImage imageNamed:@"chek.png"] forState:UIControlStateNormal];
            [_defaults setObject:@"SI" forKey:@"login"];
            [self homeView];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:[_data objectForKey:@"message"] forKey:@"Message"];
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
