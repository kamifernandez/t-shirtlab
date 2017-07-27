//
//  SearchCollectionViewCell.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 27/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UIImageView * imgTshirt;

@property (nonatomic, retain) IBOutlet UILabel * lblDescription;

@property (nonatomic, retain) IBOutlet UILabel * lblPrice;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * indicador;

@end
