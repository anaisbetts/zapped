#import <Cocoa/Cocoa.h>

@interface Controller : NSObject {
	NSStatusItem* StatusItem;
}
- (IBAction)doIt:(id)sender;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
@end
