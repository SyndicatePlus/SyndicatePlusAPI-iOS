/**
 * The ManufacturerApi class is a simple wrapper around the SyndicatePlusApiBase
 * class to provide quick access to API resources through named functions.
 * Output of all these functions is the Manufacturer object.
 */

#import "ManufacturerApi.h"

@implementation ManufacturerApi
@synthesize syndicateBase;


/*
 Initialize the ManufacturerApi
 */

-(ManufacturerApi *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey{
    NSString *apiKey=publicKey;
    NSString *secretKey=privateKey;
    syndicateBase=[[SyndicatePlusApiBase alloc]initWithPublicKey:apiKey andSecretKey:secretKey];
   // syndicateBase=[[SyndicatePlusApiBase alloc]initWithPublicKey:publicKey andSecretKey:publicKey];
    return self;
}

/**
 * Returns a list of manufacturers that matched the manufacturer search query
 *
 * @access public
 * @param $manufacturerQuery	 The string to search for
 * @return array
 */
-(NSArray *) searchByQuery:(NSString *)manufacturerQuery {
    NSMutableArray *manufacturers=[[NSMutableArray alloc]init];
    Manufacturer *manufacturerData=[[Manufacturer alloc]init];
    
    NSString *encodedQuery=[manufacturerQuery stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* dataResponse=[syndicateBase sendRequest:@"manufacturers/" withQuery:encodedQuery];
    //parse response
    NSError *error=nil;
    NSMutableArray *returnedManufacturersArray = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    
    for(id retunredManufacturer in returnedManufacturersArray){
        manufacturerData=[[Manufacturer alloc]init];
        manufacturerData.manufacturerName = (NSString*)[retunredManufacturer objectForKey:@"Name"];
        manufacturerData.manufacturerDescription = (NSString*)[retunredManufacturer objectForKey:@"Description"];
        manufacturerData.website = (NSString*)[retunredManufacturer objectForKey:@"Website"];
        manufacturerData.manufacturerId=(NSString*)[retunredManufacturer objectForKey:@"Id"];
        
        [manufacturers addObject:manufacturerData];
    }
    
    
    return manufacturers;
}

/**
 * Returns a single manufacturer result if a manufacturer is found matching
 * the specified manufacturer Id.
 *
 * @access public
 * @param manufacturertId 			The id of the manufacturer to look up
 * @return Manufacturer object
 */

-(Manufacturer*) getManufacturerById:(NSString *) manufacturertId {
    
    Manufacturer *manufacturerData=[[Manufacturer alloc]init];
    
    NSData* dataResponse=[syndicateBase sendRequest:[@"manufacturers/manufacturer/" stringByAppendingString:manufacturertId] withQuery:@""];
    //parse response
    NSError *error=nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    manufacturerData.manufacturerName=(NSString*)[json objectForKey:@"Name"];
    manufacturerData.manufacturerId=(NSString*)[json objectForKey:@"Id"];
    manufacturerData.manufacturerDescription=(NSString*)[json objectForKey:@"Description"];
    manufacturerData.website=(NSString*)[json objectForKey:@"Website"];
    return manufacturerData;
}


@end
