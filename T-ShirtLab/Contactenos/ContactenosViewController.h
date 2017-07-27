//
//  ContactenosViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 16/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactenosViewController : UIViewController

@property(nonatomic,strong)IBOutlet UIScrollView * scroll;

@property(nonatomic,strong)IBOutlet UIView * contentScroll;

@property(nonatomic,strong)IBOutlet UIView * contentScrollContact;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,weak)IBOutlet UITextField * txtCity;

@property(nonatomic,weak)IBOutlet UITextView * tvMenssage;

/// HardCode

@property(nonatomic,strong)NSMutableArray * data;

//View Picker

@property(nonatomic,weak)IBOutlet UIView * vistaPicker;
@property(nonatomic,weak)IBOutlet UIView * vistaContentPicker;

@property(nonatomic,weak)IBOutlet UIPickerView * pickerView;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
