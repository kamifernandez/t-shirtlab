//
//  ProductosViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 6/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "ProductosViewController.h"
#import "PresentacionViewController.h"
#import "SedesViewController.h"
#import "NovedadesViewController.h"
#import "QuienesSomosViewController.h"
#import "ContactenosViewController.h"
#import "PruebaViewController.h"
#import "RegistroViewController.h"
#import "InicioViewController.h"

#import "MiCuentaViewController.h"
#import "MisPedidosViewController.h"
#import "MisDireccionesViewController.h"

#define COMMENT_LABEL_MIN_HEIGHT 112

@import FirebaseCrash;

@interface ProductosViewController (){
    NSInteger selectedIndex;
    BOOL devolver;
    NSInteger countArray;
    BOOL open;
    int tagCategoria;
    BOOL isSearchActive;
    BOOL mostrarOcultarCuenta;
    BOOL mostrarOcultarSedesMas;
    int accionContinuar;
}

@end


@implementation ProductosViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"0" forKey:@"tabselect"];
    if (mostrarOcultarCuenta) {
        [self.vistaCuenta setHidden:TRUE];
        self.vistaCuenta = nil;
        mostrarOcultarCuenta = NO;
    }
    
    if (mostrarOcultarSedesMas) {
        [self.vistaSedesMas setHidden:TRUE];
        self.vistaSedesMas = nil;
        mostrarOcultarCuenta = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
    [self performSelector:@selector(configurerLayouts) withObject:nil afterDelay:0.001];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(desaparecerContenedor:)
                                                 name:@"DesaparecerContenedor"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saberStep:)
                                                 name:@"SaberStepNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myNotificationMethod:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarOcultarCuenta)
                                                 name:@"mostrarOcultarCuentaTienda"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarOcultarSedesMas)
                                                 name:@"mostrarOcultarSedesMasTienda"
                                               object:nil];
    
    accionContinuar = 0;
    mostrarOcultarCuenta = NO;
    mostrarOcultarSedesMas = NO;
    isSearchActive = NO;

    selectedIndex = -1;
    open = NO;
    tagCategoria = 0;
    /*HardCode*/
    
    _data = [[NSMutableArray alloc] init];
    for (int i = 0; i<6; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        if (i % 2 == 0) {
            [dataInsert setObject:@"prueba.png" forKey:@"image"];
            NSMutableArray * productos = [[NSMutableArray alloc] init];
            for (int i = 0; i<5; i++) {
                NSMutableDictionary * dataInsertLogo = [[NSMutableDictionary alloc] init];
                [dataInsertLogo setObject:@"camisetas-active.png" forKey:@"logo"];
                if (i % 2 == 0) {
                    NSMutableArray * subProductos = [[NSMutableArray alloc] init];
                    for (int j = 0; j<3; j++) {
                        NSMutableDictionary * dataInsertSubLogo = [[NSMutableDictionary alloc] init];
                        [dataInsertSubLogo setObject:@"gorras.png" forKey:@"sublogo"];
                        [subProductos addObject:dataInsertSubLogo];
                    }
                    [dataInsertLogo setObject:subProductos forKey:@"subproductos"];
                }else{
                    {
                        NSMutableArray * subProductos = [[NSMutableArray alloc] init];
                        for (int j = 0; j<8; j++) {
                            NSMutableDictionary * dataInsertSubLogo = [[NSMutableDictionary alloc] init];
                            [dataInsertSubLogo setObject:@"prendas.png" forKey:@"sublogo"];
                            [subProductos addObject:dataInsertSubLogo];
                        }
                        [dataInsertLogo setObject:subProductos forKey:@"subproductos"];
                    }
                }
                [productos addObject:dataInsertLogo];
            }
            [dataInsert setObject:productos forKey:@"productos"];
            productos = nil;
        }else{
            [dataInsert setObject:@"Prueba2.png" forKey:@"image"];
            NSMutableArray * productos = [[NSMutableArray alloc] init];
            for (int i = 0; i<10; i++) {
                NSMutableDictionary * dataInsertLogo = [[NSMutableDictionary alloc] init];
                [dataInsertLogo setObject:@"gorras.png" forKey:@"logo"];
                [productos addObject:dataInsertLogo];
            }
            [dataInsert setObject:productos forKey:@"productos"];
            productos = nil;
            
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    [self.tblProducts reloadData];
}

-(void)configurerLayouts{
    self.widthBackButtonConstraint.constant = 0;
    [self.view layoutIfNeeded];
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

#pragma mark - IBAciotns

-(void)scrollCategoria:(id)sender{
    tagCategoria = (int)[sender tag];
    NSMutableArray * dataProductosTemp = [[_data objectAtIndex:selectedIndex] objectForKey:@"productos"];
    NSMutableArray * dataSubTemp = [[dataProductosTemp objectAtIndex:tagCategoria] objectForKey:@"subproductos"];
    if (dataSubTemp != nil) {
        open = YES;
        UITableViewCell *selectedCell=[self.tblProducts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        float origenTagTemp = (float)selectedIndex/10;
        int origenIndex = truncf(origenTagTemp);
        int origenTag = round((origenTagTemp - (float)origenIndex)*10);
        int tagReal = origenTag*10;
        UIView * viewBackCell = (UIView *)[selectedCell viewWithTag:tagReal+4];
        /*[UIView animateWithDuration:0.5 animations:^{
            [viewBackCell setFrame:CGRectMake(0 - self.tblProducts.frame.size.width, viewBackCell.frame.origin.y, viewBackCell.frame.size.width, viewBackCell.frame.size.height)];
        }completion:^(BOOL finished){
            
        }];*/
        
        UISwipeGestureRecognizer *swipeRigth = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        [swipeRigth setDirection:(UISwipeGestureRecognizerDirectionRight )];
        [viewBackCell addGestureRecognizer:swipeRigth];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.tblProducts reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self detalleProduct:self];
    }
    FIRCrashNSLog(@"Scroll SubCategory Cell ProductosViewController %d",open);
}

-(void)detalleProduct:(id)sender{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"2" forKey:@"pantalla"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadSearchNotification" object:userInfo];
    accionContinuar = 1;
    [self.conteinerView setHidden:FALSE];
    self.widthBackButtonConstraint.constant = 28;
    [self.view layoutIfNeeded];
}

-(void)backSubCategoria:(id)sender{
    open = FALSE;
    float origenTagTemp = (float)selectedIndex/10;
    int origenIndex = truncf(origenTagTemp);
    int origenTag = round((origenTagTemp - (float)origenIndex)*10);
    int tagReal = origenTag*10;
    UITableViewCell *selectedCell=[self.tblProducts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    UIView * viewBackCell = (UIView *)[selectedCell viewWithTag:tagReal+4];
    [UIView animateWithDuration:0.5 animations:^{
        [viewBackCell setFrame:CGRectMake(0, viewBackCell.frame.origin.y, viewBackCell.frame.size.width, viewBackCell.frame.size.height)];
    }completion:^(BOOL finished){
        
    }];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tblProducts reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    FIRCrashNSLog(@"Back SubCategoria ProductosViewController");
}

-(IBAction)backButton:(id)sender{
    if (accionContinuar == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BackNotification" object:nil];
        [self performSelector:@selector(hiddenConteninerView) withObject:nil afterDelay:0.2];
        if (isSearchActive) {
            self.widthBackButtonConstraint.constant = 0;
            
            self.heigthViewCarConstraint.constant = 30;
            self.heigthViewStoreConstraint.constant = 30;
            [self.view layoutIfNeeded];
            isSearchActive = NO;
        }else{
            self.widthBackButtonConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }
    }else if (accionContinuar == 2){
        accionContinuar = 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BackNotificationDetalleProducto" object:nil];
    }
}

-(void)hiddenConteninerView{
    [self.conteinerView setHidden:TRUE];
}

-(IBAction)segmentedButtons:(id)sender{
    int tag = (int)[sender tag];
    if (tag == 1) {
        [self.tabBarController setSelectedIndex:0];
    }else{
        [self.tabBarController setSelectedIndex:1];
    }
}

-(IBAction)searchResponderButton:(id)sender{
    [[NSBundle mainBundle] loadNibNamed:@"ViewSearchStore" owner:self options:nil];
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    [letterTapRecognizer setNumberOfTapsRequired:1];
    [self.search setFrame:CGRectMake(self.search.frame.origin.x, self.search.frame.origin.y, self.view.bounds.size.width, self.search.frame.size.height)];
    [self.viewContentSearch setFrame:self.view.frame];
    [self.viewContentSearch addGestureRecognizer:letterTapRecognizer];
    [self.view addSubview:self.viewSearch];
    [self.search becomeFirstResponder];
    
    for (UIView *view in self.search.subviews)
    {
        for (id subview in view.subviews)
        {
            if ( [subview isKindOfClass:[UIButton class]] )
            {
                [subview setEnabled:YES];
                UIButton *cancelButton = (UIButton*)subview;
                [cancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
                
                
                NSLog(@"enableCancelButton");
                return;
            }
        }
    }
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
        self.hidesBottomBarWhenPushed = NO;
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
    if (tableView.tag == 1) {
        return [_data count];
    }
    return [_dataSearch count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView.tag == 1) {
        static NSString *CellIdentifier = @"CeldaProductos";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"CeldaProductos" owner:self options:nil];
            cell = _celdaTabla;
            self.celdaTabla = nil;
        }
        
        
        NSString * imageBannerPut = [[self.data objectAtIndex:indexPath.row] objectForKey:@"image"];
        [self.imgBanner setImage:[UIImage imageNamed:imageBannerPut]];
        [self.imgBanner.layer setMasksToBounds:YES];
        UIView * viewBackCell = (UIView *)[cell viewWithTag:3];
        if(selectedIndex == indexPath.row)
        {
            if (devolver) {
                viewBackCell.alpha = 0;
                open = NO;
                tagCategoria = 0;
            }else{
                [UIView transitionWithView:viewBackCell
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    viewBackCell.alpha = 1.0;
                                }
                                completion:^(BOOL finished){
                                    
                                }];
                
                
                //int y = 44;
                int anchoCelda = self.view.frame.size.width;
                CGRect bounds = [[UIScreen mainScreen] bounds];
                if (bounds.size.width == 414) {
                    anchoCelda = 414;
                }else if (bounds.size.width == 375){
                    anchoCelda = 375;
                }
                
                int index = (int)indexPath.row*10;
                int countLogos = (int)[[[_data objectAtIndex:indexPath.row] objectForKey:@"productos"] count];
                countArray = countLogos;
                UIView * vistaLogos = [[UIView alloc] init];
                [vistaLogos setFrame:CGRectMake(0, 0, bounds.size.width * 2, 69)];
                [vistaLogos setBackgroundColor:[UIColor clearColor]];
                float heigthVistaLogos = countLogos/3;
                int countContents = 0;
                countContents = heigthVistaLogos+1;
                [vistaLogos setFrame:CGRectMake(0, 0, bounds.size.width * 2, 69*countContents)];
                int yContentLogos = 0;
                
                UIView * vistaContentLogos = [[UIView alloc] init];
                [vistaContentLogos setBackgroundColor:[UIColor clearColor]];
                [vistaContentLogos setAlpha:0.8];
                [vistaContentLogos setFrame:CGRectMake((self.tblProducts.frame.size.width/2) - 219/2, yContentLogos, 219, 69*countContents)];
                NSMutableArray * logosGet = [[_data objectAtIndex:indexPath.row] objectForKey:@"productos"];
                int xLogo = 20;
                int yLogo = 0;
                for (int n = 0; n<countLogos; n++) {
                    int indexLogo = n;
                    NSString * image = [[logosGet objectAtIndex:n] objectForKey:@"logo"];
                    UIButton * imagenLogo = [UIButton buttonWithType:UIButtonTypeCustom];
                    [imagenLogo setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
                    [imagenLogo setFrame:CGRectMake(xLogo, yLogo, 53, 69)];
                    [imagenLogo setTag:indexLogo];
                    [imagenLogo addTarget:self action:@selector(scrollCategoria:) forControlEvents:UIControlEventTouchUpInside];
                    xLogo += 53+10;
                    int multiplo = n+1;
                    if (multiplo % 3 == 0) {
                        xLogo = 20;
                        yLogo += 69;
                    }
                    [vistaContentLogos addSubview:imagenLogo];
                }
                
                [vistaLogos addSubview:vistaContentLogos];
                yContentLogos += 69;
                [viewBackCell setBackgroundColor:[UIColor clearColor]];
                [viewBackCell addSubview:vistaLogos];
                [viewBackCell setFrame:CGRectMake(0, 112, anchoCelda*2, 69*countContents)];
                
                /*segunda vista*/
                
                NSMutableArray * dataProductosTemp = [[_data objectAtIndex:indexPath.row] objectForKey:@"productos"];
                NSMutableArray * dataSubTemp = [[dataProductosTemp objectAtIndex:tagCategoria] objectForKey:@"subproductos"];
                if (dataSubTemp != nil) {
                    
                    UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btnBack setFrame:CGRectMake(anchoCelda + 15, viewBackCell.bounds.size.height/2 - btnBack.frame.size.height/2, 35, 50)];
                    [btnBack setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:39.0/255.0 blue:63.0/255.0 alpha:1]];
                    [btnBack setImage:[UIImage imageNamed:@"button-scroll.png"] forState:UIControlStateNormal];
                    [btnBack addTarget:self action:@selector(backSubCategoria:) forControlEvents:UIControlEventTouchUpInside];
                    
                    int countSubLogos = (int)[dataSubTemp count];
                    countArray = countSubLogos;
                    UIView * vistaSubLogos = [[UIView alloc] init];
                    [vistaSubLogos setFrame:CGRectMake(0, 0, bounds.size.width * 2, 69)];
                    [vistaSubLogos setBackgroundColor:[UIColor clearColor]];
                    float heigthVistaSubLogos = countLogos/3;
                    int countSubContents = 0;
                    countSubContents = heigthVistaSubLogos+1;
                    [vistaSubLogos setFrame:CGRectMake(anchoCelda, 0, bounds.size.width * 2, 69*countSubContents)];
                    int ySubContentLogos = 0;
                    
                    UIView * vistaContentSubLogos = [[UIView alloc] init];
                    [vistaContentSubLogos setBackgroundColor:[UIColor clearColor]];
                    [vistaContentSubLogos setAlpha:0.8];
                    [vistaContentSubLogos setFrame:CGRectMake((self.tblProducts.frame.size.width/2) - 219/2, ySubContentLogos, 219, 69*countSubContents)];
                    NSMutableArray * subLogosGet = dataSubTemp;
                    int xSubLogo = 20;
                    int ySubLogo = 0;
                    for (int n = 0; n<countSubLogos; n++) {
                        NSString * image = [[subLogosGet objectAtIndex:n] objectForKey:@"sublogo"];
                        UIButton * imagenLogo = [UIButton buttonWithType:UIButtonTypeCustom];
                        [imagenLogo setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
                        [imagenLogo setFrame:CGRectMake(xSubLogo, ySubLogo, 53, 69)];
                        [imagenLogo addTarget:self action:@selector(detalleProduct:) forControlEvents:UIControlEventTouchUpInside];
                        xSubLogo += 53+10;
                        int multiplo = n+1;
                        if (multiplo % 3 == 0) {
                            xSubLogo = 20;
                            ySubLogo += 69;
                        }
                        [vistaContentSubLogos addSubview:imagenLogo];
                    }
                    
                    [vistaSubLogos addSubview:vistaContentSubLogos];
                    ySubContentLogos += 69;
                    if (open) {
                        int countLogos = (int)[subLogosGet count];
                        //int countLogos = 5;
                        float origenTagTemp = (float)countLogos/10;
                        int origenIndex = truncf(origenTagTemp);
                        int origenTag = round((origenTagTemp - (float)origenIndex)*10);
                        float heigthVistaLogos = countLogos/3;
                        int countContents = 0;
                        if (origenIndex == 0 && origenTag == 3) {
                            countContents = heigthVistaLogos;
                        }else{
                            countContents = heigthVistaLogos+1;
                        }
                        [viewBackCell setFrame:CGRectMake(0, 112, anchoCelda*2, 69*countContents)];
                        [btnBack setFrame:CGRectMake(anchoCelda + 15, viewBackCell.bounds.size.height/2 - btnBack.frame.size.height/2, 35, 50)];
                    }
                    [viewBackCell addSubview:vistaSubLogos];
                    [viewBackCell addSubview:btnBack];
                }
                
                [viewBackCell setTag:index+4];
                
                if (open) {
                    [UIView animateWithDuration:0.5 animations:^{
                        [viewBackCell setFrame:CGRectMake(0 - self.tblProducts.frame.size.width, viewBackCell.frame.origin.y, viewBackCell.frame.size.width, viewBackCell.frame.size.height)];
                    }completion:^(BOOL finished){
                        
                    }];
                    UISwipeGestureRecognizer *swipeRigth = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
                    [swipeRigth setDirection:(UISwipeGestureRecognizerDirectionRight )];
                    swipeRigth.delegate = self;
                    [viewBackCell addGestureRecognizer:swipeRigth];
                }
                FIRCrashNSLog(@"Create Cell ProductosViewController %d",open);
            }
        }
        else {
            viewBackCell.alpha = 0;
        }
    }else{
        static NSString *simpleTableIdentifier = @"SimpleTableCell";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = [_dataSearch objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        if(selectedIndex == indexPath.row)
        {
            selectedIndex = -1;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            open = FALSE;
            return;
        }else{
            /*NSMutableArray * temporal = [[vectorPrimerosAuxilios objectAtIndex:indexPath.row] objectForKey:@"subCategorias"];
             countArray = [temporal count];
             //countArray = 4;*/
        }
        
        //First we check if a cell is already expanded.
        //If it is we want to minimize make sure it is reloaded to minimize it back
        if(selectedIndex >= 0)
        {
            
            //UITableViewCell *cell = [self.tblSchedule cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
            
            //selectedIndex = indexPath.row;
            tagCategoria = 0;
            devolver = YES;
            open = FALSE;
            NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        //Finally set the selected index to the new selection and reload it to expand
        selectedIndex = indexPath.row;
        
        devolver = NO;
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //UITableViewCell *cell = [self.tblSchedule cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    }else{
        if (accionContinuar == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackNotificationRoot" object:nil];
            [self.conteinerView setHidden:TRUE];
        }else if (accionContinuar == 2){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackNotificationRootDetalle" object:nil];
            [self.conteinerView setHidden:TRUE];
        }
        self.widthBackButtonConstraint.constant = 28;
        
        self.heigthViewCarConstraint.constant = 0;
        self.heigthViewStoreConstraint.constant = 0;
        [self.view layoutIfNeeded];
        [self highlightLetter:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"1" forKey:@"pantalla"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadSearchNotification" object:userInfo];
        accionContinuar = 1;
        [self.conteinerView setHidden:FALSE];
        isSearchActive = YES;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ExpandTable delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        //If this is the selected index we need to return the height of the cell
        //in relation to the label height otherwise we just return the minimum label height with padding
        if(selectedIndex == indexPath.row)
        {
            return [self getLabelHeightForIndex:indexPath.row] + 135;
        }
        else {
            return COMMENT_LABEL_MIN_HEIGHT;
        }
    }
    return 45;
}

-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    
    if (countArray == 0) {
        return 0;
    }else{
        if (open) {
            NSMutableArray * dataProductosTemp = [[_data objectAtIndex:index] objectForKey:@"productos"];
            NSMutableArray * dataSubTemp = [[dataProductosTemp objectAtIndex:tagCategoria] objectForKey:@"subproductos"];
            int countLogos = (int)[dataSubTemp count];
            //int countLogos = 5;
            float origenTagTemp = (float)countLogos/10;
            int origenIndex = truncf(origenTagTemp);
            int origenTag = round((origenTagTemp - (float)origenIndex)*10);
            float heigthVistaLogos = countLogos/3;
            int countContents = 0;
            if (origenIndex == 0 && origenTag == 3) {
                countContents = heigthVistaLogos;
            }else{
                countContents = heigthVistaLogos+1;
            }
            NSInteger total = (countContents*69)-20;
            FIRCrashNSLog(@"Heigth Cell ProductosViewController %d",open);
            return total;
        }else{
            int countLogos = (int)[[[_data objectAtIndex:index] objectForKey:@"productos"] count];
            //int countLogos = 3;
            float origenTagTemp = (float)countLogos/10;
            int origenIndex = truncf(origenTagTemp);
            int origenTag = round((origenTagTemp - (float)origenIndex)*10);
            float heigthVistaLogos = countLogos/3;
            int countContents = 0;
            if (origenIndex == 0 && origenTag == 3) {
                countContents = heigthVistaLogos;
            }else{
                countContents = heigthVistaLogos+1;
            }
            NSInteger total = (countContents*69)-20;
            FIRCrashNSLog(@"Heigth Cell ProductosViewController %d",open);
            return total;
        }
    }
}

#pragma mark - UISwipeGestureRecognizer

- (void) didSwipe:(UISwipeGestureRecognizer *)recognizer{
    if([recognizer direction] == UISwipeGestureRecognizerDirectionLeft){
    
    }else{
        //Swipe from left to right
        //Do your functions here
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    open = FALSE;
    float origenTagTemp = (float)selectedIndex/10;
    int origenIndex = truncf(origenTagTemp);
    int origenTag = round((origenTagTemp - (float)origenIndex)*10);
    int tagReal = origenTag*10;
    UITableViewCell *selectedCell=[self.tblProducts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    UIView * viewBackCell = (UIView *)[selectedCell viewWithTag:tagReal+4];
    [UIView animateWithDuration:0.5 animations:^{
        [viewBackCell setFrame:CGRectMake(0, viewBackCell.frame.origin.y, viewBackCell.frame.size.width, viewBackCell.frame.size.height)];
    }completion:^(BOOL finished){
        
    }];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tblProducts reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    FIRCrashNSLog(@"Gesture Cell ProductosViewController %d",open);
    return YES;
}

#pragma mark - Gesture Tap

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    [self.viewSearch removeFromSuperview];
    self.viewSearch = nil;
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

#pragma mark - SearchController Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel Button");
    [self highlightLetter:nil];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"List Button");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSLog(@"List Button");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length]>0) {
        NSLog(@"%@",searchText);
        if (!_dataSearch) {
            _dataSearch = [[NSMutableArray alloc] init];
            _dataSearch = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
        }
        [self.tblSearch setHidden:FALSE];
        [self.viewSearch bringSubviewToFront:self.tblSearch];
        [self.tblSearch reloadData];
    }else{
        [self.tblSearch setHidden:true];
    }
}

#pragma mark - KeyBoard Delegate

- (void)myNotificationMethod:(NSNotification*)notification
{
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    //[self.tblSearch setFrame:CGRectMake(self.tblSearch.frame.origin.x, self.tblSearch.frame.origin.y, self.tblSearch.frame.size.width, (self.tblSearch.frame.origin.y + self.tblSearch.frame.size.height) - keyboardRect.size.height)];
}

#pragma mark Custom Delegate

- (void)saberStep:(NSNotification *)step{
    NSDictionary * data = step.object;
    accionContinuar = [[data objectForKey:@"step"] intValue];
    if (accionContinuar == 3) {
        //[self.btnContinuar setHidden:TRUE];
        self.heigthViewCarConstraint.constant = 30;
        self.heigthViewStoreConstraint.constant = 30;
        [self.view layoutIfNeeded];
    }
}

-(void)desaparecerContenedor:(NSNotification *)step{
    [self.conteinerView setHidden:TRUE];
}

@end
