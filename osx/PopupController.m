#import "PopupController.h"
@implementation PopupController

+ (bool)isAppSetToRunAtLogon {
	NSString* script = [[NSBundle mainBundle] pathForResource:@"CheckLoginItem.scpt" ofType:nil];
	NSURL* url = [NSURL fileURLWithPath: script];
	NSAppleScript* as = [[NSAppleScript alloc] initWithContentsOfURL: url error:nil];
	
	return YES;
}

- (IBAction)toggleOpenAtLogon:(id)sender {
    
}

- (void)menuWillOpen:(NSMenu *)menu {
	[openAtLogonMenu setState: [PopupController isAppSetToRunAtLogon] ? NSOnState : NSOffState];
}

@end
