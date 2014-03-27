/**
 * The NutrientApi class is a simple wrapper around the SyndicatePlusApiBase
 * class to provide quick access to API resources through named functions.
 * Output of all these functions is the Nutritient object.
 */


#import "NutrientApi.h"

@implementation NutrientApi

@synthesize syndicateBase;


/*
 Initialize the NutrientApi
 */

-(NutrientApi *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey{
    NSString *apiKey=publicKey;
    NSString *secretKey=privateKey;
    syndicateBase=[[SyndicatePlusApiBase alloc]initWithPublicKey:apiKey andSecretKey:secretKey];
    return self;
}

/**
 * Returns a list of Nutrients
 *
 * @access public
 * @return array
 */
-(NSArray *) getAllNutrients {
    NSMutableArray *nutrientArray=[[NSMutableArray alloc]init];
    Nutrient *nutrientData=[[Nutrient alloc]init];
    NSData* dataResponse=[syndicateBase sendRequest:@"nutrients" withQuery:@""];
    //parse response
    NSError *error=nil;
    NSMutableArray *returnedNutrients = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    
    for(id retunredNutrient in returnedNutrients){
        nutrientData=[[Nutrient alloc]init];
        nutrientData.nutrientName = (NSString*)[retunredNutrient objectForKey:@"Name"];
        nutrientData.nutrientId = (NSString*)[retunredNutrient objectForKey:@"Id"];
        nutrientData.nutrientDecription = (NSString*)[retunredNutrient objectForKey:@"Description"];
        
        [nutrientArray addObject:nutrientData];
    }
    return nutrientArray;
}


@end
