//
//  MCSLoadProductsWithButtonsViewController.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSLoadProductsWithButtonsViewController.h"
#import "MCSProductStore.h"

@interface MCSLoadProductsWithButtonsViewController ()

@end

@implementation MCSLoadProductsWithButtonsViewController
@synthesize buttonCreateProduct1;
@synthesize buttonCreateProduct2;
@synthesize buttonCreateProduct3;
@synthesize buttonCreateAllProducts;
@synthesize buttonDeleteAllProducts;
@synthesize productStore;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productStore:(MCSProductStore*)store;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.productStore = store;
        self.title = @"Load w/Buttons";
    }
    return self;
}

#pragma mark – View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetUI];
}

#pragma mark – IBActions

- (IBAction)productButton1Touched:(id)sender
{
    if([productStore loadProductWithId:0]){
        [buttonCreateProduct1 setEnabled:NO];
        [self resetUI];
    }
}

- (IBAction)productButton2Touched:(id)sender
{
    if([productStore loadProductWithId:1]){
        [buttonCreateProduct2 setEnabled:NO];
        [self resetUI];
    }
}

- (IBAction)productButton3Touched:(id)sender
{
    if([productStore loadProductWithId:2]){
        [buttonCreateProduct3 setEnabled:NO];
        [self resetUI];
    }
}

- (IBAction)productButtonCreateAllTouched:(id)sender
{
    for(int i = 0; i<3; i++){
        [productStore loadProductWithId:i];
    }
    
    [self resetUI];
}

- (IBAction)productButtonDeleteAllTouched:(id)sender
{
    for(int i = 0; i<3; i++){
        [productStore removeProductWithId:i];
    }
    
    [self resetUI];
}

#pragma mark – MCSViewControllerInterface

//- (void)setProductStore:(MCSProductStore *)pStore
//{
//    self.productStore = pStore;
//}

#pragma mark – Private Interface

- (void)resetUI
{
    NSArray *loadedProductIds = [productStore productIds];
    BOOL allItemsLoaded = YES;
    BOOL anyItemLoaded = NO;
    
    if([loadedProductIds containsObject:[NSNumber numberWithUnsignedLongLong:0]]){
        [buttonCreateProduct1 setEnabled:NO];
        anyItemLoaded |= YES;
    }
    else{
        [buttonCreateProduct1 setEnabled:YES];
        allItemsLoaded &= NO;
    }
    
    if([loadedProductIds containsObject:[NSNumber numberWithUnsignedLongLong:1]]){
        [buttonCreateProduct2 setEnabled:NO];
        anyItemLoaded |= YES;
    }
    else{
        [buttonCreateProduct2 setEnabled:YES];
        allItemsLoaded &= NO;
    }
    
    if([loadedProductIds containsObject:[NSNumber numberWithUnsignedLongLong:2]]){
        [buttonCreateProduct3 setEnabled:NO];
        anyItemLoaded |= YES;
    }
    else{
        [buttonCreateProduct3 setEnabled:YES];
        allItemsLoaded &= NO;
    }
    
    [buttonCreateAllProducts setEnabled:!allItemsLoaded];
    [buttonDeleteAllProducts setEnabled:anyItemLoaded];
}


@end
