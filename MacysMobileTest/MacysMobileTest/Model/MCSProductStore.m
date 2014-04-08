//
//  MCSProductStore.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSProductStore.h"
#import "MCSProduct.h"
#import "MCSDatabaseProperty.h"

@interface MCSProductStore()

@property (nonatomic, strong) NSArray *productsTableDatabaseProperties;
@property (nonatomic, strong) NSArray *colorsTableDatabaseProperties;
@end

@implementation MCSProductStore
@synthesize productsTableDatabaseProperties;
@synthesize colorsTableDatabaseProperties;

#pragma mark – constants

static NSString * const PRODUCTS_TABLE = @"PRODUCTS_TABLE";
static NSString * const COLORS_TABLE = @"COLORS_TABLE";
static NSString * const RETAIL_LOCATIONS_TABLE = @"RETAIL_LOCATIONS_TABLE";

static NSString * const PRODUCTS_JSON_FILE = @"MacysProductStore";

#pragma mark – Init & Dealloc

- (void)dealloc{
    sqlite3_close(productsDatabase);
    
    // call to super would go here. Disallowed with ARC enabled.
    //[super dealloc]
}

- (id)init{
    self = [super init];
    if(self){
        int dbOpenSuccess = sqlite3_open(":memory:", &productsDatabase);
        assert(dbOpenSuccess == SQLITE_OK);
        
        MCSDatabaseProperty *idProperty = [[MCSDatabaseProperty alloc] initWithTitle:@"productId" constraint:@"PRIMARY KEY" type:MCSPropertyTypeInteger];
        MCSDatabaseProperty *nameProperty = [[MCSDatabaseProperty alloc] initWithTitle:@"productName" constraint:nil type:MCSPropertyTypeString];
        MCSDatabaseProperty *descriptionProperty = [[MCSDatabaseProperty alloc] initWithTitle:@"productDescription" constraint:nil type:MCSPropertyTypeString];
        MCSDatabaseProperty *priceProperty = [[MCSDatabaseProperty alloc] initWithTitle:@"productPrice" constraint:nil type:MCSPropertyTypeInteger];
        MCSDatabaseProperty *salePriceProperty = [[MCSDatabaseProperty alloc] initWithTitle:@"productSalePrice" constraint:nil type:MCSPropertyTypeInteger];
        MCSDatabaseProperty *productPhotoNameProperty = [[MCSDatabaseProperty alloc] initWithTitle:@"productPhotoName" constraint:nil type:MCSPropertyTypeString];
        productsTableDatabaseProperties = @[idProperty,
                                             nameProperty,
                                             descriptionProperty,
                                             priceProperty,
                                             salePriceProperty,
                                             productPhotoNameProperty];
        
        MCSDatabaseProperty *productColorIdProperty = [[MCSDatabaseProperty alloc] initWithTitle:@"productId" constraint:nil type:MCSPropertyTypeInteger];
        MCSDatabaseProperty *redProperty = [[MCSDatabaseProperty alloc] initWithTitle:@"red" constraint:nil type:MCSPropertyTypeDouble];
        MCSDatabaseProperty *greenProperty = [[MCSDatabaseProperty alloc] initWithTitle:@"green" constraint:nil type:MCSPropertyTypeDouble];
        MCSDatabaseProperty *blueProperty = [[MCSDatabaseProperty alloc] initWithTitle:@"blue" constraint:nil type:MCSPropertyTypeDouble];
        colorsTableDatabaseProperties = @[productColorIdProperty,
                                          redProperty,
                                          greenProperty,
                                          blueProperty];


        [self createTable:PRODUCTS_TABLE usingProperties:productsTableDatabaseProperties];
        [self createTable:COLORS_TABLE usingProperties:colorsTableDatabaseProperties];

        // bootstrapping code. Remove before submitting.
    }
    return self;
}

#pragma mark – DB Table Instantiation

//- (void)createProductsTable{
// 
//    NSMutableString* createStatement = [NSMutableString stringWithFormat:@"CREATE TABLE %@ (", PRODUCTS_TABLE];
//    for(int i = 0; i<[productsTableDatabaseProperties count]; i++){
//        MCSDatabaseProperty *currentProperty = [productsTableDatabaseProperties objectAtIndex:i];
//        [createStatement appendFormat:@"%@ %@ %@", currentProperty.propertyTitle, [currentProperty getPropertyTypeAsString], currentProperty.propertyConstraint];
//        
//        if(i < [productsTableDatabaseProperties count] - 1){
//            [createStatement appendString:@","];
//        }
//    }
//    [createStatement appendString:@");"];
//    
//    sqlite3_stmt *sqlStatement = [self prepareStatement:createStatement];
//    while(sqlite3_step(sqlStatement) != SQLITE_DONE){
//        // if there were work to do at each step, we'd do it here.
//    }
//    
//    sqlite3_finalize(sqlStatement);
//}

