//
//  SearchViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 27/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface SearchViewController : UIViewController

@property(nonatomic,weak)IBOutlet UICollectionView * collection;

@property(nonatomic,strong)NSString * pantalla;

@property(nonatomic,strong)NSMutableArray * data;

// View Content Steps

@property(nonatomic,weak)IBOutlet UIView * viewSteps;

@property(nonatomic,weak)IBOutlet UIView * viewStepsNumber1;

@property(nonatomic,weak)IBOutlet UIView * viewStepsNumber2;

@property(nonatomic,weak)IBOutlet UIView * viewStepsNumber3;

// Constraints

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthFirsStepConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthViewStepsConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ladingViewStepOneConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ladingViewStepTwoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ladingViewStepThreeConstraint;

@end
