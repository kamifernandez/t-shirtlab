//
//  MetodosEnvioViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 29/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MetodosEnvioViewController;

@protocol MetodosEnvioViewControllerDelegate <NSObject>

@optional
- (void)changeStep:(int)step;

@end

@interface MetodosEnvioViewController : UIViewController

@property(nonatomic,weak)IBOutlet UIView * viewLineaSeparadora;

@property(nonatomic,weak)IBOutlet UIView * contentVistaEnvio;

@property(nonatomic,weak)IBOutlet UIScrollView * scroll;

@property(nonatomic,weak)IBOutlet UILabel * lblFinal;

@property(nonatomic,weak)IBOutlet UIButton * btnTransportadora;

@property(nonatomic,weak)IBOutlet UIButton * btnLab;

@property(nonatomic,strong)NSMutableArray * pedido;

@property (nonatomic, weak) id<MetodosEnvioViewControllerDelegate> delegateEnvios;

@end
