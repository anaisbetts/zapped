#import "Controller.h"
#import <Carbon/Carbon.h>
#import "PTHotKeyCenter.h"
#import "PTHotKey.h"

const char* kProcessWhiteList[] = {
	"loginwindow",
	"Dock",
	"Finder",
//	"Xcode",
	"Zapped",
	NULL
};

BOOL processInWhiteList(const char* process)
{
	const char** current = kProcessWhiteList;
	do {
		// For some unknown reason, this always starts with a junk character
		if (!strcmp(process+1, *current)) {
			return YES;
		}
	} while (*(++current));
	return NO;
}

@implementation Controller

- (IBAction)executeZap:(id)sender {
	ProcessSerialNumber psn = {0, kNoProcess};
	unsigned char proc_name[512];
	ProcessInfoRec pir = {0};
	pir.processInfoLength = sizeof(pir);
	pir.processName = proc_name;
	
	OSErr err;
	
	while((err = GetNextProcess(&psn)) == noErr) {
		bzero(proc_name, 512 * sizeof(char));
		if ((err = GetProcessInformation(&psn, &pir)) == noErr) {
			if (processInWhiteList((char*)proc_name))
				continue;
			NSLog(@"Process Name is '%s'", pir.processName);
			KillProcess(&psn);
		}		
	}
	
	// Launch our logout script
	NSString* script = [[NSBundle mainBundle] pathForResource:@"LogOut.scpt" ofType:nil];
	NSURL* url = [NSURL fileURLWithPath: script];
	NSAppleScript* as = [[NSAppleScript alloc] initWithContentsOfURL: url error:nil];
	[as executeAndReturnError: nil];

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSStatusItem* statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:175];
	NSString* image = [[NSBundle mainBundle] pathForResource:@"StatusBarIcon.png" ofType:nil];
	NSURL* image_url = [NSURL fileURLWithPath: image];
	[statusItem setImage: [[NSImage alloc] initWithContentsOfURL:image_url]];
	[statusItem setToolTip:@"Test!"];
	[statusItem setTitle:@"Zap is now enabled!"];
	[statusItem setTarget: self];
	[statusItem setMenu:popupMenu];
	[statusItem retain];
	
	// Hide the status item after 5 seconds
	[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)5.0
									 target:self 
								   selector:@selector(shouldHideStatusBarItemOnTimer:) 
								   userInfo:statusItem
									repeats:NO];
	
	// Retain the StatusItem - we'll release it in shouldHideStatusBar...
	[statusItem retain];
	
	// Register a hotkey
	hotkey = [[PTHotKey alloc] initWithIdentifier: self 
										 keyCombo: [PTKeyCombo keyComboWithKeyCode:0x33 modifiers: cmdKey+controlKey]];
	[hotkey setTarget:self];
	[hotkey setAction:@selector(executeZap:)];
	[[PTHotKeyCenter sharedCenter] registerHotKey: hotkey];
}

- (void)shouldHideStatusBarItemOnTimer:(NSTimer*)theTimer {
	NSStatusItem* item = [theTimer userInfo];
	[[NSStatusBar systemStatusBar] removeStatusItem: item];
	[item release];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Drop our hotkey
	if (hotkey) {
		[[PTHotKeyCenter sharedCenter] unregisterHotKey:hotkey];
		[hotkey release];
	}
}

@end
