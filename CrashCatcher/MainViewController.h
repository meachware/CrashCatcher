//
//  MainViewController.h
//  CrashCatcher
//
//  Created by Greg Meach on 7/9/11.
//  Copyright 2011 MeachWare. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> 
{

    UISwitch *simulateCrashSwitch;
    
}

@property (assign) IBOutlet UISwitch *simulateCrashSwitch;


- (IBAction)showInfo:(id)sender;
- (IBAction)simulateCrash:(id)sender;

@end
