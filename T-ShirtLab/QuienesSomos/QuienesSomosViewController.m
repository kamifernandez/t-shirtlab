//
//  QuienesSomosViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 16/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "QuienesSomosViewController.h"
#import "RequestUrl.h"
#import "utilidades.h"

@interface QuienesSomosViewController ()

@end

@implementation QuienesSomosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    [self requestServerQuienesSomos];
}

-(void)construirVista{
    NSString * urlEnvio = [_data objectForKey:@"imagen"];
    if ([urlEnvio isEqualToString:@""]) {
        [self.indicatorHeader stopAnimating];
    }else{
        NSURL *imageURL = [NSURL URLWithString:urlEnvio];
        NSString *key = [urlEnvio MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            [self.indicatorHeader stopAnimating];
            UIImage *image = [UIImage imageWithData:data];
            self.imgTshirt.image = image;
        } else {
            //imagen.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.indicatorHeader stopAnimating];
                    self.imgTshirt.image = image;
                });
            });
        }
    }
    
    self.imgTshirt.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.imgTshirt.layer setMasksToBounds:YES];
    
    UIFont *font = [UIFont systemFontOfSize: 14];
    NSAttributedString *tes = [utilidades
                               attributedHTMLString: [_data objectForKey:@"texto"]
                               useFont: font
                               useHexColor: @"rgb(93,93,93)"];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString: tes];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing: 6];
    [style setAlignment: NSTextAlignmentJustified];
    
    [mutableAttributedString addAttribute: NSParagraphStyleAttributeName
                                    value: style
                                    range: NSMakeRange(0, mutableAttributedString.mutableString.length)];
    
    //
    self.lblDescription.attributedText = mutableAttributedString;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.scroll setContentSize:CGSizeMake(0, self.lblDescription.frame.origin.y + self.lblDescription.frame.size.height + 10)];
    [self.contentScroll setFrame:CGRectMake(0, 0, self.scroll.frame.size.width,self.lblDescription.frame.origin.y + self.lblDescription.frame.size.height + 10)];
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WebServices
#pragma mark - Obtener Quienes somos

-(void)requestServerQuienesSomos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerQuienesSomos) object:nil];
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

-(void)envioServerQuienesSomos{
    _data = [RequestUrl obtenerQuienesSomos];
    [self performSelectorOnMainThread:@selector(ocultarCargandoQuienesSomos) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoQuienesSomos{
    if ([_data count]>0) {
        [self construirVista];
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
                                        
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
