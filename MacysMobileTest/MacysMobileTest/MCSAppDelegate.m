//
//  MCSAppDelegate.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/5/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSAppDelegate.h"
#import "MCSProductStore.h"
#import "MCSProduct.h"
#import "MCSPathSelectionViewController.h"

@implementation MCSAppDelegate
@synthesize productStore;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    productStore = [[MCSProductStore alloc] init];
    
    MCSPathSelectionViewController *pathViewController = [[MCSPathSelectionViewController alloc] initWithNibName:nil bundle:nil productStore:productStore];
    navigationController = [[UINavigationController alloc] initWithRootViewController:pathViewController];
    
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark – Bootstrapping Methods

- (NSArray*)testLoadingJsonData
{
    NSMutableArray *filledProductsArray = [[NSMutableArray alloc] init];
    
    NSString *jsonProductsPath = [[NSBundle mainBundle] pathForResource:@"MacysProductStore" ofType:@"json"];
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:jsonProductsPath];
    [inputStream open];
    NSError *jsonReadError = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:&jsonReadError];
    [inputStream close];
    
    if(!jsonDictionary){
        NSLog(@"Error loading JSON file: %@", [jsonReadError localizedDescription]);
        return filledProductsArray;
    }
    
    NSArray *productsArray = [jsonDictionary objectForKey:@"products"];
    for(NSDictionary* itemDictionary in productsArray)
    {
        MCSProduct *product = [[MCSProduct alloc] init];
        product.productId = [[itemDictionary objectForKey:@"productId"] unsignedLongLongValue];
        product.productName = [itemDictionary objectForKey:@"productName"];
        [filledProductsArray addObject:product];
    }
    
    return filledProductsArray;
}

@end
