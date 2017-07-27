//
//  DetalleproductoViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 5/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "DetalleproductoViewController.h"
#import "utilidades.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "MiCarritoViewController.h"

#define COMMENT_LABEL_MIN_HEIGHT 321

@interface DetalleproductoViewController (){
    NSInteger selectedIndex;
    int tagCellSelected;
    BOOL devolver;
    int tagCategoria;
    BOOL open;
    BOOL moreInformation;
    BOOL informationProducto;
    
    BOOL agregadoFoto1;
    BOOL agregadoFoto2;
    BOOL agregadoFoto3;
    BOOL agregadoFoto4;
    BOOL agregadoFoto5;
    
    BOOL btnCadaFotoSeleccion;
    
    int tagBotonFotoSeleccion;
    
    int tagEliminarFoto;
}

@end

@implementation DetalleproductoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backRoot)
                                                 name:@"BackNotificationRootDetalle"
                                               object:nil];
    
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    moreInformation = NO;
    informationProducto = NO;
    agregadoFoto1 = NO;
    agregadoFoto2 = NO;
    agregadoFoto3 = NO;
    agregadoFoto4 = NO;
    agregadoFoto5 = NO;
    btnCadaFotoSeleccion = NO;
    self.widthContentViewScrollConstraint.constant = 432;
    [self.view layoutIfNeeded];
    selectedIndex = -1;
    
    if (([[UIScreen mainScreen] bounds].size.width == 320)) {
        self.widthFirsStepConstraint.constant = 110;
        self.ladingViewStepOneConstraint.constant = 5;
        [self.view layoutIfNeeded];
    }
    
    [self.viewStepsNumber1.layer setCornerRadius:5.0];
    [self.viewStepsNumber2.layer setCornerRadius:5.0];
    [self.viewStepsNumber3.layer setCornerRadius:5.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(back)
                                                 name:@"BackNotificationDetalleProducto"
                                               object:nil];
    
    // Vista Header
    
    [[NSBundle mainBundle] loadNibNamed:@"HeaderDetalleProductos" owner:self options:nil];
    [self.tblEstampados setTableHeaderView:self.viewCollection];
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCellDetalleProducto" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CollectionViewCellDetalleProducto"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(self.view.frame.size.width, 270)];
    //flowLayout.minimumInteritemSpacing = 64;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0,0);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    // Vista Footer
    
    [[NSBundle mainBundle] loadNibNamed:@"FooterTablaDetalleProductos" owner:self options:nil];
    [self.tblEstampados setTableFooterView:self.viewFooter];
    
    if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        [self.viewLineaSeparadora setFrame:CGRectMake(self.viewLineaSeparadora.frame.origin.x - 10, self.viewLineaSeparadora.frame.origin.y, self.viewLineaSeparadora.frame.size.width + 40, self.viewLineaSeparadora.frame.size.height)];
    }
    
    /// Corner Radius
    
    [self.btnFlecha setTransform:CGAffineTransformMakeRotation(M_PI)];
    
    [self.viewTallaSPrenda.layer setCornerRadius:2];
    
    [self.viewTallaSPrenda.layer setBorderWidth:1];
    
    [self.viewTallaSPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.viewTallaMPrenda.layer setCornerRadius:2];
    
    [self.viewTallaMPrenda.layer setBorderWidth:1];
    
    [self.viewTallaMPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.viewTallaLPrenda.layer setCornerRadius:2];
    
    [self.viewTallaLPrenda.layer setBorderWidth:1];
    
    [self.viewTallaLPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.viewTallaXlPrenda.layer setCornerRadius:2];
    
    [self.viewTallaXlPrenda.layer setBorderWidth:1];
    
    [self.viewTallaXlPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.viewTallaTotalPrenda.layer setCornerRadius:2];
    
    [self.viewTallaTotalPrenda.layer setBorderWidth:1];
    
    [self.viewTallaTotalPrenda.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.lblUnidad setText:@"$35.000"];
    
    CGRect sizeAll = self.viewPrecioTotal.frame;
    sizeAll.origin.x = self.viewPrecioTotal.superview.frame.size.width/2 - (self.viewPrecioTotal.frame.size.width/2 - 25);
    [self.viewPrecioUnitario setFrame:CGRectMake(sizeAll.origin.x, 5, 228, 49)];
    [self.viewPrecioTotal setFrame:sizeAll];
    
    /*+++++Harcode+++++++*/
    _dataCollection = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"http://t-shirtlab.com/images/ju_cached_images/Home-BannerPrincipal_3b4214f200a629cb3f231eef8b4a6b1b_920x375.resized.jpg" forKey:@"logo"];
            [dataInsert setObject:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vulputate quis justo eu lacinia. Donec condimentum mattis sollicitudin. Sed rhoncus neque" forKey:@"descripcion"];
            
        }else{
            [dataInsert setObject:@"http://t-shirtlab.com/images/ju_cached_images/Home-BannerPrincipal_3b4214f200a629cb3f231eef8b4a6b1b_920x375.resized.jpg" forKey:@"logo"];
            [dataInsert setObject:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit." forKey:@"descripcion"];
        }
        [_dataCollection addObject:dataInsert];
        dataInsert = nil;
    }
    
    _data = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"bolsillo-mas-carta.png" forKey:@"icon"];
            [dataInsert setObject:@"2" forKey:@"fotos"];
            [dataInsert setObject:@"Doble carta  y Doble carta" forKey:@"name"];
            NSMutableArray * dataTemp = [[NSMutableArray alloc] init];
            for (int j = 0; j <5; j++) {
                NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
                if (j % 2 == 0) {
                    [dataInsert setObject:@"• Ideal para cocinar, hornear, perfectos para amantes de la cocina, chefs y aficionados" forKey:@"info"];
                }else{
                    [dataInsert setObject:@"• Dale un toque de estilo a tu cocina o cerca de la parrilla personalizando tu delantal" forKey:@"info"];
                }
                [dataTemp addObject:dataInsert];
            }
            [dataInsert setObject:dataTemp forKey:@"info"];
            dataTemp = nil;
        }else{
            [dataInsert setObject:@"bolsillo-mas-carta.png" forKey:@"icon"];
            [dataInsert setObject:@"Doble carta  y Doble carta" forKey:@"name"];
            [dataInsert setObject:@"2" forKey:@"fotos"];
            NSMutableArray * dataTemp = [[NSMutableArray alloc] init];
            for (int j = 0; j <5; j++) {
                NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
                if (j % 2 == 0) {
                    [dataInsert setObject:@"• Ideal para cocinar, hornear, perfectos para amantes de la cocina, chefs y aficionados" forKey:@"info"];
                }else{
                    [dataInsert setObject:@"• Dale un toque de estilo a tu cocina o cerca de la parrilla personalizando tu delantal" forKey:@"info"];
                }
                [dataTemp addObject:dataInsert];
            }
            [dataInsert setObject:dataTemp forKey:@"info"];
            dataTemp = nil;
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    
    [self.tblEstampados reloadData];
    
    self.pageCollection.numberOfPages = [_dataCollection count];
    [self.collectionView reloadData];
    [self verificarFotos];
}

