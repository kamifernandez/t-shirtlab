//
//  QuienesSomosViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 16/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface QuienesSomosViewController : UIViewController

@property(nonatomic,strong)IBOutlet UIScrollView * scroll;

@property(nonatomic,strong)IBOutlet UIView * contentScroll;

@property(nonatomic,strong)IBOutlet UILabel * lblDescription;

@property(nonatomic,strong)IBOutlet UIImageView * imgTshirt;

@property(nonatomic,strong)IBOutlet UIActivityIndicatorView * indicatorHeader;

@property(nonatomic,strong)NSMutableDictionary * data;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
