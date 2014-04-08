//
//  MCSProduct.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSProduct.h"

@implementation MCSProduct
@synthesize productId;
@synthesize productName;
@synthesize productDescription;
@synthesize productPrice;
@synthesize productSalePrice;
@synthesize productPhoto;
@synthesize productColors;
@synthesize productStores;
@synthesize productPhotoName;

- (NSString*)description
{
    NSMutableString *descriptionString = [[NSMutableString alloc] initWithString:@"MCSProduct:\n"];
    [descriptionString appendFormat:@"productId : %llu\n", productId];
    [descriptionString appendFormat:@"productName : %@", productName];
    
    return descriptionString;
}

@end