-(void)verificarFotos{
    int numFotos = [[[_data objectAtIndex:0] objectForKey:@"fotos"] intValue];
    if (numFotos == 5) {
        [self.viewFoto1 setHidden:FALSE];
        [self.viewFoto2 setHidden:FALSE];
        [self.viewFoto3 setHidden:FALSE];
        [self.viewFoto4 setHidden:FALSE];
        [self.viewFoto5 setHidden:FALSE];
        self.viewUltimaFoto = self.viewFoto3;
    }else if (numFotos == 4){
        [self.viewFoto1 setHidden:FALSE];
        [self.viewFoto2 setHidden:FALSE];
        [self.viewFoto3 setHidden:FALSE];
        [self.viewFoto4 setHidden:FALSE];
        self.viewUltimaFoto = self.viewFoto2;
    }else if (numFotos == 3){
        [self.btnFlecha setHidden:TRUE];
        [self.btnFlechaBack setHidden:TRUE];
        [self.viewFoto1 setHidden:FALSE];
        [self.viewFoto2 setHidden:FALSE];
        [self.viewFoto3 setHidden:FALSE];
    }else if (numFotos == 2){
        [self.btnFlecha setHidden:TRUE];
        [self.btnFlechaBack setHidden:TRUE];
        [self.viewFoto1 setHidden:FALSE];
        [self.viewFoto2 setHidden:FALSE];
    }else if (numFotos == 1){
        [self.btnFlecha setHidden:TRUE];
        [self.btnFlechaBack setHidden:TRUE];
        [self.viewFoto1 setHidden:FALSE];
    }
    [self.scrollFoto setContentSize:CGSizeMake(numFotos*90, 0)];
}

#pragma mark Metodos Custom Methods

