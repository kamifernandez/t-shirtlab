//
//  PresentacionViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 15/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "PresentacionViewController.h"
#import "PresentacionCollectionViewCell.h"
#import "RequestUrl.h"

@interface PresentacionViewController ()

@end

@implementation PresentacionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    
    [self.btnNext setTransform:CGAffineTransformMakeRotation(M_PI)];
    //[self requestServerObtenerBanners];
    /*+++++Harcode+++++++*/
    _data = [[NSMutableArray alloc] init];
    for (int i = 0; i<4; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        if (i == 0) {
            [dataInsert setObject:@"slide1@3x.png" forKey:@"imagen"];
            [dataInsert setObject:@"Escoge tu producto" forKey:@"descripcion"];
        }else if(i == 1){
            [dataInsert setObject:@"slide2@3x.png" forKey:@"imagen"];
            [dataInsert setObject:@"Escoge tamaño y ubicación del estampado" forKey:@"descripcion"];
        }else if(i == 2){
            [dataInsert setObject:@"slide3@3x.png" forKey:@"imagen"];
            [dataInsert setObject:@"Escoge la cantidad y tallas de los productos que quieres pedir" forKey:@"descripcion"];
        }else if(i == 3){
            [dataInsert setObject:@"slide4@3x.png" forKey:@"imagen"];
            [dataInsert setObject:@"Sube tu imagen" forKey:@"descripcion"];
        }else if(i == 4){
            [dataInsert setObject:@"slide5@3x.png" forKey:@"imagen"];
            [dataInsert setObject:@"Confirma tu pedido" forKey:@"descripcion"];
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    self.pageCollection.numberOfPages = [_data count];
    [self.collection reloadData];
}

#pragma mark - IBActions

-(IBAction)nextButton:(id)sender{
    NSArray *visibleItems = [self.collection indexPathsForVisibleItems];
    NSIndexPath *currentItem = [visibleItems objectAtIndex:0];
    if (currentItem.item != ([_data count] - 1)) {
        NSIndexPath *nextItem = [NSIndexPath indexPathForItem:currentItem.item + 1 inSection:currentItem.section];
        [self.collection scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        CGFloat pageWidth = self.collection.frame.size.width;
        self.pageCollection.currentPage = self.collection.contentOffset.x / pageWidth + 1;
    }
}

-(IBAction)backButton:(id)sender{
    NSArray *visibleItems = [self.collection indexPathsForVisibleItems];
    NSIndexPath *currentItem = [visibleItems objectAtIndex:0];
    NSIndexPath *nextItem = [NSIndexPath indexPathForItem:currentItem.item - 1 inSection:currentItem.section];
    if (currentItem.item != 0) {
        [self.collection scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        CGFloat pageWidth = self.collection.frame.size.width;
        self.pageCollection.currentPage = self.collection.contentOffset.x / pageWidth - 1;
    }
}

-(IBAction)tempBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CollectionView Delegates


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PresentacionCollectionViewCell";
    
    PresentacionCollectionViewCell *cell = (PresentacionCollectionViewCell *)[self.collection dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    /*NSString * urlEnvio = [[self.data objectAtIndex:indexPath.row] objectForKey: @"logo"];
    if ([urlEnvio isEqualToString:@""]) {
        [cell.indicador stopAnimating];
        [cell.imgTshirt setFrame:CGRectMake(cell.imgTshirt.frame.origin.x, cell.imgTshirt.frame.origin.y - 15, cell.imgTshirt.frame.size.width, cell.imgTshirt.frame.size.height)];
    }else{
        NSURL *imageURL = [NSURL URLWithString:urlEnvio];
        NSString *key = [[[self.data objectAtIndex:indexPath.row] objectForKey: @"logo"] MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            [cell.indicador stopAnimating];
            UIImage *image = [UIImage imageWithData:data];
            cell.imgTshirt.image = image;
        } else {
            //imagen.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [cell.indicador stopAnimating];
                    cell.imgTshirt.image = image;
                });
            });
        }
    }*/
    
    cell.imgTshirt.image = [UIImage imageNamed:[[self.data objectAtIndex:indexPath.row] objectForKey: @"imagen"]];
    
    cell.imgTshirt.contentMode = UIViewContentModeScaleAspectFill;
    
    [cell.imgTshirt.layer setMasksToBounds:YES];
    
    cell.lblDescription.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"descripcion"];
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collection.frame.size.width, self.collection.frame.size.height);
}

#pragma mark - ScrollView Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collection.frame.size.width;
    self.pageCollection.currentPage = self.collection.contentOffset.x / pageWidth;
}

#pragma mark - WebServices
#pragma mark - Obtener Banners

-(void)requestServerObtenerBanners{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerObtenerBanners) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerObtenerBanners{

    _data = [RequestUrl obtenerBanners];
    [self performSelectorOnMainThread:@selector(ocultarCargandoObtenerBanners) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoObtenerBanners{
    if ([_data count]>0) {
        self.pageCollection.numberOfPages = [_data count];
        [self.collection reloadData];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene información para mostrar" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - Metodos Vista Cargando

-(void)mostrarCargando{
    @autoreleasepool {
        if (_vistaWait.hidden == TRUE) {
            _vistaWait.hidden = FALSE;
            CALayer * l = [_vistaWait layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10.0];
            // You can even add a border
            [l setBorderWidth:1.5];
            [l setBorderColor:[[UIColor whiteColor] CGColor]];
            
            [_indicador startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicador stopAnimating];
        }
    }
}

#pragma mark - showAlert metodo

-(void)showAlert:(NSMutableDictionary *)msgDict
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[msgDict objectForKey:@"Title"]
                                 message:[msgDict objectForKey:@"Message"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    if ([[msgDict objectForKey:@"Cancel"] length]>0) {
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[msgDict objectForKey:@"Cancel"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
    }else{
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
