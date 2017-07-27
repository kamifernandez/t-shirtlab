//
//  ProductosViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 6/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductosViewController : UIViewController <UIGestureRecognizerDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tblProducts;
@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;

@property (nonatomic,retain) IBOutlet UIView * viewStore;

@property (nonatomic,retain) IBOutlet UIView * viewCar;

@property (nonatomic,retain) IBOutlet UIButton * btnBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthBackButtonConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthViewStoreConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthViewCarConstraint;

// SearchTabBar

@property (nonatomic,retain) IBOutlet UIView * viewSearch;
@property (nonatomic,retain) IBOutlet UIView * viewContentSearch;
@property (nonatomic,retain) IBOutlet UITableView * tblSearch;
@property (nonatomic,retain) IBOutlet UISearchBar * search;

@property (nonatomic,retain) IBOutlet UIView * conteinerView;

@property(nonatomic,strong)NSMutableArray * dataSearch;

// Celda Tabla

@property (nonatomic,retain) IBOutlet UIView * viewBack;
@property (nonatomic,retain) IBOutlet UIImageView * imgBanner;

// Namutable array

@property(nonatomic,strong)NSMutableArray * data;

// Vista Mi cuenta

@property (nonatomic,retain) IBOutlet UIView * vistaCuenta;

@property (nonatomic,retain) IBOutlet UIView * vistaContentCuenta;

// Vista Sedes y Mas

@property (nonatomic,retain) IBOutlet UIView * vistaSedesMas;

@property (nonatomic,retain) IBOutlet UIView * vistaContentSedesMas;

@end
