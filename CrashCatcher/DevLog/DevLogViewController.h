// 
//  DevLogViewController.h
//
//  Created by Gregory Meach on 11-02-01.
//  http://meachware.com

//  Copyright (c) 2010 Gregory Meach, MeachWare.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define kDevFileName        @"DevLog.txt"
#define kDidResignOK        @"didResignOK"
#define kTestKey            @"testKey"
#define kSimulateCrash      @"simulateCrash"

@interface DevLogViewController : UIViewController <UITextFieldDelegate,MFMailComposeViewControllerDelegate> {
    
	UITextView *text;
	UINavigationBar *saveBar;
	UINavigationBar *viewBar;
	UILabel *sizeOftext;
	CGRect textFrameSize;
	BOOL weAreEditing;
	BOOL isAniPad;

}

@property (nonatomic, retain) IBOutlet UITextView *text;
@property (nonatomic, retain) IBOutlet UINavigationBar *saveBar;
@property (nonatomic, retain) IBOutlet UINavigationBar *viewBar;
@property (nonatomic, retain) IBOutlet UILabel *sizeOftext;


-(IBAction)enableEditMode;
-(IBAction)closeViewAction;
-(IBAction)saveLogFile;
-(IBAction)sendEmailAction;


@end
