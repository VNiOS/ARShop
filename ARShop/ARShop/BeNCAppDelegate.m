//
//  BeNCAppDelegate.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "LocationService.h"
#import "BeNCAppDelegate.h"
#import "BeNCMenuViewController.h"
#import "BeNCTabbarItem.h"
#import "BeNCListViewController.h"
#import "BeNCCameraViewController.h"
#import "BeNCMapViewController.h"
#import "BeNCProcessDatabase.h"

@implementation BeNCAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize databasePath;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [databasePath release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self checkDatabase];
    BeNCTabbarItem *tabItem1 = [[BeNCTabbarItem alloc] initWithFrame:CGRectMake(60, 5, 120, 40) normalState:@"listoff.png" toggledState:@"ListOn.png"];
	BeNCTabbarItem *tabItem2 = [[BeNCTabbarItem alloc] initWithFrame:CGRectMake(180, 5, 120, 40) normalState:@"mapoff.png" toggledState:@"mapon.png"];
	BeNCTabbarItem *tabItem3 = [[BeNCTabbarItem alloc] initWithFrame:CGRectMake(300, 5, 120, 40) normalState:@"cameraoff.png" toggledState:@"cameraon.png"];
    
    
    BeNCListViewController *listViewController = [[BeNCListViewController alloc]initWithNibName:@"BeNCListViewController" bundle:nil];
    BeNCMapViewController *mapViewController = [[BeNCMapViewController alloc]initWithNibName:@"BeNCMapViewController" bundle:nil];
    BeNCCameraViewController *cameraViewController = [[BeNCCameraViewController alloc]initWithNibName:@"BeNCCameraViewController" bundle:nil];
    
    
    NSMutableArray *viewControllersArray = [[NSMutableArray alloc] init];
    UINavigationController *listNavigation = [[UINavigationController alloc]initWithRootViewController:listViewController];
    [listNavigation.navigationBar setHidden:NO];
    [listNavigation.view setFrame:CGRectMake(0, -20, 480, 320)];
	[viewControllersArray addObject:listNavigation];
	[viewControllersArray addObject:mapViewController];
	[viewControllersArray addObject:cameraViewController];
    
	
	NSMutableArray *tabItemsArray = [[NSMutableArray alloc] init];
	[tabItemsArray addObject:tabItem1];
	[tabItemsArray addObject:tabItem2];
	[tabItemsArray addObject:tabItem3];
    
    [[LocationService locationService]startUpdate];    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[BeNCMenuViewController alloc]initWithTabViewControllers:viewControllersArray tabItems:tabItemsArray initialTab:0];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)checkDatabase 
{

    BOOL success;
    NSString *databaseName = @"ARShopDatabase.sqlite";
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPath objectAtIndex:0];
    databasePath = [documentDir stringByAppendingPathComponent:databaseName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    if (success) return;
    NSString *databasePathFromApp = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:databaseName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
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


@end