- (void)createTable:(NSString *)tableName usingProperties:(NSArray *)propertiesArray
{
    NSMutableString* createStatement = [NSMutableString stringWithFormat:@"CREATE TABLE %@ (", tableName];
    for(int i = 0; i<[propertiesArray count]; i++){
        MCSDatabaseProperty *currentProperty = [propertiesArray objectAtIndex:i];
        [createStatement appendFormat:@"%@ %@ %@", currentProperty.propertyTitle, [currentProperty getPropertyTypeAsString], currentProperty.propertyConstraint];
        
        if(i < [propertiesArray count] - 1){
            [createStatement appendString:@","];
        }
    }
    [createStatement appendString:@");"];
    
    sqlite3_stmt *sqlStatement = [self prepareStatement:createStatement];
    while(sqlite3_step(sqlStatement) != SQLITE_DONE){
        // if there were work to do at each step, we'd do it here.
    }
    
    sqlite3_finalize(sqlStatement);
}

#pragma mark – Public Interface

- (BOOL)loadProductWithId:(uint64_t)productId
{
    // check to see if this product has already been loaded.
    NSString *existsQuery = [NSString stringWithFormat:@"SELECT productId FROM %@ WHERE productId=%llu;", PRODUCTS_TABLE, productId];
    sqlite3_stmt *existsStatement = [self prepareStatement:existsQuery];
    if(sqlite3_step(existsStatement) != SQLITE_DONE){
        sqlite3_finalize(existsStatement);
        return NO;
    }
    sqlite3_finalize(existsStatement);
    
    NSDictionary *jsonDictionary = [self loadSerializedJSONFile];
    NSArray *productsArray = [jsonDictionary objectForKey:@"products"];
    for(NSDictionary* itemDictionary in productsArray)
    {
        uint64_t currentProductId = [[itemDictionary objectForKey:@"productId"] unsignedLongLongValue];
        if(currentProductId == productId)
        {
            MCSProduct *product = [self loadProductFromJSONDictionary:itemDictionary];
            [self insertProductIntoDatabase:product];
            [self insertProductColorsIntoDatabase:product.productColors forProductId:product.productId];
            return YES;
        }
    }
    
    return NO;
}

- (void)removeProductWithId:(uint64_t)productId
{
    //http://www.sqlite.org/lang_delete.html
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE productId=%llu;", PRODUCTS_TABLE, productId];
    sqlite3_stmt *deleteStatement = [self prepareStatement:deleteQuery];
    while(sqlite3_step(deleteStatement) != SQLITE_DONE){
        
    }
    sqlite3_finalize(deleteStatement);
}

- (MCSProduct*)getProductWithId:(uint64_t)productId
{
    MCSProduct *product = nil;
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE productId=%llu;", PRODUCTS_TABLE, productId];
    sqlite3_stmt *statement = [self prepareStatement:queryString];
    while(sqlite3_step(statement) == SQLITE_ROW){
        product = [[MCSProduct alloc] init];
        
        for(int i = 0; i<[productsTableDatabaseProperties count]; i++){
            MCSDatabaseProperty *currentProperty = [productsTableDatabaseProperties objectAtIndex:i];
            switch (currentProperty.propertyType) {
                case MCSPropertyTypeInteger:
                {
                    uint64_t intValue = sqlite3_column_int64(statement, i);
                    [product setValue:[NSNumber numberWithUnsignedLongLong:intValue] forKey:currentProperty.propertyTitle];
                }
                    break;
                case MCSPropertyTypeString:
                {
                    const char *textValue = (const char*)sqlite3_column_text(statement, i);
                    if(textValue != NULL){
                        [product setValue:[NSString stringWithCString:textValue encoding:NSUTF8StringEncoding] forKey:currentProperty.propertyTitle];
                    }
                }
                    break;
                case MCSPropertyTypeDouble:
                {
                    double doubleValue = sqlite3_column_double(statement, i);
                    [product setValue:[NSNumber numberWithDouble:doubleValue] forKey:currentProperty.propertyTitle];
                }
                    break;
            }
        }
    }
    sqlite3_finalize(statement);
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    NSString *colorString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE productId=%llu;", COLORS_TABLE, productId];
    sqlite3_stmt *colorStatement = [self prepareStatement:colorString];
    while(sqlite3_step(colorStatement) == SQLITE_ROW){
        double red = sqlite3_column_double(colorStatement, 1);
        double green = sqlite3_column_double(colorStatement, 2);
        double blue = sqlite3_column_double(colorStatement, 3);
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        [colors addObject:color];
    }
    sqlite3_finalize(colorStatement);
    product.productColors = colors;
    
    return product;
}

