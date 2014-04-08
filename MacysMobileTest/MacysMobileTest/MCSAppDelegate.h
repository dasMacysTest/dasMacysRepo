//
//  MCSAppDelegate.h
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCSProductStore;

@interface MCSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property MCSProductStore *productStore;
@property UINavigationController *navigationController;

@end
