/**
 * The ProductsApi class is a simple wrapper around the SyndicatePlusApiBase
 * class to provide quick access to API resources through named functions.
 * Output of all these functions is the ProductData object.
 */

#import "ProductsApi.h"


@implementation ProductsApi
@synthesize syndicateBase;


/*
 Initialize the ProductsApi
 */

-(ProductsApi *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey{
    NSString *apiKey=publicKey;
    NSString *secretKey=privateKey;
    syndicateBase=[[SyndicatePlusApiBase alloc]initWithPublicKey:apiKey andSecretKey:secretKey];
   // syndicateBase=[[SyndicatePlusApiBase alloc]initWithPublicKey:publicKey andSecretKey:privateKey];
    return self;
}


/**
 * Returns a list of products that matched the product name
 *
 * @access public
 * @param $productName	 The productName to search for
 * @return array
 */
-(NSArray *) searchByProductName:(NSString *)productName {
    NSMutableArray *products=[[NSMutableArray alloc]init];
    ProductData *productData=[[ProductData alloc]init];
    
    NSString *encodedQuery=[productName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* dataResponse=[syndicateBase sendRequest:@"products/" withQuery:[@"q=productname:" stringByAppendingString:encodedQuery]];
       //parse response
    NSError *error=nil;
    NSMutableArray *returnedProductsArray = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    
    for(id retunredProduct in returnedProductsArray){
        productData=[self parseToProductObject:retunredProduct];
        [products addObject:productData];
    }
    return products;
}

/**
 * Returns a list of products that matched the product search query
 *
 * @access public
 * @param $productQuery	 The string to search for
 * @return array
 */
-(NSArray *) searchByQuery:(NSString *)productQuery {
    NSMutableArray *products=[[NSMutableArray alloc]init];
    ProductData *productData=[[ProductData alloc]init];
    
    NSString *encodedQuery=[productQuery stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* dataResponse=[syndicateBase sendRequest:@"products/" withQuery:encodedQuery];
    //parse response
    NSError *error=nil;
    NSMutableArray *returnedProductsArray = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
  
    for(id retunredProduct in returnedProductsArray){
        productData=[self parseToProductObject:retunredProduct];
        [products addObject:productData];
    }
    return products;
}

/**
 * Returns a single product result if a product is found matching
 * the specified product Id.
 *
 * @access public
 * @param productId 			The id of the product to look up
 * @return ProductData object
 */

-(ProductData*) getProductById:(NSString *) productId {
    //send request
    NSData* dataResponse=[syndicateBase sendRequest:[@"products/product/" stringByAppendingString:productId] withQuery:@""];
    //parse response
    NSError *error=nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    ProductData *productData=[self parseToProductObject:json];
    return productData;
}


/**
 * Returns a single product result if a product is found matching
 * the specified product EAN code.
 *
 * @access public
 * @param ean 					The to-be-looked up EAN code
 * @return ProductData object
 */
-(ProductData*) getProductByEan:(NSString *) ean {
    NSData* dataResponse=[syndicateBase sendRequest:@"products/product/" withQuery:[@"ean=" stringByAppendingString:ean]];
    //parse response
    NSError *error=nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    //put data in iOS object
    ProductData *productData=[self parseToProductObject:json];
    return productData;

}

/**
 Simple function to parse the returned JSON string to ProductData object.
 */

-(ProductData*) parseToProductObject:(NSMutableDictionary *) json {
    
    ProductData *productData=[[ProductData alloc]init];
    Brand *brandData=[[Brand alloc]init];
    Manufacturer *manfData=[[Manufacturer alloc]init];
    Nutrient *nutritientData=[[Nutrient alloc]init];
    Allergens *allergenData=[[Allergens alloc]init];
    NSMutableArray *nutritientsArray=[[NSMutableArray alloc]init];
    NSMutableArray *allergensArray=[[NSMutableArray alloc]init];
    
    
    
    //create Brand object
    NSMutableDictionary *jsonBrand=[json objectForKey:@"Brand"];
    brandData.brandName=(NSString*)[jsonBrand objectForKey:@"Name"];
    brandData.brandId=(NSString*)[jsonBrand objectForKey:@"Id"];
    brandData.manfId=(NSString*)[jsonBrand objectForKey:@"ManufacturerId"];
    brandData.website=(NSString*)[jsonBrand objectForKey:@"Website"];
    brandData.brandDescription=(NSString*)[jsonBrand objectForKey:@"Description"];
    productData.brand=brandData;
    
    //create Manufacturer object
    NSMutableDictionary *jsonManufacturer=[json objectForKey:@"Manufacturer"];
    manfData.manufacturerName=(NSString*)[jsonManufacturer objectForKey:@"Name"];
    manfData.manufacturerId=(NSString*)[jsonManufacturer objectForKey:@"Id"];
    manfData.website=(NSString*)[jsonManufacturer objectForKey:@"Website"];
    manfData.manufacturerDescription=(NSString*)[jsonManufacturer objectForKey:@"Description"];
    productData.manufacturer=manfData;
    
    //create Allergen object and add to Allergens Array
    NSMutableArray *returnedAllergensArray=[json objectForKey:@"Allergens"];
    for(id jsonAllergens in returnedAllergensArray){
        allergenData=[[Allergens alloc]init];
        allergenData.allergenName = (NSString*)[jsonAllergens objectForKey:@"Name"];
        allergenData.allergenId = (NSString*)[jsonAllergens objectForKey:@"Id"];
        allergenData.allergenDescription = (NSString*)[jsonAllergens objectForKey:@"Description"];
        [allergensArray addObject:allergenData];
    }
    
    //create Nutritient object and add to Nutritient Array
    NSMutableArray *returnedNutritientArray=[json objectForKey:@"Nutrients"];
    for(id jsonNutritient in returnedNutritientArray){
        nutritientData=[[Nutrient alloc]init];
        nutritientData.nutrientName = (NSString*)[jsonNutritient objectForKey:@"Name"];
        nutritientData.nutrientId = (NSString*)[jsonNutritient objectForKey:@"Id"];
        nutritientData.nutrientDecription = (NSString*)[jsonNutritient objectForKey:@"Description"];
        [allergensArray addObject:allergenData];
    }
    
    productData.allergenArray=allergensArray;
    productData.nutritionArray=nutritientsArray;
    productData.description = (NSString*)[json objectForKey:@"Description"];
    productData.ingredients = (NSString*)[json objectForKey:@"Ingredients"];
    productData.productId=(NSString*)[json objectForKey:@"Id"];
    productData.imageUrl=(NSString*)[json objectForKey:@"ImageUrl"];
    productData.productName=(NSString*)[json objectForKey:@"Name"];
    //productData.nutritionArray=(NSArray*)[json objectForKey:@"Nutrition"];

    return productData;
}



@end
