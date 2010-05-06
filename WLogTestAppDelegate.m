//
//  WLogTestAppDelegate.m
//  WLogTest
//
//  Created by Steven Knudsen on 2010/05/06.
//  2010 TechConficio Inc.. No rights reserved, do what you want with this...
//

#import "WLogTestAppDelegate.h"
#import "WLogTestViewController.h"
#import "WLog.h"

@implementation WLogTestAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	WLog *wlogger = [WLog sharedWLog];
	[wlogger setEnabled:YES];
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
