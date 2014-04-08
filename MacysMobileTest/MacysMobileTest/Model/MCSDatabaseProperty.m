//
//  MCSDatabaseProperty.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/6/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSDatabaseProperty.h"

@interface MCSDatabaseProperty()


@end

@implementation MCSDatabaseProperty
@synthesize propertyTitle;
@synthesize propertyConstraint;
@synthesize propertyType;

- (id)initWithTitle:(NSString*)title constraint:(NSString*)constrain type:(MCSPropertyType)type
{
    self = [super init];
    if(self){
        propertyTitle = title;
        
        if(constrain){
            propertyConstraint = constrain;
        }
        else{
            propertyConstraint = @"";
        }
        
        propertyType = type;
    }
    
    return self;
}


- (NSString*)getPropertyTypeAsString
{
    switch (propertyType) {
        case MCSPropertyTypeInteger:
            return @"INTEGER";
        case MCSPropertyTypeString:
            return @"TEXT";
        case MCSPropertyTypeDouble:
            return @"REAL";
    }
    
    return @"TEXT";
}

@end
