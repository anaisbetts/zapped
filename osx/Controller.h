#import <Cocoa/Cocoa.h>

@interface Controller : NSObject {
}

- (IBAction)executeZap:(id)sender;
- (void)shouldHideStatusBarItemOnTimer:(NSTimer*)theTimer;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

@end
