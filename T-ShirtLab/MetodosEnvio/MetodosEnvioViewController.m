//
//  MetodosEnvioViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 29/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "MetodosEnvioViewController.h"
#import "ResumenViewController.h"

@interface MetodosEnvioViewController (){
    int envio;
}

@end

@implementation MetodosEnvioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(back)
                                                 name:@"BackNotificationMetodosEnvio"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setControllerPass:)
                                                 name:@"Resumen"
                                               object:nil];
    [self configurerView];
}

-(void)configurerView{
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        [self.contentVistaEnvio setFrame:self.view.frame];
    }else if (([[UIScreen mainScreen] bounds].size.height == 568)) {
        [self.contentVistaEnvio setFrame:self.view.frame];
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        [self.scroll setScrollEnabled:FALSE];
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        [self.scroll setScrollEnabled:FALSE];
    }
    [self.contentVistaEnvio setFrame:self.view.frame];
    
    if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        [self.viewLineaSeparadora setFrame:CGRectMake(self.viewLineaSeparadora.frame.origin.x, self.viewLineaSeparadora.frame.origin.y, self.viewLineaSeparadora.frame.size.width + 70, self.viewLineaSeparadora.frame.size.height)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAciotns

-(IBAction)continuar:(id)sender{
    UIImage * imgComprare = [UIImage imageNamed:@"chek.png"];
    NSData *imageDataCompare = UIImagePNGRepresentation(imgComprare);
    NSData *imageData = UIImagePNGRepresentation(self.btnTransportadora.currentImage);
    
    UIImage * imgComprareLab = [UIImage imageNamed:@"chek.png"];
    NSData *imageDataCompareLab = UIImagePNGRepresentation(imgComprareLab);
    NSData *imageDataLab = UIImagePNGRepresentation(self.btnLab.currentImage);
    
    if ([imageDataCompare isEqual:imageData] && [imageDataCompareLab isEqual:imageDataLab]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor asegurate de seleccionar una opción de envío" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        
    }
}

-(IBAction)seleccionarMetodo:(id)sender{
    int tag = (int)[sender tag];
    if (tag == 1) {
        [self.btnTransportadora setImage:[UIImage imageNamed:@"transportadora-active.png"] forState:UIControlStateNormal];
        [self.btnLab setImage:[UIImage imageNamed:@"t-shirt.png"] forState:UIControlStateNormal];
    }else{
        [self.btnTransportadora setImage:[UIImage imageNamed:@"transportadora.png"] forState:UIControlStateNormal];
        [self.btnLab setImage:[UIImage imageNamed:@"t-shirt-active.png"] forState:UIControlStateNormal];
    }
    envio = tag;
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

#pragma mark - Custom Delegates

- (void)setControllerPass:(NSNotification*)notification{
    UIImage * imgComprare = [UIImage imageNamed:@"transportadora-active.png"];
    NSData *imageDataCompare = UIImagePNGRepresentation(imgComprare);
    NSData *imageData = UIImagePNGRepresentation(self.btnTransportadora.currentImage);
    
    UIImage * imgComprareLab = [UIImage imageNamed:@"t-shirt-active.png"];
    NSData *imageDataCompareLab = UIImagePNGRepresentation(imgComprareLab);
    NSData *imageDataLab = UIImagePNGRepresentation(self.btnLab.currentImage);
    
    if ([imageDataCompare isEqual:imageData] || [imageDataCompareLab isEqual:imageDataLab]) {
        NSDictionary* userInfo = @{@"step": @"2"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaberStepNotification" object:userInfo];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ResumenViewController *resumenViewController = [story instantiateViewControllerWithIdentifier:@"ResumenViewController"];
        resumenViewController.modoEnvio = [NSString stringWithFormat:@"%i",envio];
        [self.navigationController pushViewController:resumenViewController animated:YES];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor asegurate de seleccionar una opción de envío" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

@end
