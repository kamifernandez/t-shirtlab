//
//  InisioSesionViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 14/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InisioSesionViewController : UIViewController<UITabBarControllerDelegate>

@property(nonatomic,weak)IBOutlet UIImageView * imgLogoHeader;

@property(nonatomic,weak)IBOutlet UIButton * btnBack;

@property(nonatomic,weak)IBOutlet UIButton * btnOk;

@property(nonatomic,weak)IBOutlet UIImageView * imgBackGround;

@property(nonatomic,weak)IBOutlet UIView * viewContentCorreo;

@property(nonatomic,weak)IBOutlet UIImageView * imgIconoCorreo;

@property(nonatomic,weak)IBOutlet UITextField * txtCorreo;

@property(nonatomic,weak)IBOutlet UIView * viewContentContrasena;

@property(nonatomic,weak)IBOutlet UIImageView * imgIconoContrasena;

@property(nonatomic,weak)IBOutlet UITextField * txtContrasena;

@property(nonatomic,weak)IBOutlet UIView * viewContentCuenta;

@property(nonatomic,weak)IBOutlet UIView * viewContentRegistro;

@property(nonatomic,strong)IBOutlet NSMutableDictionary * data;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
