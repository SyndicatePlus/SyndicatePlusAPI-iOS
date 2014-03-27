/**
 * The BrandApi class is a simple wrapper around the SyndicatePlusApiBase
 * class to provide quick access to API resources through named functions.
 * Output of all these functions is the Manufacturer object.
 */

#import "BrandApi.h"

@implementation BrandApi
@synthesize syndicateBase;

/*
 Initialize the BrandApi
 */

-(BrandApi *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey{
    NSString *apiKey=publicKey;
    NSString *secretKey=privateKey;
    syndicateBase=[[SyndicatePlusApiBase alloc]initWithPublicKey:apiKey andSecretKey:secretKey];
    return self;
}

/**
 * Returns a list of brands that matched the brand search query
 *
 * @access public
 * @param $brandQuery	 The string to search for
 * @return array
 */
-(NSArray *) searchByQuery:(NSString *)brandQuery {
    NSMutableArray *brands=[[NSMutableArray alloc]init];
    Brand *brandData=[[Brand alloc]init];
    
    NSString *encodedQuery=[brandQuery stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* dataResponse=[syndicateBase sendRequest:@"brands/" withQuery:encodedQuery];
    //parse response
    NSError *error=nil;
    NSMutableArray *returnedManufacturersArray = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    
    for(id retunredManufacturer in returnedManufacturersArray){
        brandData=[[Brand alloc]init];
        brandData.brandName = (NSString*)[retunredManufacturer objectForKey:@"Name"];
        brandData.brandDescription = (NSString*)[retunredManufacturer objectForKey:@"Description"];
        brandData.website = (NSString*)[retunredManufacturer objectForKey:@"Website"];
        brandData.brandId=(NSString*)[retunredManufacturer objectForKey:@"Id"];
        brandData.manfId=(NSString*)[retunredManufacturer objectForKey:@"ManufacturerId"];
        
        [brands addObject:brandData];
    }
    
    
    return brands;
}

/**
 * Returns a single brand result if a brand is found matching
 * the specified brand Id.
 *
 * @access public
 * @param brandId 			The id of the brand to look up
 * @return Manufacturer object
 */

-(Brand*) getBrandById:(NSString *) brandId {
    
    Brand *brandData=[[Brand alloc]init];
    
    NSData* dataResponse=[syndicateBase sendRequest:[@"brands/brand/" stringByAppendingString:brandId] withQuery:@""];
    //parse response
    NSError *error=nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    brandData.brandName=(NSString*)[json objectForKey:@"Name"];
    brandData.brandId=(NSString*)[json objectForKey:@"Id"];
    brandData.brandDescription=(NSString*)[json objectForKey:@"Description"];
    brandData.website=(NSString*)[json objectForKey:@"Website"];
    brandData.manfId=(NSString*)[json objectForKey:@"ManufacturerId"];
    return brandData;
}



@end
