//
//  MCSViewControllerInterface.h
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCSProductStore;

@protocol MCSViewControllerInterface <NSObject>

/**
 Pointer to the application's Product Storage mechanism.
 */
@property (weak) MCSProductStore *productStore;

/**
 Public initializer for all classes conforming to MCSViewControllerInterface Protocol
 @param nibNameOrNil Name of the NIB file to load.
 @param nibBundleOrNil Name of the bundle from which to load the nib.
 @param store Pointer to the Product Store
 @returns A newly created view controller instance
 */
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productStore:(MCSProductStore*)store;

@end