-(void)back{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actualizarValoresCelda{
    if (tagCellSelected != -1) {
        
        int tallaS = [self.txtTallaSPrenda.text intValue];
        
        int tallaM = [self.txtTallaMPrenda.text intValue];
        
        int tallaL = [self.txtTallaLPrenda.text intValue];
        
        int tallaXl = [self.txtTallaXlPrenda.text intValue];
        
        int totalPrendas = tallaS + tallaM + tallaL + tallaXl;
        
        //int valorTotal = totalPrendas * [[_data objectAtIndex:0] objectForKey:@"valor"];
        
        int valorTotal = totalPrendas * 35.000;
        
        [self.txtTallaTotalPrenda setText:[NSString stringWithFormat:@"%i",totalPrendas]];
        
        if (valorTotal != 0) {
            [self.lblTotal setText:[NSString stringWithFormat:@"$%@",[utilidades decimalNumberFormat:valorTotal]]];
            
            [self.txtTotalBottom setText:[NSString stringWithFormat:@"$%@",[utilidades decimalNumberFormat:valorTotal]]];
        }else{
            [self.lblTotal setText:[NSString stringWithFormat:@"$%@",@"0"]];
            
            [self.txtTotalBottom setText:[NSString stringWithFormat:@"$%@",@"0"]];
        }
    }
}

-(void)eliminarFoto{
    switch (tagEliminarFoto) {
        case 1:
            self.imgFoto1.image = [UIImage imageNamed:@"seguimiento_imagen.png"];
            agregadoFoto1 = NO;
            [self.btnFoto1 setHidden:TRUE];
            break;
        case 2:
            self.imgFoto2.image = [UIImage imageNamed:@"seguimiento_imagen.png"];
            agregadoFoto2 = NO;
            [self.btnFoto2 setHidden:TRUE];
            break;
        case 3:
            self.imgFoto3.image = [UIImage imageNamed:@"seguimiento_imagen.png"];
            agregadoFoto3 = NO;
            [self.btnFoto3 setHidden:TRUE];
            break;
        case 4:
            self.imgFoto4.image = [UIImage imageNamed:@"seguimiento_imagen.png"];
            agregadoFoto4 = NO;
            [self.btnFoto4 setHidden:TRUE];
            break;
        case 5:
            self.imgFoto5.image = [UIImage imageNamed:@"seguimiento_imagen.png"];
            agregadoFoto5 = NO;
            [self.btnFoto5 setHidden:TRUE];
            break;
    }
}

-(BOOL)verificarFotosTomadas{
    BOOL siNo = NO;
    int numFotos = [[[_data objectAtIndex:0] objectForKey:@"fotos"] intValue];
    if (numFotos == 5) {
        if (agregadoFoto1 && agregadoFoto2 && agregadoFoto3 && agregadoFoto4 && agregadoFoto5) {
            siNo = YES;
        }
    }else if (numFotos == 4){
        if (agregadoFoto1 && agregadoFoto2 && agregadoFoto3 && agregadoFoto4) {
            siNo = YES;
        }
    }else if (numFotos == 3){
        if (agregadoFoto1 && agregadoFoto2 && agregadoFoto3) {
            siNo = YES;
        }
    }else if (numFotos == 2){
        if (agregadoFoto1 && agregadoFoto2) {
            siNo = YES;
        }
    }else if (numFotos == 1){
        if (agregadoFoto1) {
            siNo = YES;
        }
    }
    return siNo;
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _tViewSeleccionado = [textField superview];
    
    if ([_txtSelected.text isEqualToString:@""]) {
        _txtSelected.text = @"0";
    }
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
    _txtSelected = textField;
    keyboardDoneButtonView = nil;
    doneButton = nil;
    negativeSeparator = nil;
    keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    negativeSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                                  style:UIBarButtonItemStylePlain target:self
                                                 action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:negativeSeparator,doneButton, nil]];
    textField.inputAccessoryView = keyboardDoneButtonView;
    
    float origenTagTemp = (float)[textField tag]/10;
    int origenIndex = truncf(origenTagTemp);
    
    tagCellSelected = origenIndex;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:TRUE];
    return true;
}

#pragma mark -
#pragma mark IBACtions

- (void)doneClicked:(id)sender
{
    if (tagCellSelected != -1) {
        [self actualizarValoresCelda];
    }
    
    if ([_txtSelected.text isEqualToString:@""]) {
        _txtSelected.text = @"0";
    }
    tagCellSelected = -1;
    [self.view endEditing:YES];
}

-(IBAction)btnTallaCantidad:(id)sender{
    CGRect centeredRect = CGRectMake(self.viewFooter.frame.origin.x + self.viewFooter.frame.size.width/2.0 - self.tblEstampados.frame.size.width/2.0,
                                     self.viewFooter.frame.origin.y + self.viewFooter.frame.size.height/2.0 - (self.tblEstampados.frame.size.height/2.0 + 140),
                                     self.tblEstampados.frame.size.width,
                                     self.tblEstampados.frame.size.height);
    [self.tblEstampados scrollRectToVisible:centeredRect animated:YES];
}

