//
//  MisDireccionesViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 2/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "MisDireccionesViewController.h"
#import "EditarMisDireccionesViewController.h"
#import "RequestUrl.h"

@interface MisDireccionesViewController (){
    int tagDelete;
    int tag;
}

@end

@implementation MisDireccionesViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self verificarDirecciones];
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
    
}

-(void)verificarDirecciones{
    [self requestServerMisDirecciones];
}

#pragma mark IBActions

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewEdit:(id)sender{
    tag = (int)[sender tag];
    [self requestServerUnaDireccion];
}

-(void)delete:(id)sender{
    tagDelete = (int)[sender tag];
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Eliminar Dirección" forKey:@"Title"];
    [msgDict setValue:@"¿Esta seguro que desea eliminar esta dirección?" forKey:@"Message"];
    [msgDict setValue:@"Si" forKey:@"Aceptar"];
    [msgDict setValue:@"No" forKey:@"Cancel"];
    [msgDict setValue:@"101" forKey:@"Tag"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
}

-(IBAction)btnContinuar:(id)btnContinuar{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditarMisDireccionesViewController *editarMisDireccionesViewController = [story instantiateViewControllerWithIdentifier:@"EditarMisDireccionesViewController"];
    //vc.data = [self.data objectAtIndex:tag];
    [self.navigationController pushViewController:editarMisDireccionesViewController animated:YES];
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
    static NSString *CellIdentifier = @"CellMisDirecciones";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CellMisDirecciones" owner:self options:nil];
        cell = _cellDirecciones;
        self.cellDirecciones = nil;
    }
    
    [self.lblName setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"nombre"]];
    
    [self.txtDireccion setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"direccion"]];
    
    [self.txtDepartment setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"ciudad"]];
    
    [self.txtCity setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"ciudad"]];
    
    [self.btnEditar addTarget:self action:@selector(viewEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEditar setTag:indexPath.row];

    [self.btnEliminar addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEliminar setTag:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 265;
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
                                            [self.data removeObjectAtIndex:tagDelete];
                                            if ([self.data count]>0) {
                                                [self.tblDirecciones reloadData];
                                            }else{
                                                [self.tblDirecciones setHidden:TRUE];
                                                [self.btnContinuar setHidden:FALSE];
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
            
            [_indicadorWait startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicadorWait stopAnimating];
        }
    }
}

#pragma mark - WebServices
#pragma mark - RequestServer Mis Direcciones

-(void)requestServerMisDirecciones{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerMisDirecciones) object:nil];
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

-(void)envioServerMisDirecciones{
    //NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    //NSString * uid = [_defaults objectForKey:@"uid"];
    NSString * uid = @"760";
    
    _data = [RequestUrl obtenerDirecciones:uid];
    [self performSelectorOnMainThread:@selector(ocultarCargandoMisDirecciones) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoMisDirecciones{
    if ([_data count]>0) {
        if ([_data count] > 0) {
            [self.tblDirecciones reloadData];
            [self.tblDirecciones setHidden:FALSE];
            [self.btnContinuar setHidden:TRUE];
            [[NSBundle mainBundle] loadNibNamed:@"FooterMisDireccionesTableView" owner:self options:nil];
            [self.btnCrearDireccion.layer setCornerRadius:5];
            self.tblDirecciones.tableFooterView = self.viewFootter;
        }
        [self.tblDirecciones reloadData];
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

#pragma mark - RequestServer Una Direccion

-(void)requestServerUnaDireccion{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerUnaDireccion) object:nil];
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

-(void)envioServerUnaDireccion{
    //NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    //NSString * uid = [_defaults objectForKey:@"uid"];
    NSString * idDireccion = [[self.data objectAtIndex:tag] objectForKey:@"id"];
    
    _dataUnaDireccion = [RequestUrl obtenerUnaDireccion:idDireccion];
    [self performSelectorOnMainThread:@selector(ocultarCargandoUnaDireccion) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoUnaDireccion{
    if ([_dataUnaDireccion count]>0) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EditarMisDireccionesViewController *editarMisDireccionesViewController = [story instantiateViewControllerWithIdentifier:@"EditarMisDireccionesViewController"];
        editarMisDireccionesViewController.data = _dataUnaDireccion;
        [self.navigationController pushViewController:editarMisDireccionesViewController animated:YES];
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

@end
