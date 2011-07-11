//
//  CrashCatcherAppDelegate.m
//  CrashCatcher
//
//  Created by Greg Meach on 7/9/11.
//  Copyright 2011 MeachWare. All rights reserved.
//

#import "CrashCatcherAppDelegate.h"
#import "MainViewController.h"
#import "DevLogViewController.h"

@implementation CrashCatcherAppDelegate


@synthesize window=_window;

@synthesize mainViewController=_mainViewController;

- (void)initDefaults 
{	
    isAniPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    // this only runs if there are no user defaults
	if(![userDefaults valueForKey:kTestKey]) {
        [userDefaults setValue:@"TestKey" forKey:kTestKey];
		[userDefaults setBool:YES forKey:kDidResignOK];
        
		[userDefaults synchronize];
	}
}

-(void)crashLogNotice
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System Error:\nIncomplete Shutdown"
                                                    message:@"Please log any comments, then tap \"Send\". Please sync your device with iTunes.\nThank-you for your help."
                                                   delegate:self 
                                          cancelButtonTitle:nil 
                                          otherButtonTitles:@"Okay", nil];
    [alert show];
    [alert release];
}

-(void)showDevLog 
{
	if(isAniPad) {
        DevLogViewController *vc = [[DevLogViewController alloc] initWithNibName:@"DevLogForm-iPad" bundle:nil];
		vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.mainViewController presentModalViewController:vc animated:YES];
        [vc release];
    } else {
        DevLogViewController *vc = [[DevLogViewController alloc] initWithNibName:@"DevLog" bundle:nil];
        [self.mainViewController presentModalViewController:vc animated:YES];
        [vc release];        
    }
    [self performSelector:@selector(crashLogNotice) withObject:self afterDelay:0.6];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the main view controller's view to the window and display.
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    
    [self initDefaults];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:kSimulateCrash]) {
        [userDefaults setBool:YES forKey:kDidResignOK];
        [userDefaults synchronize];        
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:kDidResignOK]) {
        [self performSelector:@selector(showDevLog) withObject:self afterDelay:1.0];
    } else
        [userDefaults setBool:NO forKey:kDidResignOK];
    
    [userDefaults synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [super dealloc];
}

@end
