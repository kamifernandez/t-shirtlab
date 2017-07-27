//
//  MetodosPagoViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 30/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetodosPagoViewController : UIViewController

@property(nonatomic,strong)IBOutlet UIScrollView * scroll;

@property(nonatomic,strong)IBOutlet UIView * viewContentFinal;

@property(nonatomic,strong)IBOutlet UIView * viewContentAll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthViewContentAllConstraint;

@end