-(IBAction)getPhoto:(id) sender {
    
    if ([self verificarFotosTomadas]) {
        CGRect centeredRect = CGRectMake(self.viewFooter.frame.origin.x + self.viewFooter.frame.size.width/2.0 - self.tblEstampados.frame.size.width/2.0,
                                         self.viewFooter.frame.origin.y + self.viewFooter.frame.size.height/2.0 - (self.tblEstampados.frame.size.height/2.0 - 50),
                                         self.tblEstampados.frame.size.width,
                                         self.tblEstampados.frame.size.height);
        [self.tblEstampados scrollRectToVisible:centeredRect animated:YES];
        
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Puedes editar tus fotos desde esta sección" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Seleccione"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button one");
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Cámara" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if(authStatus == AVAuthorizationStatusAuthorized) {
                UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:nil];
            } else if(authStatus == AVAuthorizationStatusDenied){
                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                [msgDict setValue:@"Atención" forKey:@"Title"];
                [msgDict setValue:@"Se necesitan permisos para acceder a esta opción, ¿Desea darle permisos?" forKey:@"Message"];
                [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
                [msgDict setValue:@"100" forKey:@"Tag"];
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                    waitUntilDone:YES];
            } else if(authStatus == AVAuthorizationStatusRestricted){
                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                [msgDict setValue:@"Atención" forKey:@"Title"];
                [msgDict setValue:@"Se necesitan permisos para acceder a esta opción, ¿Desea darle permisos?" forKey:@"Message"];
                [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
                [msgDict setValue:@"100" forKey:@"Tag"];
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                    waitUntilDone:YES];
            } else if(authStatus == AVAuthorizationStatusNotDetermined){
                // not determined?!
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        NSLog(@"Granted access to %@", AVMediaTypeVideo);
                        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        
                        [self presentViewController:picker animated:YES completion:nil];
                    } else {
                        NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                    }
                }];
            } else {
                // impossible, unknown authorization status
            }
        }];
        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"Biblioteca" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
            if(authStatus == PHAuthorizationStatusAuthorized) {
                UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
                [self presentViewController:picker animated:YES completion:nil];
            } else if(authStatus == PHAuthorizationStatusDenied){
                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                [msgDict setValue:@"Atención" forKey:@"Title"];
                [msgDict setValue:@"Se necesitan permisos para acceder a esta opción, ¿Desea darle permisos?" forKey:@"Message"];
                [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
                [msgDict setValue:@"100" forKey:@"Tag"];
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                    waitUntilDone:YES];
            } else if(authStatus == PHAuthorizationStatusRestricted){
                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                [msgDict setValue:@"Atención" forKey:@"Title"];
                [msgDict setValue:@"Se necesitan permisos para acceder a esta opción, ¿Desea darle permisos?" forKey:@"Message"];
                [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
                [msgDict setValue:@"100" forKey:@"Tag"];
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                    waitUntilDone:YES];
            } else if(authStatus == PHAuthorizationStatusNotDetermined){
                // not determined?!
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        NSLog(@"Granted access to %@", AVMediaTypeVideo);
                        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        
                        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                        
                        [self presentViewController:picker animated:YES completion:nil];
                    } else {
                        NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                    }
                }];
            } else {
                // impossible, unknown authorization status
            }
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:deleteAction];
        [alert addAction:archiveAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(IBAction)btnInformacionEstampado:(id)sender{
    if (moreInformation == NO) {
        UITableViewCell *selectedCell=[self.tblEstampados cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.viewInformacionEstampado = [[UIView alloc] init];
        [self.viewInformacionEstampado setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, 360)];
        [self.viewInformacionEstampado setBackgroundColor:[UIColor redColor]];
        UIImageView * imgInformacionEstampado = [[UIImageView alloc] init];
        [imgInformacionEstampado setImage:[UIImage imageNamed:@"prueba.png"]];
        [imgInformacionEstampado setFrame:CGRectMake(0, 0, self.viewInformacionEstampado.frame.size.width, self.viewInformacionEstampado.frame.size.height)];
        
        UIButton * btnBackEstampado = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBackEstampado addTarget:self action:@selector(backEstampado:) forControlEvents:UIControlEventTouchUpInside];
        [btnBackEstampado setFrame:CGRectMake(10, self.viewInformacionEstampado.bounds.size.height/2 - btnBackEstampado.frame.size.height/2, 35, 50)];
        [btnBackEstampado setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:39.0/255.0 blue:63.0/255.0 alpha:1]];
        [btnBackEstampado setImage:[UIImage imageNamed:@"button-scroll.png"] forState:UIControlStateNormal];
        
        UIView *viewContent = (UIView *)[selectedCell viewWithTag:3];
        
        [UIView animateWithDuration:0.5 animations:^{
            [viewContent setFrame:CGRectMake(-self.view.frame.size.width, viewContent.frame.origin.y, viewContent.frame.size.width, viewContent.frame.size.height)];
        }completion:^(BOOL finished){
            [self.btnInformacionProducto setEnabled:FALSE];
            [self.btnInformacionEstampado setEnabled:FALSE];
        }];
        
        [self.viewInformacionEstampado addSubview:imgInformacionEstampado];
        [self.viewInformacionEstampado addSubview:btnBackEstampado];
        [viewContent addSubview:self.viewInformacionEstampado];
        imgInformacionEstampado = nil;
        moreInformation = YES;
        [self.tblEstampados beginUpdates];
        [self.tblEstampados endUpdates];
    }
}

