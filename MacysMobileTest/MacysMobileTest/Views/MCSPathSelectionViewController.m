//
//  MCSPathSelectionViewController.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSPathSelectionViewController.h"
#import "MCSCreateProductsViewController.h"
#import "MCSProductListViewController.h"

@interface MCSPathSelectionViewController ()

@end

@implementation MCSPathSelectionViewController
@synthesize buttonCreateProducts;
@synthesize buttonShowProducts;
@synthesize productStore;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productStore:(MCSProductStore*)store;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.productStore = store;
        self.title = @"Choose Your Path";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark – IBActions

- (IBAction)touchShowProducts:(id)sender
{
    MCSProductListViewController *listProductsViewController = [[MCSProductListViewController alloc] initWithNibName:nil bundle:nil productStore:self.productStore];
    [self.navigationController pushViewController:listProductsViewController animated:YES];
}

- (IBAction)touchCreateProducts:(id)sender
{
    MCSCreateProductsViewController *createProductsViewController = [[MCSCreateProductsViewController alloc] initWithNibName:nil bundle:nil productStore:self.productStore];
    [self.navigationController pushViewController:createProductsViewController animated:YES];
}

#pragma mark – MCSViewControllerInterface

//- (void)setProductStore:(MCSProductStore *)pStore
//{
//    self.productStore = pStore;
//}

@end
