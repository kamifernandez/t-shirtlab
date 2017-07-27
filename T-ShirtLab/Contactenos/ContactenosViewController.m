//
//  ContactenosViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 16/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "ContactenosViewController.h"
#import "RequestUrl.h"

@interface ContactenosViewController ()

@end

@implementation ContactenosViewController

-(void)viewWillAppear:(BOOL)animated
{
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(configurarLayouts) withObject:nil afterDelay:0.001];
    [self confirurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //[self.contentScrollContact setFrame:CGRectMake(0, 0, self.contentScrollContact.frame.size.width,1400)];
    [self.scroll setContentSize:CGSizeMake(0, self.contentScrollContact.frame.origin.y + self.contentScrollContact.frame.size.height + 10)];
    //[self.contentScroll setFrame:CGRectMake(0, 0, self.contentScrollContact.frame.size.width,10000)];
}

-(void)configurarLayouts{
    [super updateViewConstraints];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentScroll attribute: NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:920]];
}

-(void)confirurerView{
    [self.tvMenssage.layer setBorderWidth:0.5];
    [self.tvMenssage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

-(void)seePickerView{
    [self.view endEditing:true];
    
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
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return YES; // or true, whetever you's like
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _tViewSeleccionado = textView.superview;
    if ([textView.text isEqualToString:@"Escriba su mensaje..."] || [textView.text isEqualToString:@" "]) {
        [textView setText:@""];
        textView.textColor = [UIColor colorWithRed:93.0/255.0 green:93/255.0 blue:93/255.0 alpha:1.0];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""] || [textView.text isEqualToString:@" "]) {
        textView.text = @"Escriba su mensaje...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
}



#pragma mark IBActions

-(IBAction)seePickerView:(id)sender{
    [self requestServerDirecciones];
}

-(IBAction)selectPikcerButton:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{
        [self.vistaContentPicker setFrame:CGRectMake(0, self.view.frame.size.height, self.vistaContentPicker.frame.size.width, self.vistaContentPicker.frame.size.height)];
    }completion:^(BOOL finished){
        [self.vistaPicker removeFromSuperview];
        self.vistaPicker = nil;
    }];
}

-(IBAction)send:(id)sender{
    if ([self.txtCity.text isEqualToString:@""] || [self.tvMenssage.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Mensaje enviado" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
        [self.txtCity setText:@""];
        [self.tvMenssage setText:@""];
    }
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    CGPoint bottomOffset = CGPointMake(0, self.scroll.contentSize.height - self.scroll.bounds.size.height + 300);
    [_scroll setContentOffset:bottomOffset animated:YES];
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
    return [_data count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = @"";
    
    title=[NSString stringWithFormat:@"%@ %@",[[_data objectAtIndex:row] objectForKey:@"direccion"],[[_data objectAtIndex:row] objectForKey:@"ciudad"]];
    
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = @"";
    title=[NSString stringWithFormat:@"%@ %@",[[_data objectAtIndex:row] objectForKey:@"direccion"],[[_data objectAtIndex:row] objectForKey:@"ciudad"]];
    [self.txtCity setText:title];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=0;
    }
    // Fill the label text here
    tView.text=[NSString stringWithFormat:@"%@ %@",[[_data objectAtIndex:row] objectForKey:@"direccion"],[[_data objectAtIndex:row] objectForKey:@"ciudad"]];
    return tView;
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

#pragma mark - RequestServer Direcciones

-(void)requestServerDirecciones{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerDirecciones) object:nil];
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

-(void)envioServerDirecciones{
    //NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    //NSString * uid = [_defaults objectForKey:@"uid"];
    NSString * uid = @"1110";
    _data = [RequestUrl obtenerDirecciones:uid];
    [self performSelectorOnMainThread:@selector(ocultarCargandoDirecciones) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoDirecciones{
    if ([_data count]>0) {
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
