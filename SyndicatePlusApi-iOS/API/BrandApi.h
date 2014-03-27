#import <Foundation/Foundation.h>
#import "Brand.h"
#import "SyndicatePlusApiBase.h"

@interface BrandApi : NSObject

@property(strong,nonatomic) SyndicatePlusApiBase* syndicateBase;
-(Brand*) getBrandById:(NSString *) brandId ;
-(NSArray *) searchByQuery:(NSString *)brandQuery ;
-(BrandApi *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey;

@end
