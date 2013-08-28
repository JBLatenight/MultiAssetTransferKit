//
//  PSViewController.m
//  Test-Send
//
//  Created by Jeff Bargmann on 8/27/13.
//  Copyright (c) 2013 PhotoSocial LLC. MIT License.
//

#import "PSViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MultiAssetTransferKit.h"


@interface PSViewController ()

@end

@implementation PSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Load 4 most recent images from user's asset library
    ALAssetsLibrary *_library = [[ALAssetsLibrary alloc] init];
    _assetURLsLabel.text = @"";
    [_library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        //Photos only
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        //Enum assets backwards
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
            //Ignore end signal
            if(!asset)
            {
                //Notify of non-ideal scenario
                if(_assetURLs.count < 4)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load all images" message:@"Your library should contain at least a couple images for this test." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                return;
            }
            
            //Fetch asset URL
            NSURL *assetURL = asset.defaultRepresentation.url;
            if(!assetURL.absoluteString)
                return;
            
            //Load image
            UIImage *assetImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            if(!assetImage)
                return;
            
            //Save to our dictionary of URLs. We'll pass this as paramters to the next app
            if(!_assetURLs)
                _assetURLs = [NSMutableArray array];
            [_assetURLs addObject:assetURL.absoluteString];
             
            //Add to label displaying URLs
            _assetURLsLabel.text = [_assetURLsLabel.text stringByAppendingFormat:@"%@\n",assetURL.absoluteString];
            
            //Set image to appropriate imageview
            if(_assetURLs.count == 1)
                _asset1ImageView.image = assetImage;
            else if(_assetURLs.count == 2)
                _asset2ImageView.image = assetImage;
            else if(_assetURLs.count == 3)
                _asset3ImageView.image = assetImage;
            else if(_assetURLs.count == 4)
                _asset4ImageView.image = assetImage;
            
            //Stop search once 4 assets reached
            if(_assetURLs.count == 4)
                (*stop) = true;
        }];
    } failureBlock:^(NSError *error) {
        //Notify of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load image" message:@"Please grant access to your photo collection and restart app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)sendButtonHit:(id)sender {
    //Notify of error if no images
    if(!_assetURLs.count)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load image" message:@"Please grant access to your photo collection and restart app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //Send assets
    NSString *targetUrlScheme = @"multireceive-test";
    NSString *targetUrlName = @"Test Receiver App";
    if(![MultiAssetTransferKit sendAssetUrls:_assetURLs toAppWithURLScheme:targetUrlScheme])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not open URL" message:[NSString stringWithFormat:@"Please install %@", targetUrlName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
}
@end
