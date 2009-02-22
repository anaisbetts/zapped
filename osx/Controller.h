#import <Cocoa/Cocoa.h>
#import "PTHotKey.h"

@interface Controller : NSObject {
    IBOutlet id popupMenu;
	PTHotKey* hotkey;
}

- (IBAction)executeZap:(id)sender;
- (void)shouldHideStatusBarItemOnTimer:(NSTimer*)theTimer;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)applicationWillTerminate:(NSNotification *)aNotification;

@end
