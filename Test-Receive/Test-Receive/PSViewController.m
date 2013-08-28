//
//  PSViewController.m
//  Test-Receive
//
//  Created by Jeff Bargmann on 8/27/13.
//  Copyright (c) 2013 PhotoSocial LLC. MIT License.
//

#import "PSViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSURL+QueryStringComponents.h"

@interface PSViewController ()

@end

@implementation PSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Clear text output
    _assetURLsLabel.text = @"No images loaded";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//Process incoming assets sent via URL
- (void) loadWithAssets: (NSArray*) assets
{
    //Build label string with URLs. Trailing \n is fine.
    _assetURLsLabel.text = @"";
    for(ALAsset *asset in assets)
        _assetURLsLabel.text = [_assetURLsLabel.text stringByAppendingFormat:@"%@\n", asset.defaultRepresentation.url.absoluteString];
    
    //Load images into place
    for(int i = 0 ; i < assets.count ; i++)
    {
        //Load image for asset, bail if no image
        ALAsset *asset = [assets objectAtIndex:i];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        if(!image)
            continue;
        
        //Place image
        if(i == 0)
            _asset1ImageView.image = image;
        else if(i == 1)
            _asset2ImageView.image = image;
        else if(i == 2)
            _asset3ImageView.image = image;
        else if(i == 3)
            _asset4ImageView.image = image;
    }
}

@end