- (MCSProduct*)getProductAtIndex:(NSInteger)index
{
    NSString *queryString = [NSString stringWithFormat:@"SELECT productId FROM %@ LIMIT 1 OFFSET %ld;", PRODUCTS_TABLE, (long)index];
    sqlite3_stmt *queryStatement = [self prepareStatement:queryString];
    uint64_t productId = UINT64_MAX;
    while(sqlite3_step(queryStatement) == SQLITE_ROW){
        productId = sqlite3_column_int64(queryStatement, 0);
    }
    sqlite3_finalize(queryStatement);
    
    if(productId == UINT64_MAX){
        return nil;
    }
    else{
        return [self getProductWithId:productId];
    }
}

- (void)saveProduct:(MCSProduct*)product
{
    //http://www.sqlite.org/lang_update.html
    
    NSMutableString *updateString = [[NSMutableString alloc] initWithFormat:@"UPDATE %@ SET ", PRODUCTS_TABLE];
    
    // starting this for loop with 1 instead of 0.
    // the first object in our dbProperties is the product ID, which should not change.
    for(int i = 1; i<[productsTableDatabaseProperties count]; i++){
        MCSDatabaseProperty *currentProperty = [productsTableDatabaseProperties objectAtIndex:i];
        
        id value = [product valueForKey:currentProperty.propertyTitle];
        if([value isKindOfClass:[NSString class]] ){
            [updateString appendFormat:@"%@='%@'", currentProperty.propertyTitle, value];
        }
        else{
            [updateString appendFormat:@"%@=%@", currentProperty.propertyTitle, value];
        }

        
        if(i < [productsTableDatabaseProperties count] - 1){
            [updateString appendString:@","];
        }
    }
    [updateString appendFormat:@" WHERE productId=%llu;", product.productId];
    
    sqlite3_stmt *updateStatement = [self prepareStatement:updateString];
    while(sqlite3_step(updateStatement) != SQLITE_DONE){
        // do work here on each step if necessary.
    }
    
    sqlite3_finalize(updateStatement);
}

- (NSDictionary*)getAllProducts
{
    return nil;
}

- (NSInteger)serializedProductCount
{
    NSDictionary *jsonDictionary = [self loadSerializedJSONFile];
    NSArray *productsArray = [jsonDictionary objectForKey:@"products"];
    return [productsArray count];
}

- (NSArray*)serializedProductIds
{
    NSDictionary *jsonDictionary = [self loadSerializedJSONFile];
    NSArray *productsArray = [jsonDictionary objectForKey:@"products"];
    
    NSMutableArray *productIds = [[NSMutableArray alloc] initWithCapacity:[productsArray count]];
    for(NSDictionary *productDict in productsArray){
        [productIds addObject:[productDict valueForKey:@"productId"]];
    }
    
    return productIds;
}

- (NSInteger)productCount
{
    int productCount = -1;
    NSString *countString = [NSString stringWithFormat:@"SELECT count(*) FROM %@;", PRODUCTS_TABLE];
    sqlite3_stmt *countStatement = [self prepareStatement:countString];
    while(sqlite3_step(countStatement) != SQLITE_DONE){
        productCount = sqlite3_column_int(countStatement, 0);
    }
    sqlite3_finalize(countStatement);
    return productCount;
}

- (NSArray*)productIds
{
    NSMutableArray *productIds = [[NSMutableArray alloc] initWithCapacity:[self productCount]];
    NSString *idString = [NSString stringWithFormat:@"SELECT productId FROM %@;", PRODUCTS_TABLE];
    sqlite3_stmt *idStatement = [self prepareStatement:idString];
    
    while(sqlite3_step(idStatement) != SQLITE_DONE){
        uint64_t productId = (uint64_t)sqlite3_column_int64(idStatement, 0);
        [productIds addObject:[NSNumber numberWithUnsignedLongLong:productId]];
    }

    return productIds;
}

#pragma mark – Private Interface

- (MCSProduct*)loadProductFromJSONDictionary:(NSDictionary*)itemDictionary
{
    MCSProduct *product = [[MCSProduct alloc] init];
    product.productId = [[itemDictionary objectForKey:@"productId"] unsignedLongLongValue];
    product.productName = [itemDictionary objectForKey:@"productName"];
    product.productPrice = [[itemDictionary objectForKey:@"productPrice"] unsignedLongLongValue];
    product.productSalePrice = [[itemDictionary objectForKey:@"productSalePrice"] unsignedLongLongValue];
    product.productDescription = [itemDictionary objectForKey:@"productDescription"];
    product.productPhotoName = [itemDictionary objectForKey:@"productPhotoName"];
    
    NSArray *productColors = [itemDictionary objectForKey:@"productColors"];
    NSMutableArray *colorsArray = [[NSMutableArray alloc] initWithCapacity:[productColors count]];
    for(NSDictionary *colorDict in productColors){
        double red = [[colorDict objectForKey:@"red"] doubleValue];
        double green = [[colorDict objectForKey:@"green"] doubleValue];
        double blue = [[colorDict objectForKey:@"blue"] doubleValue];
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        [colorsArray addObject:color];
    }
    product.productColors = colorsArray;
    
    return product;
}