-(void)backEstampado:(id)sender{
    UITableViewCell *selectedCell=[self.tblEstampados cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIView *viewContent = (UIView *)[selectedCell viewWithTag:3];
    [UIView animateWithDuration:0.5 animations:^{
        [viewContent setFrame:CGRectMake(0, viewContent.frame.origin.y, viewContent.frame.size.width, viewContent.frame.size.height)];
    }completion:^(BOOL finished){
        [self.btnInformacionProducto setEnabled:TRUE];
        [self.btnInformacionEstampado setEnabled:TRUE];
        if (self.viewInformacionEstampado) {
            [self.viewInformacionEstampado removeFromSuperview];
            self.viewInformacionEstampado = nil;
        }
    }];
    moreInformation = NO;
    [self.tblEstampados beginUpdates];
    [self.tblEstampados endUpdates];
}

-(IBAction)btnInformacionProducto:(id)sender{
    if (informationProducto == NO) {
        UITableViewCell *selectedCell=[self.tblEstampados cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.viewInformacionProducto = [[UIView alloc] init];
        [self.viewInformacionProducto setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, 360)];
        [self.viewInformacionProducto setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1]];
        
        NSMutableArray * tempData = [[self.data objectAtIndex:0] objectForKey:@"info"];
        int ySpace = 45;
        for (int i = 0; i<[tempData count]; i++) {
            NSString * info = [[tempData objectAtIndex:i] objectForKey:@"info"];
            
            UILabel * lblInfo = [[UILabel alloc] init];
            [lblInfo setText:info];
            lblInfo.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
            lblInfo.font = [UIFont systemFontOfSize:14.0];
            [lblInfo setTextAlignment:NSTextAlignmentLeft];
            [lblInfo setTextColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0]];
            lblInfo.numberOfLines = 0;
            CGSize neededSize = [lblInfo sizeThatFits:CGSizeMake(self.viewInformacionProducto.frame.size.width - 40, CGFLOAT_MAX)];
            [lblInfo setFrame:CGRectMake(50, ySpace, self.viewInformacionProducto.frame.size.width - 70, neededSize.height)];
            ySpace = lblInfo.frame.origin.y + lblInfo.frame.size.height + 15;
            
            [self.viewInformacionProducto addSubview:lblInfo];
        }
        
        [self.viewInformacionProducto setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, ySpace)];
        
        UIButton * btnBackEstampado = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBackEstampado addTarget:self action:@selector(backInformacionProducto:) forControlEvents:UIControlEventTouchUpInside];
        [btnBackEstampado setFrame:CGRectMake(10, self.viewInformacionProducto.bounds.size.height/2 - btnBackEstampado.frame.size.height/2, 35, 50)];
        [btnBackEstampado setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:39.0/255.0 blue:63.0/255.0 alpha:1]];
        [btnBackEstampado setImage:[UIImage imageNamed:@"button-scroll.png"] forState:UIControlStateNormal];
        
        UIView *viewContent = (UIView *)[selectedCell viewWithTag:3];
        
        [UIView animateWithDuration:0.5 animations:^{
            [viewContent setFrame:CGRectMake(-self.view.frame.size.width, viewContent.frame.origin.y, viewContent.frame.size.width, viewContent.frame.size.height)];
        }completion:^(BOOL finished){
            [self.btnInformacionProducto setEnabled:FALSE];
            [self.btnInformacionEstampado setEnabled:FALSE];
        }];
        
        [self.viewInformacionProducto addSubview:btnBackEstampado];
        [viewContent addSubview:self.viewInformacionProducto];
        informationProducto = YES;
        [self.tblEstampados beginUpdates];
        [self.tblEstampados endUpdates];
    }
}

-(void)backInformacionProducto:(id)sender{
    UITableViewCell *selectedCell=[self.tblEstampados cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIView *viewContent = (UIView *)[selectedCell viewWithTag:3];
    [UIView animateWithDuration:0.5 animations:^{
        [viewContent setFrame:CGRectMake(0, viewContent.frame.origin.y, viewContent.frame.size.width, viewContent.frame.size.height)];
    }completion:^(BOOL finished){
        [self.btnInformacionProducto setEnabled:TRUE];
        [self.btnInformacionEstampado setEnabled:TRUE];
        if (self.viewInformacionProducto) {
            [self.viewInformacionProducto removeFromSuperview];
            self.viewInformacionProducto = nil;
        }
    }];
    informationProducto = NO;
    [self.tblEstampados beginUpdates];
    [self.tblEstampados endUpdates];
}

-(IBAction)botonFotoSeleccion:(id)sender{
    tagBotonFotoSeleccion = (int)[sender tag];
    btnCadaFotoSeleccion = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Seleccione"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button one");
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Cámara" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:nil];
        } else if(authStatus == AVAuthorizationStatusDenied){
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Se necesitan permisos para acceder a esta opción, ¿Desea darle permisos?" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
            [msgDict setValue:@"100" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        } else if(authStatus == AVAuthorizationStatusRestricted){
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Se necesitan permisos para acceder a esta opción, ¿Desea darle permisos?" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
            [msgDict setValue:@"100" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            // not determined?!
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    NSLog(@"Granted access to %@", AVMediaTypeVideo);
                    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self presentViewController:picker animated:YES completion:nil];
                } else {
                    NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                }
            }];
        } else {
            // impossible, unknown authorization status
        }
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"Biblioteca" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if(authStatus == PHAuthorizationStatusAuthorized) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            [self presentViewController:picker animated:YES completion:nil];
        } else if(authStatus == PHAuthorizationStatusDenied){
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Se necesitan permisos para acceder a esta opción, ¿Desea darle permisos?" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
            [msgDict setValue:@"100" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        } else if(authStatus == PHAuthorizationStatusRestricted){
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Se necesitan permisos para acceder a esta opción, ¿Desea darle permisos?" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
            [msgDict setValue:@"100" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        } else if(authStatus == PHAuthorizationStatusNotDetermined){
            // not determined?!
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    NSLog(@"Granted access to %@", AVMediaTypeVideo);
                    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    
                    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    
                    [self presentViewController:picker animated:YES completion:nil];
                } else {
                    NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                }
            }];
        } else {
            // impossible, unknown authorization status
        }
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [alert addAction:archiveAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)btnFlechasScrollFotos:(id)sender{
    int tag = (int)[sender tag];
    if (tag == 1) {
        [self.scrollFoto setContentOffset:CGPointMake(self.viewFoto1.frame.origin.x, 0) animated:YES];
    }else{
        [self.scrollFoto setContentOffset:CGPointMake(self.viewUltimaFoto.frame.origin.x, 0) animated:YES];
    }
}

