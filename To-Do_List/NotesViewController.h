#import <UIKit/UIKit.h>

@interface NotesViewController : UIViewController

@property (nonatomic, strong) NSDate * eventDate;
@property (nonatomic, strong) NSString *eventInfo;
@property (nonatomic, assign) BOOL isDetail;

@end