- (void)insertProductIntoDatabase:(MCSProduct*)product
{
    // Basic INSERT command format:
    // INSERT INTO <tableName> (column1Name,column2Name,*) VALUES (column1Value, column2Value,*);
    // http://www.sqlite.org/lang_insert.html
    
    NSMutableString *insertString = [[NSMutableString alloc] initWithString:@"INSERT INTO "];
    [insertString appendFormat:@"%@ (", PRODUCTS_TABLE];
    
    for(int i = 0; i<[productsTableDatabaseProperties count]; i++){
        MCSDatabaseProperty *currentProperty = [productsTableDatabaseProperties objectAtIndex:i];
        [insertString appendString:currentProperty.propertyTitle];
        
        if(i < [productsTableDatabaseProperties count] - 1){
            [insertString appendString:@","];
        }
    }
    
    [insertString appendString:@") VALUES ("];
    
    for(int i = 0; i<[productsTableDatabaseProperties count]; i++){
        MCSDatabaseProperty *currentProperty = [productsTableDatabaseProperties objectAtIndex:i];
        id value = [product valueForKey:currentProperty.propertyTitle];
        if([value isKindOfClass:[NSString class]] ){
            [insertString appendFormat:@"'%@'", value];
        }
        else{
            [insertString appendFormat:@"%@", value];
        }
        

        if(i < [productsTableDatabaseProperties count] - 1){
            [insertString appendString:@","];
        }
    }
    
    [insertString appendString:@");"];
    
    sqlite3_stmt *statement = [self prepareStatement:insertString];
    while(sqlite3_step(statement) != SQLITE_DONE){
        // if work is required at each step do it here
    }
    
    sqlite3_finalize(statement);
}

- (void)insertColor:(UIColor *)color forProductId:(uint64_t)productId
{
    NSMutableString *insertString = [[NSMutableString alloc] initWithString:@"INSERT INTO "];
    [insertString appendFormat:@"%@ (", COLORS_TABLE];

    for(int i = 0; i<[colorsTableDatabaseProperties count]; i++){
        MCSDatabaseProperty *currentProperty = [colorsTableDatabaseProperties objectAtIndex:i];
        [insertString appendString:currentProperty.propertyTitle];
        
        if(i < [colorsTableDatabaseProperties count] - 1){
            [insertString appendString:@","];
        }
    }
    
    [insertString appendString:@") VALUES ("];

    CGFloat red = 0, blue = 0, green = 0, alpha = 0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    [insertString appendFormat:@"%llu, %.2f, %.2f, %.2f);", productId, red, green, blue];
    
    sqlite3_stmt *statement = [self prepareStatement:insertString];
    while(sqlite3_step(statement) != SQLITE_DONE){
        // if work is required at each step do it here
    }
    
    sqlite3_finalize(statement);

}
- (void)insertProductColorsIntoDatabase:(NSArray*)productColors forProductId:(uint64_t)productId
{
    for(UIColor *color in productColors){
        [self insertColor:color forProductId:productId];
    }
}

- (NSDictionary*)loadSerializedJSONFile
{
    NSString *jsonProductsPath = [[NSBundle mainBundle] pathForResource:PRODUCTS_JSON_FILE ofType:@"json"];
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:jsonProductsPath];
    [inputStream open];
    NSError *jsonReadError = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:&jsonReadError];
    [inputStream close];
    
    if(!jsonDictionary){
        NSLog(@"Error loading JSON file: %@", [jsonReadError localizedDescription]);
        return nil;
    }
    return jsonDictionary;
}

#pragma mark – sqlite3 helpers

-(sqlite3_stmt*)prepareStatement:(NSString*)statementString
{
    sqlite3_stmt *sqlStatement;
    const char *queryString = [statementString cStringUsingEncoding:NSUTF8StringEncoding];
    int queryStringLength = strlen(queryString) + 1;
    int statementPrepareSuccess = sqlite3_prepare_v2(productsDatabase, queryString, queryStringLength, &sqlStatement, NULL);
    assert(statementPrepareSuccess == SQLITE_OK);
    return sqlStatement;
}

@end
