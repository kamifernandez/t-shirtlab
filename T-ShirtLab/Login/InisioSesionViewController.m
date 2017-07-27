//
//  InisioSesionViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 14/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "InisioSesionViewController.h"
#import "RegistroViewController.h"
#import "utilidades.h"
#import "ProductosViewController.h"
#import "ControladorCuentaViewController.h"
#import "ControlSedesMasViewController.h"
#import "MiCarritoViewController.h"
#import "RequestUrl.h"

@interface InisioSesionViewController ()

@end

@implementation InisioSesionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(configurerLayout) withObject:nil afterDelay:0.001];
    
    UIColor *color = [UIColor darkGrayColor];
    self.txtCorreo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Correo Electrónico" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.txtContrasena.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerLayout{
    if (([[UIScreen mainScreen] bounds].size.height == 568)) {
        [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ((constraint.firstItem == self.viewContentCorreo) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
                constraint.constant = 180;
            }
        }];
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ((constraint.firstItem == self.viewContentCorreo) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
                constraint.constant = 200;
            }
        }];
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ((constraint.firstItem == self.viewContentCorreo) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
                constraint.constant = 220;
            }
        }];
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

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)login:(id)sender{
    if ([utilidades verifyEmpty:self.view]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vació" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if([utilidades validateEmailWithString:self.txtCorreo.text]){
            [self requestServerLogin];
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

-(IBAction)forgotPassword:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://t-shirtlab.com/index.php/component/users/?view=reset"]];
}

-(IBAction)registeruser:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistroViewController *vc = [story instantiateViewControllerWithIdentifier:@"RegistroViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.view.frame.origin.y == 0) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             [self.view setFrame:CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height)];
                             
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtCorreo isEqual:textField]) {
        [_txtContrasena becomeFirstResponder];
    }else if ([_txtContrasena isEqual:textField]){
        [self.view endEditing:TRUE];
        if (self.view.frame.origin.y != 0) {
            [UIView animateWithDuration:0.5f
                             animations:^{
                                [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                                 
                             }
             ];
        }
    }
    return true;
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
                                        //Handle your yes please button action here
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

-(void)requestServerLogin{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerLogin) object:nil];
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

-(void)envioServerLogin{
    NSMutableDictionary * dataSend = [[NSMutableDictionary alloc]init];
    [dataSend setObject:self.txtCorreo.text forKey:@"email"];
    [dataSend setObject:self.txtContrasena.text forKey:@"password"];
    
    _data = [RequestUrl login:dataSend];
    [self performSelectorOnMainThread:@selector(ocultarCargandoLogin) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoLogin{
    if ([_data count]>0) {
        int status = [[_data objectForKey:@"status"] intValue];
        if (status == 1) {
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            //[_defaults setObject:[_data objectForKey:@"uid"] forKey:@"uid"];
            [_defaults setObject:@"760" forKey:@"uid"];
            [_defaults setObject:self.txtContrasena.text forKey:@"password"];
            [_defaults setObject:@"persona" forKey:@"tipoPersona"];
            [self.txtCorreo setText:@""];
            [self.txtContrasena setText:@""];
            [_defaults setObject:@"SI" forKey:@"login"];
            [self homeView];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor verifique su usuario o contraseña" forKey:@"Message"];
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
