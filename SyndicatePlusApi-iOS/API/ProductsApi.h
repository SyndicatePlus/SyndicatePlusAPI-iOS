#import <Foundation/Foundation.h>
#import "ProductData.h"
#import "SyndicatePlusApiBase.h"

@interface ProductsApi : NSObject

@property(strong,nonatomic) SyndicatePlusApiBase* syndicateBase;
-(ProductData*) getProductById:(NSString *) productId ;
-(ProductData*) getProductByEan:(NSString *) ean ;
-(NSArray *) searchByQuery:(NSString *)productQuery ;
-(NSArray *) searchByProductName:(NSString *)productName;
-(ProductsApi *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey;
@end
