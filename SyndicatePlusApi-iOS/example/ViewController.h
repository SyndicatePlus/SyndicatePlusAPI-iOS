#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData* responseData;
@property (strong, nonatomic) IBOutlet UITextView *headerText;
@property (strong, nonatomic) IBOutlet UITextView *valueText;

@end
