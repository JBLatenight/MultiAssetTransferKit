//
//  NSURL+QueryStringComponents.m
//  Test-Send
//
//  Created by Jeff Bargmann on 8/27/13.
//  Copyright (c) 2013 PhotoSocial LLC. MIT License.
//

#import "NSURL+QueryStringComponents.h"

@implementation NSURL (QueryStringComponents)

- (NSDictionary*) queryComponents
{
    //Read querystring
    NSString *query = self.query;
    if(!query)
        return nil;
    
    //Parse & return
    NSMutableDictionary *queryComponents = [NSMutableDictionary dictionary];
    for(NSString *keyValuePairString in [query componentsSeparatedByString:@"&"])
    {
        //Ignore incomplete pairs
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if(keyValuePairArray.count != 2)
            continue;
        
        //Decode, add to dictionary
        [queryComponents setValue:[[keyValuePairArray objectAtIndex:1] urlDecode] forKey:[[keyValuePairArray objectAtIndex:0] urlDecode]];
    }
    return queryComponents;
}
+ (id)URLWithString:(NSString *)URLString withQueryComponents: (NSDictionary*) queryComponents
{
    //Clear existing querystring from URLString
    NSUInteger queryStringIndex = [URLString rangeOfString:@"?" options:NSBackwardsSearch].location;
    if(queryStringIndex != NSNotFound)
        URLString = [URLString substringToIndex:queryStringIndex];
    
    //Create URL and them append components
    return [[self URLWithString:URLString] URLByAppendingQueryComponents:queryComponents];
}
+ (id)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL withQueryComponents: (NSDictionary*) queryComponents
{
    //Clear existing querystring from URLString
    NSUInteger queryStringIndex = [URLString rangeOfString:@"?" options:NSBackwardsSearch].location;
    if(queryStringIndex != NSNotFound)
        URLString = [URLString substringToIndex:queryStringIndex];
    
    //Create URL and them append components
    return [[self URLWithString:URLString relativeToURL:baseURL] URLByAppendingQueryComponents:queryComponents];
}
- (id) URLByAppendingQueryComponents: (NSDictionary*) queryComponents
{
    //Build component string
    NSMutableString *urlString = self.absoluteString.mutableCopy;
    bool hasQueryParams = ([urlString rangeOfString:@"?" options:NSBackwardsSearch].location != NSNotFound);
    for(NSString *key in queryComponents.allKeys)
    {
        //Get string value for encoding
        id value = [queryComponents objectForKey:key];
        NSString *valueString = ([value isKindOfClass:[NSString class]]?value:[value respondsToSelector:@selector(stringValue)]?[value stringValue]:[value description]);
        
        //Create component. URL encode each piece
        [urlString appendFormat:@"%@%@=%@", (hasQueryParams?@"&":@"?"), [key urlEncode], [valueString urlEncode]];
        hasQueryParams = true;
    }
    return [NSURL URLWithString:urlString];
}
@end

@implementation NSString (URLEncoding)

- (NSString*) urlEncode
{
    //Encodes into %'s
    return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (CFStringRef)@":/?#[]@!$&'()*+,;= ", kCFStringEncodingUTF8);
}
- (NSString*) urlDecode
{
    //Replace +'s, then, replace %-escaped strings
    NSString *result = self;
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = (__bridge_transfer NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)result, (CFStringRef)@"", kCFStringEncodingUTF8);
    return result;
}

@end

