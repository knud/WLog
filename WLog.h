//
//  WLog.h
//  KleerControl
//
//  Created by Steven Knudsen on 2010/05/06.
//  2010 TechConficio Inc.. No rights reserved, do what you want with this...
//

#import <Foundation/Foundation.h>
#include <arpa/inet.h>

#define WLOG_DEFAULT_PORT 5169 // from http://www.iana.org/assignments/port-numbers 5169-5189  Unassigned
#define WLOG_DEFAULT_IP_ADDR @"10.0.0.2"

#define WLOG_NOTIFICATION @"WLogNotification"
#define WLOG_STRING_KEY @"WLogString"

// only define this if we need it
// A good place to define WLOGGING is in the precompiled header file (.pch)
#ifdef WLOGGING
#define WLOG(__STRING) [[NSNotificationCenter defaultCenter] postNotificationName:WLOG_NOTIFICATION object:self userInfo:[NSDictionary dictionaryWithObject:__STRING forKey:WLOG_STRING_KEY]];	
#else
#define WLOG(...) /* */
#endif

@interface WLog : NSObject {
	NSString *ipAddress;
	BOOL enabled;
	
	// using BSD sockets
	int udpSocket;
	int port;
	struct sockaddr_in targetAddress;
}
@property(nonatomic,assign,getter=isEnabled)BOOL enabled;

+ (id)sharedWLog;

@end
