//
//  RegistroViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 5/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistroViewController : UIViewController<UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property(nonatomic,weak)IBOutlet UIView * viewContentScroll;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,weak)IBOutlet UITextField * txtNombres;
@property(nonatomic,weak)IBOutlet UITextField * txtApellidos;
@property(nonatomic,weak)IBOutlet UITextField * txtCorreo;
@property(nonatomic,weak)IBOutlet UITextField * txtConfirmarCorreo;
@property(nonatomic,weak)IBOutlet UITextField * txtContrasena;

@property(nonatomic,weak)IBOutlet UIButton * btnPerson;
@property(nonatomic,weak)IBOutlet UIButton * btnCompany;
@property(nonatomic,weak)IBOutlet UIButton * btnAceptarTerminos;

@property(nonatomic,weak)IBOutlet UIImageView * iconPersonCompany;

@property(nonatomic,strong)NSMutableDictionary *data;

@property(nonatomic,strong)NSString *personaEmpresa;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
