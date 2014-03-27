/**
 * The AllergenApi class is a simple wrapper around the SyndicatePlusApiBase
 * class to provide quick access to API resources through named functions.
 * Output of all these functions is the Allergens object.
 */


#import "AllergenApi.h"

@implementation AllergenApi
@synthesize syndicateBase;


/*
 Initialize the ProductsApi
 */

-(AllergenApi *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey{
    NSString *apiKey=publicKey;
    NSString *secretKey=privateKey;
    syndicateBase=[[SyndicatePlusApiBase alloc]initWithPublicKey:apiKey andSecretKey:secretKey];
   // syndicateBase=[[SyndicatePlusApiBase alloc]initWithPublicKey:publicKey andSecretKey:publicKey];
    return self;
}

/**
 * Returns a list of allergens
 *
 * @access public
 * @return array
 */
-(NSArray *) getAllAllergens {
    NSMutableArray *allergensArray=[[NSMutableArray alloc]init];
    Allergens *allergenData=[[Allergens alloc]init];
    NSData* dataResponse=[syndicateBase sendRequest:@"allergens" withQuery:@""];
    //parse response
    NSError *error=nil;
    NSMutableArray *returnedAllergens = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    
    for(id retunredAllergen in returnedAllergens){
        allergenData=[[Allergens alloc]init];
        allergenData.allergenName = (NSString*)[retunredAllergen objectForKey:@"Name"];
        allergenData.allergenId = (NSString*)[retunredAllergen objectForKey:@"Id"];
        allergenData.allergenDescription = (NSString*)[retunredAllergen objectForKey:@"Description"];
        
        [allergensArray addObject:allergenData];
    }
    return allergensArray;
}


@end
