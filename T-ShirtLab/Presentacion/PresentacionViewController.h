//
//  PresentacionViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 15/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface PresentacionViewController : UIViewController

@property(nonatomic,weak)IBOutlet UICollectionView * collection;

@property(nonatomic,weak)IBOutlet UIPageControl * pageCollection;

@property(nonatomic,weak)IBOutlet UIButton * btnNext;

@property(nonatomic,strong)NSMutableArray * data;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
