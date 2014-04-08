//
//  MCSCreateProductsViewController.h
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSViewControllerInterface.h"

@class MCSLoadProductsWithButtonsViewController;
@class MCSLoadProductsTableViewController;

@interface MCSCreateProductsViewController : UITabBarController<MCSViewControllerInterface>

@property MCSLoadProductsWithButtonsViewController *viewControllerLoadButtons;
@property MCSLoadProductsTableViewController *viewControllerLoadTableView;

@end
