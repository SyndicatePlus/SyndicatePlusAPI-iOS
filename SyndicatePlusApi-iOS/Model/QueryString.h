#import <Foundation/Foundation.h>

@interface QueryString : NSObject

@property(strong,nonatomic) NSMutableArray *keyArray;
@property(strong,nonatomic) NSMutableArray *valueArray;
@property(strong,nonatomic) NSString *queryString;
@property(strong,nonatomic) NSMutableDictionary *keyValueDict;
-(QueryString *)initWithQueryString :(NSString *)givenQueryString;
-(NSMutableDictionary *)extractKeyValue :(NSString *)givenQueryString;

@end
