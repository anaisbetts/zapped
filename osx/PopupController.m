#import "PopupController.h"
#import "UKLoginItemRegistry.h"

@implementation PopupController

+ (bool)isAppSetToRunAtLogon {
	int ret = [UKLoginItemRegistry indexForLoginItemWithPath:[[NSBundle mainBundle] bundlePath]];
	NSLog(@"login item index = %i", ret);
	return (ret >= 0);
}

- (IBAction)toggleOpenAtLogon:(id)sender {
	if ([PopupController isAppSetToRunAtLogon]) {
		[UKLoginItemRegistry removeLoginItemWithPath:[[NSBundle mainBundle] bundlePath]];
	} else {
		[UKLoginItemRegistry addLoginItemWithPath:[[NSBundle mainBundle] bundlePath] hideIt: NO];
	}
}

- (void)menuWillOpen:(NSMenu *)menu {
	[openAtLogonMenu setState: [PopupController isAppSetToRunAtLogon] ? NSOnState : NSOffState];
}

@end
