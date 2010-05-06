//
//  WLog.m
//  KleerControl
//
//  Created by Steven Knudsen on 2010/05/06.
//  2010 TechConficio Inc.. No rights reserved, do what you want with this...
//

#import "WLog.h"
#include <unistd.h>
#include <netdb.h>
#include <errno.h>


@implementation WLog

@synthesize enabled;

static WLog *sharedInstance = nil; 

+ (void)initialize
{
	if (sharedInstance == nil)
		sharedInstance = [[self alloc] init];
}

+ (id)sharedWLog
{
	//Already set by +initialize.
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone
{
	//Usually already set by +initialize.
	@synchronized(self) {
		if (sharedInstance) {
			//The caller expects to receive a new object, so implicitly retain it
			//to balance out the eventual release message.
			return [sharedInstance retain];
		} else {
			//When not already set, +initialize is our caller.
			//It's creating the shared instance, let this go through.
			return [super allocWithZone:zone];
		}
	}
}

- (id)init
{
	//If sharedInstance is nil, +initialize is our caller, so initialize the instance.
	//If it is not nil, simply return the instance without re-initializing it.
	if (sharedInstance == nil) {
		if ((self = [super init])) {
			//Initialize the instance here.
#ifdef WLOG_ALT_IP_ADDR
			ipAddress = WLOG_ALT_IP_ADDR;
#else
			ipAddress = WLOG_DEFAULT_IP_ADDR;
#endif
#ifdef WLOG_ALT_PORT
			port = WLOG_ALT_PORT;
#else
			port = WLOG_DEFAULT_PORT;
#endif
			enabled = NO;
			
			// make a socket
			// create socket
			udpSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
			// init in broadcast mode
			int broadcast = 1;
			setsockopt(udpSocket, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof(int));
			
			memset((char *) &targetAddress, 0, sizeof(targetAddress));
			targetAddress.sin_family = AF_INET;
			// broadcast mask is Fs
			targetAddress.sin_addr.s_addr = htonl(0xFFFFFFFF);
			targetAddress.sin_port = htons(port);
			targetAddress.sin_len = sizeof(targetAddress);
			
			// last, register for notifications to log stuff...
			// listen to updates from AccelerometerViewControl
			[[NSNotificationCenter defaultCenter] addObserver:self 
																							 selector:@selector(logIt:) 
																									 name:WLOG_NOTIFICATION 
																								 object:nil];
			
		}
	}
	return self;
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}
- (id)retain
{
	return self;
}
- (unsigned)retainCount
{
	return UINT_MAX; // denotes an object that cannot be released
}
- (void)release
{
	// do nothing 
}
- (id)autorelease
{
	return self;
}

- (void)logIt:(NSNotification *)notification
{
#pragma mark TODO - check for other objects to report (e.g., custom objs)
	// check for NSString to log
	NSMutableString *logString = [NSMutableString stringWithCapacity:20];
	NSDate *now = [NSDate date];
	[logString appendFormat:@"WLOG:%@|",[[now description] substringToIndex:19]];
	if ([[notification object] isKindOfClass:[NSString class]]) {
		[logString appendFormat:@"%@\n",(NSString *)[notification object]];
	}
	// only process is network is enabled and socket initialized OK
	if( enabled && (udpSocket != -1) )
	{
		// create UDP packet as formatted string
		// "ACC: <deviceid>,<timestamp>,<x>,<y>,<z>"
		const char *msg = [logString UTF8String];
		int error = sendto(udpSocket, msg, strlen(msg), 0, (struct sockaddr*)&targetAddress, sizeof(targetAddress));
		if( error < 0 )
		{
			NSLog(@"Socket error %d", errno);
		}
	}
	
}			 

@end

