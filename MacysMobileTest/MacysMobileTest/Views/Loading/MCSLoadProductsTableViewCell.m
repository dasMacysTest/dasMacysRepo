//
//  MCSLoadProductsTableViewCell.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/7/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSLoadProductsTableViewCell.h"
#import "MCSLoadProductsTableViewController.h"

@implementation MCSLoadProductsTableViewCell
@synthesize loadProductButton;
@synthesize productId;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