-(IBAction)btnEliminarFoto:(id)sender{
    tagEliminarFoto = (int)[sender tag];
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Atención" forKey:@"Title"];
    [msgDict setValue:@"¿Desea eliminar esta foto?" forKey:@"Message"];
    [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
    [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
    [msgDict setValue:@"101" forKey:@"Tag"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
}

-(IBAction)agregarAlCarrito:(id)sender{
    if ([self.txtTallaTotalPrenda.text isEqualToString:@"0"]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Debe escoger mínimo una cantidad" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([self verificarFotosTomadas]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DesaparecerContenedor" object:nil];
            [self.tabBarController setSelectedIndex:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarAlertaCarrito" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Debe cargar las imágenes correspondientes a su estampado." forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }
}

#pragma mark Metodos Camera Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (btnCadaFotoSeleccion) {
        switch (tagBotonFotoSeleccion) {
            case 1:
                self.imgFoto1.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto1 = YES;
                [self.btnFoto1 setHidden:false];
                [self.imgFoto1 setContentMode:UIViewContentModeScaleAspectFit];
                break;
            case 2:
                self.imgFoto2.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                [self.imgFoto2 setContentMode:UIViewContentModeScaleAspectFit];
                agregadoFoto2 = YES;
                [self.btnFoto2 setHidden:false];
                break;
            case 3:
                self.imgFoto3.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                [self.imgFoto3 setContentMode:UIViewContentModeScaleAspectFit];
                agregadoFoto3 = YES;
                [self.btnFoto3 setHidden:false];
                break;
            case 4:
                self.imgFoto4.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                [self.imgFoto4 setContentMode:UIViewContentModeScaleAspectFit];
                agregadoFoto4 = YES;
                [self.btnFoto4 setHidden:false];
                break;
            case 5:
                self.imgFoto5.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto5 = YES;
                [self.btnFoto5 setHidden:false];
                [self.imgFoto5 setContentMode:UIViewContentModeScaleAspectFit];
                break;
        }
        btnCadaFotoSeleccion = NO;
    }else{
        int numFotos = [[[_data objectAtIndex:0] objectForKey:@"fotos"] intValue];
        if (numFotos == 5) {
            if (agregadoFoto1 == NO) {
                self.imgFoto1.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto1 = YES;
                [self.btnFoto1 setHidden:false];
                [self.imgFoto1 setContentMode:UIViewContentModeScaleAspectFit];
            }else if (agregadoFoto2 == NO){
                self.imgFoto2.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto2 = YES;
                [self.btnFoto2 setHidden:false];
                [self.imgFoto2 setContentMode:UIViewContentModeScaleAspectFit];
            }else if (agregadoFoto3 == NO){
                self.imgFoto3.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto3 = YES;
                [self.btnFoto3 setHidden:false];
                [self.imgFoto3 setContentMode:UIViewContentModeScaleAspectFit];
            }else if (agregadoFoto4 == NO){
                self.imgFoto4.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto4 = YES;
                [self.btnFoto4 setHidden:false];
                [self.imgFoto4 setContentMode:UIViewContentModeScaleAspectFit];
            }else if (agregadoFoto5 == NO){
                self.imgFoto5.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto5 = YES;
                [self.btnFoto5 setHidden:false];
                [self.imgFoto5 setContentMode:UIViewContentModeScaleAspectFit];
            }
        }else if (numFotos == 4){
            if (agregadoFoto1 == NO) {
                self.imgFoto1.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto1 = YES;
                [self.btnFoto1 setHidden:false];
                [self.imgFoto1 setContentMode:UIViewContentModeScaleAspectFit];
            }else if (agregadoFoto2 == NO){
                self.imgFoto2.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto2 = YES;
                [self.btnFoto2 setHidden:false];
                [self.imgFoto2 setContentMode:UIViewContentModeScaleAspectFit];
            }else if (agregadoFoto3 == NO){
                self.imgFoto3.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto3 = YES;
                [self.btnFoto3 setHidden:false];
                [self.imgFoto3 setContentMode:UIViewContentModeScaleAspectFit];
            }else if (agregadoFoto4 == NO){
                self.imgFoto4.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto4 = YES;
                [self.btnFoto4 setHidden:false];
                [self.imgFoto4 setContentMode:UIViewContentModeScaleAspectFit];
            }
        }else if (numFotos == 3){
            if (agregadoFoto1 == NO) {
                self.imgFoto1.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto1 = YES;
                [self.btnFoto1 setHidden:false];
                [self.imgFoto1 setContentMode:UIViewContentModeScaleAspectFit];
            }else if (agregadoFoto2 == NO){
                self.imgFoto2.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto2 = YES;
                [self.btnFoto2 setHidden:false];
                [self.imgFoto2 setContentMode:UIViewContentModeScaleAspectFit];
            }else if (agregadoFoto3 == NO){
                self.imgFoto3.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto3 = YES;
                [self.btnFoto3 setHidden:false];
                [self.imgFoto3 setContentMode:UIViewContentModeScaleAspectFit];
            }
        }else if (numFotos == 2){
            if (agregadoFoto1 == NO) {
                self.imgFoto1.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto1 = YES;
                [self.btnFoto1 setHidden:false];
                [self.imgFoto1 setContentMode:UIViewContentModeScaleAspectFit];
            }else if (agregadoFoto2 == NO){
                self.imgFoto2.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto2 = YES;
                [self.btnFoto2 setHidden:false];
                [self.imgFoto2 setContentMode:UIViewContentModeScaleAspectFit];
            }
        }else if (numFotos == 1){
            if (agregadoFoto1 == NO) {
                self.imgFoto1.image = [utilidades scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
                agregadoFoto1 = YES;
                [self.btnFoto1 setHidden:false];
                [self.imgFoto1 setContentMode:UIViewContentModeScaleAspectFit];
            }
        }
    }
}

#pragma mark -
#pragma mark Delegates UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataCollection count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CollectionViewCellDetalleProducto";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *imgTshirt = (UIImageView *)[cell viewWithTag:1];
    UIActivityIndicatorView *indicador = (UIActivityIndicatorView *)[cell viewWithTag:2];
    NSString * urlEnvio = [[self.dataCollection objectAtIndex:indexPath.row] objectForKey: @"logo"];
    if ([urlEnvio isEqualToString:@""]) {
        [indicador stopAnimating];
        [imgTshirt setFrame:CGRectMake(imgTshirt.frame.origin.x, imgTshirt.frame.origin.y - 15, imgTshirt.frame.size.width, imgTshirt.frame.size.height)];
    }else{
        NSURL *imageURL = [NSURL URLWithString:urlEnvio];
        NSString *key = [[[self.dataCollection objectAtIndex:indexPath.row] objectForKey: @"logo"] MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            [indicador stopAnimating];
            UIImage *image = [UIImage imageWithData:data];
            imgTshirt.image = image;
        } else {
            //imagen.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [indicador stopAnimating];
                    imgTshirt.image = image;
                });
            });
        }
    }
    
    return cell;
    
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [_data count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"CeldaTablaDetalleProducto";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CeldaTablaDetalleProducto" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    moreInformation = NO;
    informationProducto = NO;
    [self.btnInformacionProducto setEnabled:TRUE];
    [self.btnInformacionEstampado setEnabled:TRUE];
    [self.lblTituloTamanoEstampado setFrame:CGRectMake(0, 26, self.view.bounds.size.width, 23)];
    UIView * viewBackCell = (UIView *)[cell viewWithTag:3];
    [viewBackCell setFrame:CGRectMake(0, 0, self.view.frame.size.width * 2, viewBackCell.frame.size.height)];
    CGRect f = [[UIScreen mainScreen] bounds];
    
    int beginX = 0;
    if (f.size.width == 320) {
        beginX = 20;
    }else if (f.size.width == 375) {
        beginX = 45;
    }else if (f.size.width == 414){
        beginX = 65;
    }
    
    
    int xSpace = beginX;
    int ySpace = 70;
    int countTimes = 0;
    for (int i = 0; i<[_data count]; i++) {
        if (i<5) {
            UIView * contentButton = [[UIView alloc] init];
            [contentButton setFrame:CGRectMake(xSpace, ySpace, 75, 103)];
            [contentButton setBackgroundColor:[UIColor clearColor]];
            
            UIImageView * icon = [[UIImageView alloc] init];
            [icon setFrame:CGRectMake(0, 0, 75, 75)];
            [icon setImage:[UIImage imageNamed:[[_data objectAtIndex:i] objectForKey:@"icon"]]];
            
            UILabel * lblDescripcion = [[UILabel alloc] init];
            [lblDescripcion setFrame:CGRectMake(0, 67, 75, 36)];
            lblDescripcion.font = [UIFont fontWithName:@"Helvetica Neue-Light" size:12.0];
            lblDescripcion.font = [UIFont systemFontOfSize:11.0];
            [lblDescripcion setTextAlignment:NSTextAlignmentCenter];
            lblDescripcion.numberOfLines = 0;
            [lblDescripcion setTextColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0]];
            [lblDescripcion setText:[[_data objectAtIndex:i] objectForKey:@"name"]];
            [lblDescripcion setBackgroundColor:[UIColor clearColor]];
            
            NSLog(@"Fonts %@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
            
            UIButton * btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnIcon setFrame:contentButton.frame];
            [btnIcon setTag:i];
            
            [contentButton addSubview:icon];
            [contentButton addSubview:lblDescripcion];
            
            icon = nil;
            lblDescripcion = nil;
            
            [contentButton addSubview:btnIcon];
            
            [viewBackCell addSubview:contentButton];
            if (countTimes == 2) {
                if ([_data count] > i) {
                    ySpace = (contentButton.frame.origin.y + contentButton.frame.size.height) + 27;
                    xSpace = beginX;
                    countTimes = 0;
                }
            }else{
                xSpace = (contentButton.frame.origin.x + contentButton.frame.size.width) + 28;
                countTimes ++;
            }
        }else{
            UIView * contentButton = [[UIView alloc] init];
            [contentButton setFrame:CGRectMake(xSpace, ySpace, 75, 103)];
            [contentButton setBackgroundColor:[UIColor clearColor]];
            
            UIImageView * icon = [[UIImageView alloc] init];
            [icon setFrame:CGRectMake(0, 0, 75, 75)];
            [icon setImage:[UIImage imageNamed:@"mas-opciones.png"]];
            
            UILabel * lblDescripcion = [[UILabel alloc] init];
            [lblDescripcion setFrame:CGRectMake(0, 67, 75, 36)];
            lblDescripcion.font = [UIFont fontWithName:@"Helvetica Neue-Light" size:12.0];
            lblDescripcion.font = [UIFont systemFontOfSize:11.0];
            [lblDescripcion setTextAlignment:NSTextAlignmentCenter];
            lblDescripcion.numberOfLines = 0;
            [lblDescripcion setTextColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0]];
            [lblDescripcion setText:@"Más opciones de estampados"];
            [lblDescripcion setBackgroundColor:[UIColor clearColor]];
            
            NSLog(@"Fonts %@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
            
            UIButton * btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnIcon setFrame:contentButton.frame];
            [btnIcon setTag:i];
            
            [contentButton addSubview:icon];
            [contentButton addSubview:lblDescripcion];
            
            icon = nil;
            lblDescripcion = nil;
            
            [contentButton addSubview:btnIcon];
            
            [viewBackCell addSubview:contentButton];
            break;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(selectedIndex == indexPath.row)
    {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }else{
        
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex >= 0)
    {
        
        //UITableViewCell *cell = [self.tblSchedule cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        
        //selectedIndex = indexPath.row;
        tagCategoria = 0;
        devolver = YES;
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    
    devolver = NO;
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //UITableViewCell *cell = [self.tblSchedule cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ExpandTable delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //If this is the selected index we need to return the height of the cell
    //in relation to the label height otherwise we just return the minimum label height with padding
    if(moreInformation)
    {
        return 360;
    }else if (informationProducto){
        return [self getLabelHeightForIndex];
    }else {
        return COMMENT_LABEL_MIN_HEIGHT;
    }
    return 321;
}

-(CGFloat)getLabelHeightForIndex
{
    
    NSMutableArray * tempData = [[self.data objectAtIndex:0] objectForKey:@"info"];
    int ySpace = 45;
    for (int i = 0; i<[tempData count]; i++) {
        NSString * info = [[tempData objectAtIndex:i] objectForKey:@"info"];
        UILabel * lblInfo = [UILabel new];
        [lblInfo setText:info];
        lblInfo.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
        lblInfo.font = [UIFont systemFontOfSize:14.0];
        [lblInfo setTextAlignment:NSTextAlignmentLeft];
        [lblInfo setTextColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0]];
        lblInfo.numberOfLines = 0;
        CGSize neededSize = [lblInfo sizeThatFits:CGSizeMake(self.viewInformacionProducto.frame.size.width - 40, CGFLOAT_MAX)];
        
        ySpace += lblInfo.frame.origin.y + neededSize.height + 20;
        lblInfo = nil;
    }
    return ySpace;
}

