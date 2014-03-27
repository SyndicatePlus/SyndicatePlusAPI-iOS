/*
 Class used to generate the Authorization Header and send request for SyndicatePlusApiBase
 */

#import "SyndicatePlusApiBase.h"
#import <CommonCrypto/CommonDigest.h>
#import "QueryString.h"

@implementation SyndicatePlusApiBase
@synthesize apiKey,apiSecret;
@synthesize version,apiEndpoint;


/*
 Initialize the SyndicatePlusApiBase
 */

-(SyndicatePlusApiBase *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey{
        apiEndpoint = @"http://api.syndicateplus.com";
        apiKey=publicKey;
        apiSecret=privateKey;
        version=@"1";
        return self;
}


/**
 * Sends a request to the SyndicatePlus API
 */
- (NSData *)sendRequest:(NSString *)resource withQuery:(NSString *)queryString {
    //create GET request
    NSString *url=[self buildUrlWithResource:resource andQueryString:queryString];
    NSLog(@"url=%@", url);
    NSURL *urlString = [[NSURL alloc] initWithString:url];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlString];
    
    // Generate the authorization header
    NSString *authorizationHeader = [self generateAuthorizationHeaderWithMethod:@"GET" andResource:resource andQueryString:queryString];
    
  //   NSLog(@"authorizationHeader=%@", authorizationHeader);
    
    //set header in request
     NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setHTTPMethod:@"GET"];
    [mutableRequest setValue:@"'application/x-www-form-urlencoded; charset=UTF-8'" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
    [mutableRequest setValue:@"nl" forHTTPHeaderField:@"Accept-Language"];
    
    request = [mutableRequest copy];
	NSHTTPURLResponse *response;
	NSError *error;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  //  NSLog(@"Status Code=%li", (long)[response statusCode]);
 //   NSLog(@"Header=%@", [response allHeaderFields]);
    
//    if(urlData){
//        NSString *result=[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
//        NSLog(@"ret=%@", result);
//    }
   
    if (response.statusCode != 200)
    {
        //            show the user the status message
        NSLog(@"Error: %@", [NSHTTPURLResponse localizedStringForStatusCode: response.statusCode]); // This part is called
        
    }
    return urlData;
}


-(NSString *)buildUrlWithResource:(NSString *)resource andQueryString:(NSString *) queryString{
    NSString *trimmedResource=[resource substringToIndex:[resource length] - 1];
    NSString *apiWithVersion=[NSString stringWithFormat:@"%@%@%@%@",apiEndpoint,@"/v",version,@"/"];
    
    if([queryString isEqualToString:@""]){
        return[NSString stringWithFormat:@"%@%@%@",apiWithVersion,resource,queryString];
    }else{
        
        return[NSString stringWithFormat:@"%@%@%@%@",apiWithVersion,trimmedResource,@"?",queryString];
    }
   
}


-(NSString *) generateAuthorizationHeaderWithMethod:(NSString *)method andResource:(NSString *)resource andQueryString:(NSString *)queryString{
    
    // Prepare the query string and other values
    NSString *preparedQueryString=[self prepareQueryString:queryString];
    NSUUID  *UUID = [NSUUID UUID];
    NSString *nonceUppercase = [UUID UUIDString];
    NSString *nonce=[nonceUppercase lowercaseString];
    NSString *requestURL;
    
    long timestamp =[[NSDate date] timeIntervalSince1970];
    // Create signature:
    NSString *apiWithVersion=[NSString stringWithFormat:@"%@%@%@",apiEndpoint,@"/v",version];
    NSString *trimmedResource=[resource substringToIndex:[resource length] - 1];
    //add resource to apiWithVersion to get the correct requestURL
    if([queryString isEqualToString:@""]){
        requestURL= [NSString stringWithFormat:@"%@%@%@",apiWithVersion,@"/",resource];
       //  NSLog(@"requestURL=%@", requestURL);
    }else{
       // NSString *trimmedResource=[resource substringToIndex:[resource length] - 1];
        requestURL= [NSString stringWithFormat:@"%@%@%@",apiWithVersion,@"/",trimmedResource];
    }
    NSString *signatureWithoutEncode=[NSString stringWithFormat:@"%@%@%@%@%@%li", apiSecret,method,requestURL,preparedQueryString,nonce,timestamp];
    
    NSString *signature;
    //SHA1 Hash
    signature=[self sha1:signatureWithoutEncode];
    
    // Create authorization header
    NSString *header =[NSString stringWithFormat:@"%@%@%@%li%@%@%@%@%@",
                       @"Key=\"",apiKey,@"\",Timestamp=\"",timestamp,@"\",Nonce=\"",nonce,@"\",Signature=\"",signature,@"\""];

    return header;
}


