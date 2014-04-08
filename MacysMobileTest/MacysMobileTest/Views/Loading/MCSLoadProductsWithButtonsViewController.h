//
//  MCSLoadProductsWithButtonsViewController.h
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSViewControllerInterface.h"

@interface MCSLoadProductsWithButtonsViewController : UIViewController<MCSViewControllerInterface>

@property (weak) IBOutlet UIButton *buttonCreateProduct1;
@property (weak) IBOutlet UIButton *buttonCreateProduct2;
@property (weak) IBOutlet UIButton *buttonCreateProduct3;
@property (weak) IBOutlet UIButton *buttonCreateAllProducts;
@property (weak) IBOutlet UIButton *buttonDeleteAllProducts;

- (IBAction)productButton1Touched:(id)sender;
- (IBAction)productButton2Touched:(id)sender;
- (IBAction)productButton3Touched:(id)sender;
- (IBAction)productButtonCreateAllTouched:(id)sender;
- (IBAction)productButtonDeleteAllTouched:(id)sender;

@end
