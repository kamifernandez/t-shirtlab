//
//  DetalleMisPedidosViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 3/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "DetalleMisPedidosViewController.h"

@interface DetalleMisPedidosViewController ()

@end

@implementation DetalleMisPedidosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    /*+++++Harcode+++++++*/
    _data = [[NSMutableArray alloc] init];
    for (int i = 0; i<4; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"12" forKey:@"cantidad"];
            [dataInsert setObject:@"GOUN00BL" forKey:@"sku"];
            [dataInsert setObject:@"Cachucha WOW Bicolor Negro" forKey:@"articulo"];
            [dataInsert setObject:@"25.000" forKey:@"vunidad"];
            [dataInsert setObject:@"300.000" forKey:@"total"];
        }else{
            [dataInsert setObject:@"2" forKey:@"cantidad"];
            [dataInsert setObject:@"" forKey:@"sku"];
            [dataInsert setObject:@"10.000" forKey:@"vunidad"];
            [dataInsert setObject:@"Mini mug est. izquierda" forKey:@"articulo"];
            [dataInsert setObject:@"20.000" forKey:@"total"];
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    [[NSBundle mainBundle] loadNibNamed:@"HeaderDetalleMisPedidos" owner:self options:nil];
    self.tblDetallePedidos.tableHeaderView = self.viewDetallePedidos;
    
    [[NSBundle mainBundle] loadNibNamed:@"FooterDatalleMisPedidos" owner:self options:nil];
    self.tblDetallePedidos.tableFooterView = self.viewFooter;
    [self.btnVolver.layer setCornerRadius:5.0];
    [self.tblDetallePedidos reloadData];
}

#pragma mark IBActions

-(IBAction)backButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"CeldaDetalleMisPedidos";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CeldaDetalleMisPedidos" owner:self options:nil];
        cell = _CellDetalleMisPedidos;
        self.CellDetalleMisPedidos = nil;
    }
    
    [self.lblCantidad setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"cantidad"]];
    
    [self.lblSku setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"sku"]];
    
    [self.lblArticulo setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"articulo"]];
    
    [self.lblPrecioUnidad setText:[NSString stringWithFormat:@"$%@",[[_data objectAtIndex:indexPath.row] objectForKey:@"vunidad"]]];
    
    [self.lblPrecioTotal setText:[NSString stringWithFormat:@"$%@",[[_data objectAtIndex:indexPath.row] objectForKey:@"total"]]];
    
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 229;
}

@end
