#import "ViewController.h"
#import "ProductsApi.h"
#import "ProductData.h"
#import "SyndicatePlusApiBase.h"
#import  "QueryString.h"
#import "NutrientApi.h"
#import "AllergenApi.h"
#import "Allergens.h"
#import "Nutrient.h"
#import "Manufacturer.h"
#import "ManufacturerApi.h"
#import "BrandApi.h"
#import "Brand.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize responseData;

- (void) viewDidLoad
{
    // Send synchronous request
 NSString *apiKey=@"VGtfOvZdZTEikLIGj1NlSREe3zk2viGZs4JuURtmAaDMkSD3bSd1j01nqGdxrvZNsdDzxB1KgvoQEiyaNdoJGFaNcrGaobTpMwH1XojeHNa7p6NKYYqsPvy-_e4AOfmoOmwB5rr0txACezP4UvsPHIUYrgFxcG6kI6NDzrvk7w4=";
NSString *apiSecret=@"J852mcN8XLqt29sBvTPY48TdIUIhMFP0H8HmZntuy_ushrmsHoJ3Cxeq4LkidvHn9rSdYshKRxmuEk_R05n4hTaFM1sVjZ0Xg0IxQfi6kwdfn9htQS6TSnT4dHjEhhdGuBEYVznfch1uZKPsWXx_mNbh_PLyRrZ36Snx8bJPXxk=";

    ProductsApi *productsApi=[[ProductsApi alloc]initWithPublicKey:apiKey andSecretKey:apiSecret];
   ProductData *data=[productsApi getProductById:@"420d6006-a171-4217-8155-af13c848bbbd"];
//   ProductData *data=[productsApi getProductByEan:@"8711200189106"];
    //Display results
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, 290, 280)];
    webView.clipsToBounds = YES;
    webView.layer.cornerRadius = 5;
    [webView setBackgroundColor:[UIColor clearColor]];
    
    NSString *image=[NSString stringWithFormat:@"<img height=\"80\" style=\"float: left; margin: 10px;\" src=\"%@\" />",data.imageUrl];
    NSString *productName = [NSString stringWithFormat:@"<p><font color=\"#1569C7\" >Product Name:</font> %@</p>", data.productName];
    NSString *productBrand = [NSString stringWithFormat:@"<p><font color=\"#1569C7\" >Brand:</font> %@</p>", data.brand.brandName];
    NSString *productManf = [NSString stringWithFormat:@"<p><font color=\"#1569C7\" >Manufacturer:</font> %@</p>", data.manufacturer.manufacturerName];
    
    [webView loadHTMLString:[NSString stringWithFormat:@"<div style=\"font-family: Arial;\">%@ %@ %@ %@</div>", image,productName, productBrand, productManf] baseURL:Nil];
    
    [self.view addSubview:webView];
    
  
    /*
     Uncomment to access Product API
     */
    
  //  NSArray *dataArray=[productsApi searchByQuery:@"q=productname:Heinz&offset=10"];
//    NSArray *dataArray=[productsApi searchByProductName:@"Heinz"];
//    for(int i=0;i<dataArray.count;i++){
//        ProductData *data=[dataArray objectAtIndex:i];
//        NSLog(@"name: %@",data.productName);
//        NSLog(@"brand: %@",data.brand.brandName);
//        NSLog(@"manf: %@",data.manufacturer.manufacturerName);
//    }

  
/*
 Uncomment to access Nutritient API
 */
    
//    NutrientApi *nutrientApi=[[NutrientApi alloc]initWithPublicKey:apiKey andSecretKey:apiSecret];
//     NSArray *dataArray=[nutrientApi getAllNutrients];
//    for(int i=0;i<dataArray.count;i++){
//        Nutrient *data=[dataArray objectAtIndex:i];
//        NSLog(@"Name%@",data.nutrientName);
//        NSLog(@"ID %@",data.nutrientId);
//        NSLog(@"Desp %@",data.nutrientDecription);
//    }
    
    /*
     Uncomment to access Allergens API
     */

    
//    AllergenApi *allergenApi=[[AllergenApi alloc]initWithPublicKey:apiKey andSecretKey:apiSecret];
//    NSArray *dataArray=[allergenApi getAllAllergens];
//    for(int i=0;i<dataArray.count;i++){
//        Allergens *data=[dataArray objectAtIndex:i];
//        NSLog(@"Name%@",data.allergenName);
//        NSLog(@"ID %@",data.allergenId);
//        NSLog(@"Desp %@",data.allergenDescription);
//    }
    
    
    /*
     Uncomment to access Manufacturer API
     */

    
  //   ManufacturerApi *manfApi=[[ManufacturerApi alloc]initWithPublicKey:apiKey andSecretKey:apiSecret];
//    NSArray *dataArray=[manfApi searchByQuery:@"q=name:mar"];
//    for(int i=0;i<dataArray.count;i++){
//        Manufacturer *data=[dataArray objectAtIndex:i];
//        NSLog(@"Name%@",data.manufacturerName);
//        NSLog(@"ID %@",data.manufacturerId);
//        NSLog(@"Desp %@",data.manufacturerDescription);
//    }
    
//     Manufacturer *data=[manfApi getManufacturerById:@"9ec7e172-c2f8-461e-8197-0e0a26abb647"];
//        NSLog(@"Name%@",data.manufacturerName);
//        NSLog(@"ID %@",data.manufacturerId);
//        NSLog(@"Desp %@",data.manufacturerDescription);
    
    /*
     Uncomment to access Brand API
     */
    
  //     BrandApi *brandApi=[[BrandApi alloc]initWithPublicKey:apiKey andSecretKey:apiSecret];
//        NSArray *dataArray=[brandApi searchByQuery:@"q=name:hein"];
//        for(int i=0;i<dataArray.count;i++){
//            Brand *data=[dataArray objectAtIndex:i];
//            NSLog(@"Name%@",data.brandName);
//            NSLog(@"ID %@",data.brandId);
//            NSLog(@"Desp %@",data.brandDescription);
//        }
    
    
//         Brand *data=[brandApi getBrandById:@"b942d46b-0e3a-4f26-b2ef-fe05d97759a7"];
//    NSLog(@"Name%@",data.brandName);
//    NSLog(@"ID %@",data.brandId);
//    NSLog(@"Desp %@",data.brandDescription);

}


@end