- (NSString *)sha1:(NSString *)stringToHash{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    const char *cStr = [stringToHash UTF8String];
    CC_SHA1(cStr,(CC_LONG) strlen(cStr), result);
    NSData *pwHashData = [[NSData alloc] initWithBytes:result length: sizeof result];
    NSString *base64 = [pwHashData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}

/**
 * Turns a QueryString object into an acceptable string representation for
 * use in signature creation. Sorts alphabetically by keys, and URL encodes
 * (RFC 3986) both keys and values.
 *
 * @access private
 * @param $queryString 		The QueryString object
 * @return string 			The prepared query string
 */
-(NSString *)prepareQueryString:(NSString *)queryString{
 //    NSLog(@"start queryString");
    NSString *mappedQuery=[[NSString alloc]init];
    if([queryString isEqualToString:@""]){
        return  queryString;
    }else{
        QueryString *query=[[QueryString alloc]initWithQueryString:queryString];
      //  NSLog(@"query%@",query);
        NSMutableDictionary *keyValueDictionary=[query extractKeyValue:queryString];
        //sort by key
        NSArray *myKeys = [keyValueDictionary allKeys];
        NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
      //  NSMutableArray *sortedValues = [[NSMutableArray alloc] init];

        id key;
        id value;
        for (key in sortedKeys){
          //  NSLog(@"key dict%@",key);
           // key=[key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            key=[self urlencode:key];
            value=[keyValueDictionary objectForKey:key];
            value= [self urlencode:value];
            mappedQuery=[mappedQuery stringByAppendingString:key];
            mappedQuery=[mappedQuery stringByAppendingString:@"="];
            mappedQuery=[mappedQuery stringByAppendingString:value];
            mappedQuery=[mappedQuery stringByAppendingString:@"&"];
        }
        if([mappedQuery hasSuffix:@"&"]){
            mappedQuery=[mappedQuery substringToIndex:[mappedQuery length] - 1];
        }
       //  NSLog(@"mappedQuery%@",mappedQuery);
    }
    return mappedQuery;
}


//simple function that encodes reserved characters according to:
//RFC 3986 but small letter
-(NSString *) urlencode: (NSString *) url{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,
                            @"$" , @"," , @"[" , @"]",
                            @"#", @"!", @"'", @"(",
                            @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3b" , @"%2f" , @"%3f" ,
                             @"%3a" , @"%40" , @"%26" ,
                             @"%3d" , @"%2b" , @"%24" ,
                             @"%2c" , @"%5b" , @"%5d",
                             @"%23", @"%21", @"%27",
                             @"%28", @"%29", @"%2a", nil];
    
    NSUInteger len = [escapeChars count];
    
    NSMutableString *temp = [url mutableCopy];
    
    int i;
    for(i = 0; i < len; i++){
        
        [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    NSString *out = [NSString stringWithString: temp];
    
    return out;
}


//static NSString* urlformdata_encode(NSString* s) {
//    CFStringRef charactersToLeaveUnescaped = CFSTR(" ");
//    CFStringRef legalURLCharactersToBeEscaped = CFSTR("!$&'()+,/:;=?@~");
//    
//    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
//                                                                                 kCFAllocatorDefault,
//                                                                                 (__bridge CFStringRef)s,
//                                                                                 charactersToLeaveUnescaped,
//                                                                                 legalURLCharactersToBeEscaped,
//                                                                                 kCFStringEncodingUTF8));
//    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//}


@end
