#import <Foundation/Foundation.h>

@interface SyndicatePlusApiBase : NSObject <NSURLConnectionDelegate>

@property(strong,nonatomic) NSString* apiKey;
@property(strong,nonatomic) NSString* apiSecret;
@property(strong,nonatomic) NSString* apiEndpoint;
@property(strong,nonatomic) NSString* version;
@property(strong,nonatomic) NSDictionary* header;

- (NSData *)sendRequest:(NSString *)resource withQuery:(NSString *)queryString;
-(NSString *)prepareQueryString:(NSString *)queryString;
-(NSString *) urlencode: (NSString *) url;
-(SyndicatePlusApiBase *) initWithPublicKey: (NSString *)publicKey andSecretKey:(NSString *)privateKey;
@end
