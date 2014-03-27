#import <Foundation/Foundation.h>
#import "Brand.h"
#import "Nutrient.h"
#import "Manufacturer.h"
#import "Allergens.h"

@interface ProductData : NSObject

@property(strong,nonatomic) NSArray* allergenArray;
@property(strong,nonatomic) Brand* brand;
@property(strong,nonatomic) NSString* description;
@property(strong,nonatomic) NSString* ingredients;
@property(strong,nonatomic) NSString* productId;
@property(strong,nonatomic) NSString* imageUrl;
@property(strong,nonatomic) Manufacturer* manufacturer;
@property(strong,nonatomic) NSString* productName;
@property(strong,nonatomic) NSArray* nutritionArray;

@end
