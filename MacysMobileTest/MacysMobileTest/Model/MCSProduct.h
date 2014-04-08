//
//  MCSProduct.h
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCSProduct : NSObject

@property uint64_t productId;
@property NSString *productName;
@property NSString *productDescription;
@property int64_t productPrice;
@property int64_t productSalePrice;
@property UIImage *productPhoto;
@property NSArray *productColors;
@property NSDictionary *productStores;
@property NSString *productPhotoName;

@end
