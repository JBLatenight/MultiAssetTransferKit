//
//  MultiAssetTransferKit.h
//  MultiAssetTransferKit
//
//  Created by Jeff Bargmann on 8/26/13.
//  Copyright (c) 2013 PhotoSocial LLC. MIT License.
//

#import <Foundation/Foundation.h>


//The default method for the url scheme, e.g. receiver://openimages?url1=...
#define kMultiAssetTransferKit_URLMethod    @"openimages"

//This block handles received assets
typedef void (^AssetsLoadedBlock)(NSArray *assets, NSError *error);


@interface MultiAssetTransferKit : NSObject

//Sending
+ (bool) sendAssets: (NSArray*) assets toAppWithURLScheme: (NSString*) URLScheme;
+ (bool) sendAssetUrls: (NSArray*) assetURLs toAppWithURLScheme: (NSString*) URLScheme;

//Receiving
+ (bool) handleOpenedWithUrl: (NSURL*) url withBlock: (AssetsLoadedBlock) handler;
+ (void) loadAssetsForAssetUrls: (NSArray*) assetURLs completed: (AssetsLoadedBlock) handler;

@end
