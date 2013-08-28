//
//  PSAppDelegate.m
//  Test-Send
//
//  Created by Jeff Bargmann on 8/27/13.
//  Copyright (c) 2013 PhotoSocial LLC. MIT License.
//

#import "PSAppDelegate.h"
#import "PSViewController.h"
#import "NSURL+QueryStringComponents.h"

@implementation PSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Run some test data. Each pair in this multi-dim array should match
    NSArray *urlPairs = @[
                          @[[NSURL URLWithString:@"test://noquery"],[NSURL URLWithString:@"test://noquery" withQueryComponents:@{}]],
                          @[[NSURL URLWithString:@"test://noquery?test%20one=first%20test&test%20two=test%25url%26string%3F"],[NSURL URLWithString:@"test://noquery" withQueryComponents:@{@"test one":@"first test",@"test two":@"test%url&string?"}]],
                          @[[NSURL URLWithString:@"test://noquery?test%20one=first%20test&test%20two=test%25url%26string%3F&test%3A%2F%2F3=symbols%3A%2F%2F%3D%3F~%25%26%5Etotest"],[NSURL URLWithString:@"test://noquery" withQueryComponents:@{@"test one":@"first test",@"test two":@"test%url&string?",@"test://3":@"symbols://=?~%&^totest"}]]
                          ];
    for(NSArray *urlPair in urlPairs)
    {
        //Test equality
        NSString *urlAbsoluteString1 = [[urlPair objectAtIndex:0] absoluteString];
        NSString *urlAbsoluteString2 = [[urlPair objectAtIndex:1] absoluteString];
        NSLog(@"URL1: %@", urlAbsoluteString1);
        NSLog(@"URL2: %@", urlAbsoluteString2);
        if(![urlAbsoluteString1 isEqualToString:urlAbsoluteString2])
            [NSException raise:@"Test failed" format:@"URL %@ does not match %@", urlAbsoluteString1, urlAbsoluteString2];
        NSDictionary *urlQueryComponents1 = [[urlPair objectAtIndex:0] queryComponents];
        NSDictionary *urlQueryComponents2 = [[urlPair objectAtIndex:1] queryComponents];
        NSLog(@"Dictionary1: %@", urlQueryComponents1);
        NSLog(@"Dictionary2: %@", urlQueryComponents2);
        if((urlQueryComponents1 != urlQueryComponents2) && ![urlQueryComponents1 isEqualToDictionary:urlQueryComponents2])
            [NSException raise:@"Test failed" format:@"Components %@ do not match %@", urlQueryComponents1, urlQueryComponents2];
        NSLog(@"----------------");
    }
    
    //Kick off the app
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

@end
