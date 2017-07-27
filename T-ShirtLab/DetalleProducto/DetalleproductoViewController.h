//
//  DetalleproductoViewController.h
//  T-ShirtLab
//
//  Created by Christian Fernandez on 5/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface DetalleproductoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIToolbar *keyboardDoneButtonView;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *negativeSeparator;
}

@property(nonatomic,weak)IBOutlet UIView * viewStepsNumber1;

@property(nonatomic,weak)IBOutlet UIView * viewStepsNumber2;

@property(nonatomic,weak)IBOutlet UIView * viewStepsNumber3;

@property(nonatomic,weak)IBOutlet UILabel * lblUnidad;

@property(nonatomic,weak)IBOutlet UILabel * lblTotal;

@property(nonatomic,weak)IBOutlet UITextField * txtTotalBottom;

@property(nonatomic,weak)UITextField * txtSelected;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,weak)IBOutlet UIScrollView * scroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContentViewScrollConstraint;

//Vier Header

@property (nonatomic, weak) IBOutlet UIView *viewCollection;

//CollectionView

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray* dataCollection;

@property(nonatomic,weak)IBOutlet UIPageControl * pageCollection;

//UITableView

@property (nonatomic, weak) IBOutlet UITableView *tblEstampados;

@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;

@property (nonatomic, strong)NSMutableArray* data;

// Celda

@property (nonatomic, weak) IBOutlet UIButton *btn1;

@property (nonatomic, weak) IBOutlet UIButton *btn2;

@property (nonatomic, weak) IBOutlet UIButton *btn3;

@property (nonatomic, weak) IBOutlet UIButton *btn4;

@property (nonatomic, weak) IBOutlet UIButton *btn5;

@property (nonatomic, weak) IBOutlet UIButton *btn6;

@property (nonatomic, weak) IBOutlet UIImageView *img1;

@property (nonatomic, weak) IBOutlet UIImageView *img2;

@property (nonatomic, weak) IBOutlet UIImageView *img3;

@property (nonatomic, weak) IBOutlet UIImageView *img4;

@property (nonatomic, weak) IBOutlet UIImageView *img5;

@property (nonatomic, weak) IBOutlet UIImageView *img6;

@property (nonatomic, weak)IBOutlet UILabel *lblTituloTamanoEstampado;

@property (nonatomic, strong)UIView *viewInformacionEstampado;

@property (nonatomic, weak)IBOutlet UIButton *btnInformacionEstampado;

@property (nonatomic, strong)UIView *viewInformacionProducto;

@property (nonatomic, weak)IBOutlet UIButton *btnInformacionProducto;

/// Constarints

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthFirsStepConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ladingViewStepOneConstraint;

// Footer

@property (nonatomic, weak) IBOutlet UIView *viewFooter;

@property (nonatomic, weak) IBOutlet UIView *viewLineaSeparadora;

@property (weak, nonatomic) IBOutlet UITextField *txtTallaSPrenda;
@property (weak, nonatomic) IBOutlet UITextField *txtTallaMPrenda;
@property (weak, nonatomic) IBOutlet UITextField *txtTallaLPrenda;
@property (weak, nonatomic) IBOutlet UITextField *txtTallaXlPrenda;
@property (weak, nonatomic) IBOutlet UITextField *txtTallaTotalPrenda;


@property (weak, nonatomic) IBOutlet UIView *viewContentTallas;
@property (weak, nonatomic) IBOutlet UIView *viewTallaSPrenda;
@property (weak, nonatomic) IBOutlet UIView *viewTallaMPrenda;
@property (weak, nonatomic) IBOutlet UIView *viewTallaLPrenda;
@property (weak, nonatomic) IBOutlet UIView *viewTallaXlPrenda;
@property (weak, nonatomic) IBOutlet UIView *viewTallaTotalPrenda;

@property (weak, nonatomic) IBOutlet UIView *viewPrecioUnitario;

@property (weak, nonatomic) IBOutlet UIView *viewPrecioTotal;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollFoto;

@property (weak, nonatomic) IBOutlet UIView *viewFoto1;

@property (weak, nonatomic) IBOutlet UIButton *btnFoto1;

@property (weak, nonatomic) IBOutlet UIImageView *imgFoto1;

@property (weak, nonatomic) IBOutlet UIView *viewFoto2;

@property (weak, nonatomic) IBOutlet UIButton *btnFoto2;

@property (weak, nonatomic) IBOutlet UIImageView *imgFoto2;

@property (weak, nonatomic) IBOutlet UIView *viewFoto3;

@property (weak, nonatomic) IBOutlet UIButton *btnFoto3;

@property (weak, nonatomic) IBOutlet UIImageView *imgFoto3;

@property (weak, nonatomic) IBOutlet UIView *viewFoto4;

@property (weak, nonatomic) IBOutlet UIButton *btnFoto4;

@property (weak, nonatomic) IBOutlet UIImageView *imgFoto4;

@property (weak, nonatomic) IBOutlet UIView *viewFoto5;

@property (weak, nonatomic) IBOutlet UIButton *btnFoto5;

@property (weak, nonatomic) IBOutlet UIImageView *imgFoto5;

@property (weak, nonatomic) IBOutlet UIButton *btnFlecha;

@property (weak, nonatomic) IBOutlet UIButton *btnFlechaBack;

@property (weak, nonatomic) UIView *viewUltimaFoto;

@end
