//
//  DetalleNovedadesViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 16/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface DetalleNovedadesViewController : UIViewController

@property(nonatomic,strong)IBOutlet UIScrollView * scroll;

@property(nonatomic,strong)IBOutlet UIView * contentScroll;

@property(nonatomic,strong)IBOutlet UIImageView * imgHeader;

@property(nonatomic,strong)IBOutlet UIImageView * imgDetail;

@property(nonatomic,strong)IBOutlet UILabel * lblTitulo;

@property(nonatomic,strong)IBOutlet UILabel * lblDescription;

@property(nonatomic,strong)IBOutlet UIActivityIndicatorView * indicatorHeader;

@property(nonatomic,strong)IBOutlet UIActivityIndicatorView * indicatorDescription;

@property(nonatomic,strong)NSMutableDictionary * data;

@end
