#import "QueryString.h"

@implementation QueryString
@synthesize queryString,keyValueDict;


-(QueryString *)initWithQueryString :(NSString *)givenQueryString{
    keyValueDict=[[NSMutableDictionary alloc]init];
    self.queryString=givenQueryString;
    return self;
}

-(NSMutableDictionary *)extractKeyValue:(NSString *)givenQueryString{
  //  NSLog(@"called %@",queryString);
     NSString *data;
    NSArray *components;
    NSArray *keyValueArray;
    if ([givenQueryString rangeOfString:@"&"].location == NSNotFound) {
      //  NSLog(@"string does not contain &");
        keyValueArray=[givenQueryString componentsSeparatedByString:@"="];
        [keyValueDict setObject:[keyValueArray objectAtIndex:1] forKey:[keyValueArray objectAtIndex:0]];
       //  NSLog(@"key: %@ value: %@",[keyValueArray objectAtIndex:0],[keyValueArray objectAtIndex:1]);

    } else {
       components =[queryString componentsSeparatedByString:@"&"];
        if(components.count>0){
            for(int i=0;i<components.count;i++){
                data=[components objectAtIndex:i];
                keyValueArray=[data componentsSeparatedByString:@"="];
                [keyValueDict setObject:[keyValueArray objectAtIndex:1] forKey:[keyValueArray objectAtIndex:0]];
              //   NSLog(@"key: %@ value: %@",[keyValueArray objectAtIndex:0],[keyValueArray objectAtIndex:1]);
            }

        }      
    }
          return keyValueDict;
}


@end
