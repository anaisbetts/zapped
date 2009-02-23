#import <Cocoa/Cocoa.h>

@interface PopupController : NSObject {
    IBOutlet id openAtLogonMenu;
}

+ (bool)isAppSetToRunAtLogon;
- (IBAction)toggleOpenAtLogon:(id)sender;

@end