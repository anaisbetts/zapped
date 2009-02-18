#import "Controller.h"
#import <Carbon/Carbon.h>

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
- (IBAction)doIt:(id)sender {
	ProcessSerialNumber psn = {0, kNoProcess};
	unsigned char proc_name[512];
	ProcessInfoRec pir = {0};
	pir.processInfoLength = sizeof(pir);
	pir.processName = proc_name;
	
	OSErr err;
	
	while((err = GetNextProcess(&psn)) == noErr) {
		bzero(proc_name, 512 * sizeof(char));
		if ((err = GetProcessInformation(&psn, &pir)) == noErr) {
			if (processInWhiteList(proc_name))
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
@end
