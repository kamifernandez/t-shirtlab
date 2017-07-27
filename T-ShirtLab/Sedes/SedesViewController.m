//
//  SedesViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 15/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "SedesViewController.h"
#import "RequestUrl.h"

@interface SedesViewController ()

@end

@implementation SedesViewController

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
    [_defaults setObject:@"5" forKey:@"tabselect"];
    /*+++++Harcode+++++++*/
    /*_data = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"T-Shirt Lab / Zona Rosa" forKey:@"titulo"];
            [dataInsert setObject:@"Calle 82 No. 12 - 35" forKey:@"direccion"];
            [dataInsert setObject:@"618 1406 Bogotá - D.C." forKey:@"telefono"];
            [dataInsert setObject:@"Lun - Sab: 11:00 a.m - 8:00 p.m" forKey:@"horario"];
        }else{
            [dataInsert setObject:@"T-Shit Salitre Plaza" forKey:@"titulo"];
            [dataInsert setObject:@"Cra 11 No 92 - 10" forKey:@"direccion"];
            [dataInsert setObject:@"6181416 Bogotá - D.C." forKey:@"telefono"];
            [dataInsert setObject:@"Lun - Sab: 10: 00 a.m - 7:00 p.m" forKey:@"horario"];
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    [self.tblSedes reloadData];
    [[NSBundle mainBundle] loadNibNamed:@"WebViewMapa" owner:self options:nil];
    self.tblSedes.tableFooterView = self.viewWebMapa;
    NSString *urlAddress = @"https://mapsengine.google.com/map/u/1/embed?mid=zFR1Brw5vXqA.kr9clSK0_EP4";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webMapa loadRequest:requestObj];*/
    [self requestServerSedes];
}

#pragma mark - IBActions

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSedes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"CeldaSedes";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CeldaSedes" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    
    NSMutableArray * temp2 = [self.dataSedes objectAtIndex:indexPath.row];
    NSArray * separate = [[temp2 objectAtIndex:1] componentsSeparatedByString:@"<br />"];
        
    [self.lblTitulo setText:[temp2 objectAtIndex:0]];
    
    [self.lblDireccion setText:[separate objectAtIndex:1]];
    
    [self.lblTelefono setText:[separate objectAtIndex:2]];
    [self.lblHorario setText:[separate objectAtIndex:3]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 147;
}

#pragma mark - WebView Delegates

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicator stopAnimating];
}

#pragma mark - WebServices
#pragma mark - Obtener Sedes

-(void)requestServerSedes{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerSedes) object:nil];
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

-(void)envioServerSedes{
    _data = [RequestUrl obtenerSedes];
    [self performSelectorOnMainThread:@selector(ocultarCargandoSedes) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoSedes{
    if ([_data count]>0) {
        _dataSedes = [_data objectForKey:@"tiendas"];
        [self.tblSedes reloadData];
        [[NSBundle mainBundle] loadNibNamed:@"WebViewMapa" owner:self options:nil];
        self.tblSedes.tableFooterView = self.viewWebMapa;
        NSString *urlAddress = @"https://mapsengine.google.com/map/u/1/embed?mid=zFR1Brw5vXqA.kr9clSK0_EP4";
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webMapa loadRequest:requestObj];
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
            
            [_indicadorWait startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicadorWait stopAnimating];
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
