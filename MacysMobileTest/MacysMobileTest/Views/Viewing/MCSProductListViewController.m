//
//  MCSProductListViewController.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/6/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSProductListViewController.h"
#import "MCSProduct.h"
#import "MCSProductStore.h"
#import "MCSProductViewController.h"

@implementation MCSProductListViewController
@synthesize productStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productStore:(MCSProductStore *)store{
    
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        self.productStore = store;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    
    return self;
}

#pragma mark – View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark – UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [productStore productCount];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    MCSProduct *product = [productStore getProductAtIndex:indexPath.row];
    if(product){
        [cell.textLabel setText:product.productName];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return cell;
}

#pragma mark – UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCSProduct *product = [productStore getProductAtIndex:indexPath.row];
    MCSProductViewController *productController = [[MCSProductViewController alloc] initWithProduct:product productStore:self.productStore];
    [self.navigationController pushViewController:productController animated:YES];
}

@end
