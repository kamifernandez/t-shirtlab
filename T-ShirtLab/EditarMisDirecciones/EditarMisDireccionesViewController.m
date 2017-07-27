//
//  EditarMisDireccionesViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 2/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "EditarMisDireccionesViewController.h"
#import "RequestUrl.h"

@interface EditarMisDireccionesViewController (){
    int selectedPicker;
    BOOL editar;
}

@end

@implementation EditarMisDireccionesViewController

-(void)viewWillAppear:(BOOL)animated
{
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
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
    
    /*+++++Harcode+++++++*/
    /*_dataPicker = [[NSMutableArray alloc] init];
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
    }*/
    
    editar = NO;
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Siguiente"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(nextClick:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexible,doneButton, nil]];
    self.txtCelular.inputAccessoryView = keyboardDoneButtonView;
    
    self.txtFijo.inputAccessoryView = keyboardDoneButtonView;
    
    if ([self.data count]>0) {
        editar = YES;
        [self.txtDepartamento setText:[_data objectForKey:@"ciudad"][@"departamento"]];
        [self.txtCiudad setText:[_data objectForKey:@"ciudad"][@"ciudad"]];
        [self.txtNombre setText:[_data objectForKey:@"nombre"]];
        [self.txtDireccion setText:[_data objectForKey:@"direccion"]];
        [self.txtCorreo setText:[_data objectForKey:@"correo"]];
        [self.txtCelular setText:[_data objectForKey:@"telefono"]];
        [self.txtFijo setText:[_data objectForKey:@"telefono"]];
    }
}

#pragma mark IBActions

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextClick:(id)sender
{
    if ([_txtSeleccionado isEqual:self.txtCelular]) {
        [self.txtFijo becomeFirstResponder];
    }else if ([_txtSeleccionado isEqual:self.txtFijo]){
        [self.view endEditing:TRUE];
    }
}

-(IBAction)btnOk:(id)sender{
    if ([self.txtDepartamento.text isEqualToString:@""] || [self.txtCiudad.text isEqualToString:@""] || [self.txtDireccion.text isEqualToString:@""] || [self.txtNombre.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor llena la información necesaria de los campos para poder realizar esta acción" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        if (editar) {
            [msgDict setValue:@"Información Actualizada con éxtio" forKey:@"Message"];
        }else{
            [msgDict setValue:@"Información creada con éxtio" forKey:@"Message"];
        }
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(IBAction)seePickerView:(id)sender{
    int tag = (int)[sender tag];
    selectedPicker = tag;
    [self.view endEditing:true];
    
    [[NSBundle mainBundle] loadNibNamed:@"PickerView" owner:self options:nil];
    [self.vistaPicker setAlpha:0.0];
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    [letterTapRecognizer setNumberOfTapsRequired:1];
    [self.vistaPicker addGestureRecognizer:letterTapRecognizer];
    [self.view addSubview:self.vistaPicker];
    [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height - 190, self.view.frame.size.width, self.vistaContentPicker.frame.size.height)];
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
        [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height, self.vistaContentPicker.frame.size.width, self.vistaContentPicker.frame.size.height)];
    }completion:^(BOOL finished){
        [self.vistaPicker removeFromSuperview];
        self.vistaPicker = nil;
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
        [self.txtDepartamento setText:title];
    }else if (selectedPicker == 2){
        [self.txtCiudad setText:title];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _tViewSeleccionado = textField.superview;
    _txtSeleccionado = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtDireccion isEqual:textField]) {
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
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }
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
#pragma mark - Actualizar dirección

-(void)requestServerActualizarDireccion{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerActualizarDireccion) object:nil];
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

-(void)envioServerActualizarDireccion{
    NSMutableDictionary * datos = [[NSMutableDictionary alloc] init];
    
    [datos setObject:@"opt" forKey:@"edit"];
    [datos setObject:self.txtNombre.text forKey:@"nombre"];
    [datos setObject:self.txtDireccion.text forKey:@"direccion"];
    [datos setObject:self.txtCelular.text forKey:@"telefono"];
    [datos setObject:self.txtCiudad.text forKey:@"ciudad"];
    [datos setObject:[_data objectForKey:@"id"] forKey:@"id"];
    
    _data = [RequestUrl actualizarUnaDireccion:datos];
    [self performSelectorOnMainThread:@selector(ocultarCargandoActualizarDireccion) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoActualizarDireccion{
    if ([_data count]>0) {
        
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
