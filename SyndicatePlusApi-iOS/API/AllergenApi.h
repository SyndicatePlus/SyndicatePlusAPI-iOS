#import <Foundation/Foundation.h>
#import "Allergens.h"
#import "SyndicatePlusApiBase.h"

@interface AllergenApi : NSObject

@property(strong,nonatomic) SyndicatePlusApiBase* syndicateBase;
-(NSArray*) getAllAllergens;
-(AllergenApi *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey;


@end
