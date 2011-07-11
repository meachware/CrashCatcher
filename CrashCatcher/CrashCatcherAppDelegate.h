//
//  CrashCatcherAppDelegate.h
//  CrashCatcher
//
//  Created by Greg Meach on 7/9/11.
//  Copyright 2011 MeachWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface CrashCatcherAppDelegate : NSObject <UIApplicationDelegate> 
{
    BOOL isAniPad;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end
