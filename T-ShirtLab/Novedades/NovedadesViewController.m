//
//  NovedadesViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 15/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "NovedadesViewController.h"
#import "DetalleNovedadesViewController.h"

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
#import "RequestUrl.h"

@interface NovedadesViewController (){
    BOOL mostrarOcultarCuenta;
    BOOL mostrarOcultarSedesMas;
    int tagNovedad;
}

@end

@implementation NovedadesViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"4" forKey:@"tabselect"];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarOcultarCuenta)
                                                 name:@"mostrarOcultarCuentaNovedades"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarOcultarSedesMas)
                                                 name:@"mostrarOcultarSedesMasNovedades"
                                               object:nil];
    
    mostrarOcultarSedesMas = NO;
    mostrarOcultarCuenta = NO;
    
    /*+++++Harcode+++++++*/
    /*_data = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"http://t-shirtlab.com/images/novedades/celular.png" forKey:@"imagen"];
            [dataInsert setObject:@"LLEGARON LOS NUEVOS FORROS PARA IPHONE 6! AHORA PODRAS TENER TU JUGUETE FAVORITO CON UN TOQUE PERSONAL... ¿Estás buscando la funda perfecta para tu iPhone 5 o iPhone 4/4s? ¡No busques más!..." forKey:@"titulo"];
            [dataInsert setObject:@"LLEGARON LOS NUEVOS FORROS PARA IPHONE 6! AHORA PODRAS TENER TU JUGUETE FAVORITO CON UN TOQUE PERSONAL... ¿Estás buscando la funda perfecta para tu iPhone 5 o iPhone 4/4s? ¡No busques más!..." forKey:@"descripcion"];
            [dataInsert setObject:@"http://t-shirtlab.com/images/novedades/sorpresa2.png" forKey:@"imagendescription"];
        }else{
            [dataInsert setObject:@"http://t-shirtlab.com/images/novedades/sorpresa.png" forKey:@"imagen"];
            [dataInsert setObject:@"SORPRESAS PARA HALLOWEEN!" forKey:@"titulo"];
            [dataInsert setObject:@"SORPRESAS PARA HALLOWEEN! EN T-SHIRT LAB ENCUENTRAS EL DISFRAZ QUE SIEMPRE HAS SOÑADO TENER... No es necesario gastar un ojo de la cara en algún disfraz de lujo. Tu puedes usar uno... SORPRESAS PARA HALLOWEEN! EN T-SHIRT LAB ENCUENTRAS EL DISFRAZ QUE SIEMPRE HAS SOÑADO TENER... No es necesario gastar un ojo de la cara en algún disfraz de lujo. Tu puedes usar uno... SORPRESAS PARA HALLOWEEN! EN T-SHIRT LAB ENCUENTRAS EL DISFRAZ QUE SIEMPRE HAS SOÑADO TENER... No es necesario gastar un ojo de la cara en algún disfraz de lujo. Tu puedes usar uno..." forKey:@"descripcion"];
            [dataInsert setObject:@"http://t-shirtlab.com/images/novedades/sorpresa2.png" forKey:@"imagendescription"];
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }*/
    [self requestServerNovedades];
}

#pragma mark - IBActions

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDetail:(id)sender{
    tagNovedad = (int)[sender tag];
    [self requestServerDetalleNovedades];
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

#pragma mark Custom Delegate


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
    static NSString *CellIdentifier = @"CeldaNovedades";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CeldaNovedades" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    
    NSString * urlEnvio = [[self.data objectAtIndex:indexPath.row] objectForKey: @"imagen"];
    if ([urlEnvio isEqualToString:@""]) {
        [self.indicatorCell stopAnimating];
    }else{
        NSURL *imageURL = [NSURL URLWithString:urlEnvio];
        NSString *key = [[[self.data objectAtIndex:indexPath.row] objectForKey: @"imagen"] MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            [self.indicatorCell stopAnimating];
            UIImage *image = [UIImage imageWithData:data];
            self.imgProduct.image = image;
        } else {
            //imagen.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.indicatorCell stopAnimating];
                    self.imgProduct.image = image;
                });
            });
        }
    }
    
    self.imgProduct.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.imgProduct.layer setMasksToBounds:YES];
    
    [self.lblTittle setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"titulo"]];
    
    [self.lblDescription setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"texto"]];
    
    [self.btnSeeMore addTarget:self action:@selector(viewDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSeeMore setTag:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 305;
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
#pragma mark - Obtener Novedades

-(void)requestServerNovedades{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerNovedades) object:nil];
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

-(void)envioServerNovedades{
    _data = [RequestUrl obtenerNovedades];
    [self performSelectorOnMainThread:@selector(ocultarCargandoNovedades) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoNovedades{
    if ([_data count]>0) {
        [self.tblNovedades reloadData];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene información para mostrar" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - Obtener Detalle Novedades

-(void)requestServerDetalleNovedades{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerDetalleNovedades) object:nil];
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

-(void)envioServerDetalleNovedades{
    NSString * idNovedad = [NSString stringWithFormat:@"%@",[[_data objectAtIndex:tagNovedad] objectForKey:@"id"]];
    _dataNovedades = [RequestUrl obtenerDetalleNovedade:idNovedad];
    [self performSelectorOnMainThread:@selector(ocultarCargandoDetalleNovedades) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoDetalleNovedades{
    if ([_dataNovedades count]>0) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetalleNovedadesViewController *vc = [story instantiateViewControllerWithIdentifier:@"DetalleNovedadesViewController"];
        vc.data = _dataNovedades;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene información para mostrar" forKey:@"Message"];
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
