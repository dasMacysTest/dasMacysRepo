//
//  MCSProductStore.h
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class MCSProduct;

@interface MCSProductStore : NSObject
{
    sqlite3 *productsDatabase;
}

/**
 Loads a product with the passed in ID.
 @param productId The productId of the product to load.
 @returns YES if the product was successfully loaded, otherwise NO. Returns NO if the productID has already been loaded.
 */
- (BOOL)loadProductWithId:(uint64_t)productId;

/**
 Removes the product with the passed in ID from the database.
 @param productId The productId of the product to unload.
 */
- (void)removeProductWithId:(uint64_t)productId;

/**
 Returns an MCSProduct * object with the passed in ID.
 @param productId The productId of the product to return.
 @returns an MCSProduct * created from the database. Returns nil if no productId exists.
 */
- (MCSProduct*)getProductWithId:(uint64_t)productId;

/**
 Returns an MCSProduct * object at the row passed in by index.
 @param index The row of the product to return.
 @returns an MCSProduct * created from the database. Returns nil if no row exists.
 */
- (MCSProduct*)getProductAtIndex:(NSInteger)index;

/**
 UPDATEs an existing product in the database.
 @param product The product with properties that need to be saved.
 */
- (void)saveProduct:(MCSProduct*)product;

/**
 Gets all MCSProduct * objects in the database.
 @returns an Dictionary of MCSProduct * keyed by productId.
 */
- (NSDictionary*)getAllProducts;

/**
 Returns the number of products in the serialized JSON file.
 @returns the number of products in the serialized JSON file.
 */
- (NSInteger)serializedProductCount;

/**
 Creates & returns a list of all productIds in the serialized JSON file.
 @returns a list of NSNumber * objects containing all productIds in the serialized JSON file.
 */
- (NSArray*)serializedProductIds;

/**
 Returns the number of products in the database.
 @returns the number of products in the database.
 */
- (NSInteger)productCount;

/**
 Creates & returns a list of all productIds in the database.
 @returns a list of NSNumber * objects containing all productIds in the database.
 */
- (NSArray*)productIds;
@end
