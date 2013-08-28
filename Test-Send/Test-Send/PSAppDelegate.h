//
//  PSAppDelegate.h
//  Test-Send
//
//  Created by Jeff Bargmann on 8/27/13.
//  Copyright (c) 2013 PhotoSocial LLC. MIT License.
//

#import <UIKit/UIKit.h>

@class PSViewController;

@interface PSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PSViewController *viewController;

@end
