//
//  MCSLoadProductsTable.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/7/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSLoadProductsTableViewController.h"
#import "MCSLoadProductsTableViewCell.h"
#import "MCSProductStore.h"

@implementation MCSLoadProductsTableViewController
@synthesize productStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productStore:(MCSProductStore *)store
{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        self.productStore = store;
        self.title = @"Load from Table";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib* nib = [UINib nibWithNibName:@"MCSLoadProductsTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MCSLoadProductsTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark – Private Interface

- (uint64_t)unloadedProductIdAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *loadedProducts = [productStore productIds];
    NSMutableArray *serializedProducts = (NSMutableArray *)[productStore serializedProductIds];
    for(NSNumber *productId in loadedProducts)
    {
        [serializedProducts removeObject:productId];
    }

    return [[serializedProducts objectAtIndex:indexPath.row] unsignedLongLongValue];
}

#pragma mark – UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productStore serializedProductCount] - [self.productStore productCount];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MCSLoadProductsTableViewCell";
    
    uint64_t productId = [self unloadedProductIdAtIndexPath:indexPath];
    MCSLoadProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.productId = productId;
    [cell.loadProductButton setTitle:[NSString stringWithFormat:@"Load Product %llu", productId] forState:UIControlStateNormal];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MCSLoadProductsTableViewCell";
    
    MCSLoadProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return CGRectGetHeight(cell.frame);
}

#pragma mark – UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    uint64_t productId = [self unloadedProductIdAtIndexPath:indexPath];
    [self.productStore loadProductWithId:productId];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
