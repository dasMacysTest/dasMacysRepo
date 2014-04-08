//
//  MCSPathSelectionViewController.h
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSViewControllerInterface.h"

@interface MCSPathSelectionViewController : UIViewController<MCSViewControllerInterface>

@property (weak) IBOutlet UIButton* buttonShowProducts;
@property (weak) IBOutlet UIButton* buttonCreateProducts;

- (IBAction)touchShowProducts:(id)sender;
- (IBAction)touchCreateProducts:(id)sender;

@end
