//
//  MCSCreateProductsViewController.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSCreateProductsViewController.h"
#import "MCSLoadProductsWithButtonsViewController.h"
#import "MCSLoadProductsTableViewController.h"

@interface MCSCreateProductsViewController ()

@end

@implementation MCSCreateProductsViewController
@synthesize productStore;
@synthesize viewControllerLoadTableView;
@synthesize viewControllerLoadButtons;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productStore:(MCSProductStore*)store;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.productStore = store;
        viewControllerLoadButtons = [[MCSLoadProductsWithButtonsViewController alloc] initWithNibName:nil bundle:nil productStore:self.productStore];
        viewControllerLoadTableView = [[MCSLoadProductsTableViewController alloc] initWithNibName:nil bundle:nil productStore:self.productStore];
        self.viewControllers = @[viewControllerLoadTableView, viewControllerLoadButtons];
        
        self.title = @"Choose Loading Style";
        self.tabBar.barStyle = UIBarStyleBlack;
    }
    return self;
}

@end
