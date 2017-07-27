//
//  SearchViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 27/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionViewCell.h"
#import "SedesViewController.h"
#import "DetalleproductoViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(back)
                                                 name:@"BackNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backRoot)
                                                 name:@"BackNotificationRoot"
                                               object:nil];
    
    [self.viewStepsNumber1.layer setCornerRadius:5.0];
    [self.viewStepsNumber2.layer setCornerRadius:5.0];
    [self.viewStepsNumber3.layer setCornerRadius:5.0];
    
    if (([[UIScreen mainScreen] bounds].size.width == 320)) {
        self.widthFirsStepConstraint.constant = 110;
        self.ladingViewStepOneConstraint.constant = 5;
        [self.view layoutIfNeeded];
    }
    
    /*+++++Harcode+++++++*/
    _data = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"http://t-shirtlab.com/images/retohome.jpg" forKey:@"logo"];
            [dataInsert setObject:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vulputate quis justo eu lacinia. Donec condimentum mattis sollicitudin. Sed rhoncus neque" forKey:@"descripcion"];
        }else{
            [dataInsert setObject:@"http://t-shirtlab.com/images/retohome.jpg" forKey:@"logo"];
            [dataInsert setObject:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit." forKey:@"descripcion"];
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    [self.collection reloadData];
    
    /// Steps View Content Heigth
    
    if ([self.pantalla isEqualToString:@"1"]) {
        self.heigthViewStepsConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - CollectionView Delegates


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SearchCollectionViewCell";
    
    SearchCollectionViewCell *cell = (SearchCollectionViewCell *)[self.collection dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString * urlEnvio = [[self.data objectAtIndex:indexPath.row] objectForKey: @"logo"];
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
    }
    
    //cell.imgComerce.image = [UIImage imageNamed:[[self.data objectAtIndex:indexPath.row] objectForKey: @"imagen"]];
    
    cell.imgTshirt.contentMode = UIViewContentModeScaleAspectFill;
    
    [cell.imgTshirt.layer setMasksToBounds:YES];
    
    cell.lblDescription.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"descripcion"];
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* userInfo = @{@"step": @"2"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaberStepNotification" object:userInfo];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetalleproductoViewController *detalleproductoViewController = [story instantiateViewControllerWithIdentifier:@"DetalleproductoViewController"];
    //UIViewController *parentVC = self.parentViewController;
    [self.navigationController pushViewController:detalleproductoViewController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(140, 243);
}

-(void)reloadData{
    //[self configurerView];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SedesViewController *vc = [story instantiateViewControllerWithIdentifier:@"SedesViewController"];
    //UIViewController *parentVC = self.parentViewController;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
