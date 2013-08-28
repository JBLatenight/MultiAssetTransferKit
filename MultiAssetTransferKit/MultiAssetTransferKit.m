//
//  MultiAssetTransferKit.m
//  MultiAssetTransferKit
//
//  Created by Jeff Bargmann on 8/26/13.
//  Copyright (c) 2013 PhotoSocial LLC. MIT License.
//

#import "MultiAssetTransferKit.h"
#import "NSURL+QueryStringComponents.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation MultiAssetTransferKit

//Global library handle
static ALAssetsLibrary *_library;

//Sending
+ (bool) sendAssets: (NSArray*) assets toAppWithURLScheme: (NSString*) URLScheme
{
    //Convert assets to URLs, then send
    NSMutableArray *assetURLs = [NSMutableArray array];
    for(ALAsset *asset in assets)
        [assetURLs addObject:asset.defaultRepresentation.url];
    return [self sendAssetUrls:assetURLs toAppWithURLScheme:URLScheme];
}
+ (bool) sendAssetUrls: (NSArray*) assetURLs toAppWithURLScheme: (NSString*) URLScheme
{
    //Prepare params. Bail if unexpected type is found.
    NSMutableDictionary *queryComponents = [NSMutableDictionary dictionary];
    for(id assetURL in assetURLs)
    {
        if([assetURL isKindOfClass:[NSString class]])
            [queryComponents setObject:assetURL forKey:[NSString stringWithFormat:@"img%d", queryComponents.count]];
        else if([assetURL isKindOfClass:[NSURL class]])
            [queryComponents setObject:[assetURL absoluteString] forKey:[NSString stringWithFormat:@"img%d", queryComponents.count]];
    }
    if(queryComponents.count != assetURLs.count)
        return false;
    [queryComponents setValue:[NSString stringWithFormat:@"%d", assetURLs.count] forKey:@"imgCount"];
    
    
    //Prepare URL
    NSURL *outgoingURL = [NSURL URLWithString:@"multireceive-test://openimages" withQueryComponents:queryComponents];
    
    
    //Verify we can launch URL
    if(![[UIApplication sharedApplication] canOpenURL:outgoingURL])
        return false;
    
    //Launch URL
    [[UIApplication sharedApplication] openURL:outgoingURL];
    return true;
}

//Receiving
+ (bool) handleOpenedWithUrl: (NSURL*) url withBlock: (AssetsLoadedBlock) handler
{
    //Check for our method kMultiAssetTransferKit_URLMethod
    if([url.absoluteString rangeOfString:@"://"kMultiAssetTransferKit_URLMethod].location == NSNotFound)
        return false;
  
    //Parse URL's querystring
    NSDictionary *queryComponents = [url queryComponents];
    
    //Get image count
    int imageCount = [[queryComponents objectForKey:@"imgCount"] intValue];
    
    //Get list of image URLs, verify a match.
    NSMutableArray *imageUrls = [NSMutableArray array];
    for(int i = 0 ; i < imageCount ; i++)
    {
        //Get asset url, add to list
        NSString *urlString = [queryComponents objectForKey:[NSString stringWithFormat:@"img%d", i]];
        if(urlString.length)
            [imageUrls addObject:urlString];
    }
    
    //Bail if no images, or if URLs found != URL count described
    if(!imageCount || (imageCount != imageUrls.count))
        return false;
    
    //Process list of assets
    [self loadAssetsForAssetUrls:imageUrls completed:handler];
    return true;
}
+ (void) loadAssetsForAssetUrls: (NSArray*) assetURLs completed: (AssetsLoadedBlock) handler
{
    //Load into internal recursive FN
    [self loadAssetsForAssetUrls:assetURLs.mutableCopy completed:handler withResults:[NSMutableArray array]];
}
+ (void) loadAssetsForAssetUrls: (NSMutableArray*) assetURLs completed: (AssetsLoadedBlock) handler withResults: (NSMutableArray*) results
{
    //Sanity
    if(!assetURLs.count)
    {
        if(handler)
            handler(nil, [[NSError alloc] initWithDomain:@"No assets specified" code:1 userInfo:nil]);
        return;
    }
    
    //Copy list, pop first URL off stack
    id assetURLObject = [assetURLs objectAtIndex:0];
    [assetURLs removeObjectAtIndex:0];
    
    //Ensure NSURL type
    NSURL *assetURL;
    if([assetURLObject isKindOfClass:[NSString class]])
        assetURL = [NSURL URLWithString:assetURLObject];
    else if([assetURLObject isKindOfClass:[NSURL class]])
        assetURL = assetURLObject;
    if(!assetURL.absoluteString)
    {
        if(handler)
            handler(nil, [[NSError alloc] initWithDomain:@"Invalid url type" code:1 userInfo:@{@"url":assetURL}]);
        return;
    }
    
    //Load asset
    if(!_library)
        _library = [[ALAssetsLibrary alloc] init];
    [_library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
        //Handle results
        if(asset)
        {
            //Add to results list
            [results addObject:asset];
            
            //If done, call handler. Otherwise, continue processing in list
            if(!assetURLs.count)
            {
                handler(results, nil);
            }
            else
            {
                //Call asynchronously as to remove risk of recursive stack overflow
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadAssetsForAssetUrls:assetURLs completed:handler withResults:results];
                });
            }
        }
        else
        {
            //Notify of failure
            if(handler)
                handler(nil, [[NSError alloc] initWithDomain:@"Asset not found" code:1 userInfo:@{@"url":assetURL}]);
        }
        
    } failureBlock:^(NSError *error) {
        //Notify of failure
        if(handler)
            handler(nil, error);
    }];
}

@end
