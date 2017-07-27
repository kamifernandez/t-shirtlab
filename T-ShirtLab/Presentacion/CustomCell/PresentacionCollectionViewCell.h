//
//  PresentacionCollectionViewCell.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 15/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentacionCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UIImageView * imgTshirt;

@property (nonatomic, retain) IBOutlet UILabel * lblDescription;

@property(nonatomic,weak)IBOutlet UIActivityIndicatorView * indicador;

@end
