MultiAssetTransferKit
=====================

Lightweight framework for sending ALAsset URLs from one iOS application to another.

To send, pass an array of ALAssets. These ALAssets will be converted in asset library URLs then placed into a command URL for use with [[UIApplication sharedApplication] openURL:].

To receive, pass in the URL received. The framework will parse the command retrieving the asset library URLs, then load the corresponding ALAsset objects using [ALAssetsLibrary assetWithURL:]. This array of ALAssets will be passed to your handler block.

Sending ALAssets list to another app
-----------------------

1. Prepare list of ALAssets in an NSArray
2. Perform send. [MultiAssetTransferKit sendAssetUrls:toAppWithURLScheme:] invokes [[UIApplication sharedApplication] openURL:] after preparing command URL, and will return false if destination application is not registered on the device.

```
NSString *targetUrlScheme = @"destination-app";
[MultiAssetTransferKit sendAssetUrls:arrayOfAssetURLs toAppWithURLScheme:targetUrlScheme];
```



Receiving ALAssets list from another app
-----------------------
1. Add the following to your UIApplicationDelegate to process URL commands. [MultiAssetTransferKit handleOpenedWithUrl:withBlock:] will return true if the URL's method is "openimages", specified by kMultiAssetTransferKit_URLMethod. The resulting assets array consists of ALAsset objects loaded via [ALAssetsLibrary assetWithURL:] after parsing the incoming command.

```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //Check URL for incoming assets
    if([MultiAssetTransferKit handleOpenedWithUrl:url withBlock:^(NSArray *assets, NSError *error) {
    
        //Handle array of ALAssets received. Will be nil if unable to load assets.
        if(assets)
            [((PSViewController*)self.viewController) loadWithAssets:assets];
    
    }]) {
        //Signal URL handled
        return YES;
    }
    
    //Signal URL unhandled
    return NO;
}
```

Screenshots
-----------------------
![Sender](https://raw.github.com/JBLatenight/MultiAssetTransferKit/master/SenderScreenshot.png)
![Receiver](https://raw.github.com/JBLatenight/MultiAssetTransferKit/master/ReceivererScreenshot.png)


