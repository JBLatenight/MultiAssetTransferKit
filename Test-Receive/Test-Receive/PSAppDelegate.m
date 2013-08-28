//
//  PSAppDelegate.m
//  Test-Receive
//
//  Created by Jeff Bargmann on 8/27/13.
//  Copyright (c) 2013 PhotoSocial LLC. MIT License.
//

#import "PSAppDelegate.h"
#import "PSViewController.h"
#import "MultiAssetTransferKit.h"

@implementation PSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[PSViewController alloc] initWithNibName:@"PSViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
}
- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //Display URL received for debug
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Received URL" message:url.absoluteString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    //Check URL for command
    if([MultiAssetTransferKit handleOpenedWithUrl:url withBlock:^(NSArray *assets, NSError *error) {
        //Display error
        if(error)
        {
            NSLog(@"Error opening assets after open with URL %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load assets" message:error.debugDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        //Pass asset list to view controller for display
        if(assets)
            [((PSViewController*)self.viewController) loadWithAssets:assets];
    }])
    {
        return YES;
    }
    
    //URL not handled.
    return NO;
}
@end
