//
//  MCSLoadProductsTableViewCell.h
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/7/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCSLoadProductsTableViewController;
@interface MCSLoadProductsTableViewCell : UITableViewCell

@property (weak) IBOutlet UIButton *loadProductButton;
@property int productId;

@end
