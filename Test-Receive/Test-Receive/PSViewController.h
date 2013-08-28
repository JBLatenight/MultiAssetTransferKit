//
//  PSViewController.h
//  Test-Receive
//
//  Created by Jeff Bargmann on 8/27/13.
//  Copyright (c) 2013 PhotoSocial LLC. MIT License.
//

#import <UIKit/UIKit.h>

@interface PSViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *asset1ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *asset2ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *asset3ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *asset4ImageView;
@property (strong, nonatomic) IBOutlet UILabel *assetURLsLabel;

- (void) loadWithAssets: (NSArray*) assets;

@end
