//
//  NSURL+QueryStringComponents.h
//  Test-Send
//
//  Created by Jeff Bargmann on 8/27/13.
//  Copyright (c) 2013 PhotoSocial LLC. MIT License.
//

#import <Foundation/Foundation.h>

//KNOWN ISSUES:
//*If param has a blank value, is it omitted from the parsed queryComponents

//KNOWN LIMITATIONS
//*Can only encode NSString, NSNumber, or NSObject's that expose stringValue selector
//*All values decoded as NSString

@interface NSURL (QueryStringComponents)

//QueryComponents
@property (nonatomic, readonly) NSDictionary *queryComponents;
+ (id)URLWithString:(NSString *)URLString withQueryComponents: (NSDictionary*) queryComponents;
+ (id)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL withQueryComponents: (NSDictionary*) queryComponents;
- (id)URLByAppendingQueryComponents: (NSDictionary*) queryComponents;

@end


@interface NSString (URLEncoding)

//URL Encoding & Decoding
- (NSString*) urlEncode;
- (NSString*) urlDecode;

@end