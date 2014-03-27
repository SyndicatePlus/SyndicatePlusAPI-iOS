#import <Foundation/Foundation.h>
#import "Manufacturer.h"
#import "SyndicatePlusApiBase.h"

@interface ManufacturerApi : NSObject

@property(strong,nonatomic) SyndicatePlusApiBase* syndicateBase;
-(Manufacturer*) getManufacturerById:(NSString *) manufacturerId ;
-(NSArray *) searchByQuery:(NSString *)manufacturerQuery ;
-(ManufacturerApi *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey;

@end
