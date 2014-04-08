//
//  MCSDatabaseProperty.h
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/6/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MCSPropertyType){
    MCSPropertyTypeInteger,
    MCSPropertyTypeString,
    MCSPropertyTypeDouble
};

@interface MCSDatabaseProperty : NSObject

@property NSString *propertyTitle;
@property NSString *propertyConstraint;
@property MCSPropertyType propertyType;

- (id)initWithTitle:(NSString*)title constraint:(NSString*)constrain type:(MCSPropertyType)type;

/**
 Returns the sqlite3 text representation of a data type.
 @returns an NSString * representing the sqlite3 representation of this property's data type.
 */
- (NSString*)getPropertyTypeAsString;

@end
