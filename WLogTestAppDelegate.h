//
//  WLogTestAppDelegate.h
//  WLogTest
//
//  Created by Steven Knudsen on 2010/05/06.
//  2010 TechConficio Inc.. No rights reserved, do what you want with this...
//

#import <UIKit/UIKit.h>

@class WLogTestViewController;

@interface WLogTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WLogTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WLogTestViewController *viewController;

@end

