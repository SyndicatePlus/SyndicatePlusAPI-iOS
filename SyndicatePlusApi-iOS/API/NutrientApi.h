#import <Foundation/Foundation.h>
#import "Nutrient.h"
#import "SyndicatePlusApiBase.h"

@interface NutrientApi : NSObject

@property(strong,nonatomic) SyndicatePlusApiBase* syndicateBase;
-(NSArray*) getAllNutrients;
-(NutrientApi *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey;

@end
