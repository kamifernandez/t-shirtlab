//
//  MisPedidosViewController.m
//  T-ShirtLab
//
//  Created by Christian Fernandez on 3/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "MisPedidosViewController.h"
#import "DetalleMisPedidosViewController.h"

@interface MisPedidosViewController (){
    int tag;
}

@end

@implementation MisPedidosViewController

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
    for (int i = 0; i<10; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"2x0y9z6" forKey:@"numero"];
            [dataInsert setObject:@"25/Dic/2016" forKey:@"fecha"];
            [dataInsert setObject:@"Aprobado" forKey:@"estado"];
            [dataInsert setObject:@"$816.600" forKey:@"total"];
        }else{
            [dataInsert setObject:@"w38zdnr" forKey:@"numero"];
            [dataInsert setObject:@"25/Dic/2016" forKey:@"fecha"];
            [dataInsert setObject:@"Pendiente" forKey:@"estado"];
            [dataInsert setObject:@"$116.600" forKey:@"total"];
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    //[[NSBundle mainBundle] loadNibNamed:@"HeaderMisPedidos" owner:self options:nil];
    //self.tblPedidos.tableHeaderView = self.viewHeader;
    [self.tblPedidos reloadData];
}

#pragma mark IBActions

-(IBAction)backButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)eliminarRegistro:(id)sender{
    tag = (int)[sender tag];
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Eliminar Dirección" forKey:@"Title"];
    [msgDict setValue:@"¿Esta seguro que desea eliminar este pedido?" forKey:@"Message"];
    [msgDict setValue:@"Si" forKey:@"Aceptar"];
    [msgDict setValue:@"No" forKey:@"Cancel"];
    [msgDict setValue:@"101" forKey:@"Tag"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
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
    static NSString *CellIdentifier = @"CellMisPedidos";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CellMisPedidos" owner:self options:nil];
        cell = _CellMisPedidos;
        self.CellMisPedidos = nil;
    }
    
    [self.lblNumero setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"numero"]];
    
    [self.lblFecha setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"fecha"]];
    
    [self.lblEstado setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"estado"]];
    
    [self.lblTotal setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"total"]];
    
    [self.btnBorrar setTag:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetalleMisPedidosViewController *detalleMisPedidosViewController = [story instantiateViewControllerWithIdentifier:@"DetalleMisPedidosViewController"];
    [self.navigationController pushViewController:detalleMisPedidosViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 67;
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
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]) {
                                            [self.data removeObjectAtIndex:tag];
                                            if ([self.data count]>0) {
                                                [self.tblPedidos reloadData];
                                            }else{
                                                [self.tblPedidos setHidden:TRUE];
                                                [self.viewHeader setHidden:TRUE];
                                            }
                                        }
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