#pragma mark Metodos Teclado

-(void)mostrarTeclado:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width-60, 0.0);
    _tblEstampados.contentInset = contentInsets;
    _tblEstampados.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = _tblEstampados.frame;
    aRect.size.height -= kbSize.width;
    if (!CGRectContainsPoint(aRect, _tViewSeleccionado.frame.origin) ) {
        // El 160 es un parametro que depende de la vista en la que se encuentra, se debe ajustar dependiendo del caso
        float tamano = 0.0;
        
        float version=[[UIDevice currentDevice].systemVersion floatValue];
        if(version <7.0){
            tamano = _tViewSeleccionado.frame.origin.y-100;
        }else{
            tamano = _tViewSeleccionado.frame.origin.y-100;
        }
        if(tamano<0)
            tamano=0;
        CGPoint scrollPoint = CGPointMake(0.0, tamano);
        if (tagCellSelected != 1) {
            [_tblEstampados setContentOffset:scrollPoint animated:YES];
        }
    }
}

-(void)ocultarTeclado:(NSNotification*)aNotification
{
    [ UIView animateWithDuration:0.4f animations:^
     {
         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
         _tblEstampados.contentInset = contentInsets;
         _tblEstampados.scrollIndicatorInsets = contentInsets;
     }completion:^(BOOL finished){
         
     }];
}

#pragma mark - ScrollView Delegates

- (void)scrollViewWillBeginDragging:(UIScrollView *)activeScrollView {
    if (tagCellSelected != -1) {
        [self actualizarValoresCelda];
    }
    tagCellSelected = -1;
    if ([_txtSelected.text isEqualToString:@""]) {
        _txtSelected.text = @"0";
    }
    
    [self.view endEditing:TRUE];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.pageCollection.currentPage = self.collectionView.contentOffset.x / pageWidth;
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
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"100"]) {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                        }else if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]){
                                            [self eliminarFoto];
                                        }
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
                                        
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)backRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
