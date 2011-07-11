// 
//  DevLogViewController.m
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

#import "DevLogViewController.h"


@implementation DevLogViewController

@synthesize text, sizeOftext, saveBar, viewBar;

-(void)dealloc {
	[text release]; text = nil;
	[sizeOftext release]; sizeOftext = nil;
	[saveBar release]; saveBar = nil;
	[viewBar release]; viewBar = nil;
	
	[super dealloc];
}

-(void)viewDidUnload {
	[super viewDidUnload];
	self.text = nil;
	self.sizeOftext = nil;
	self.saveBar = nil;
	self.viewBar = nil;	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		isAniPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
	}	
	return self;
}

-(NSString*)fullDevLogFileWithPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:kDevFileName];
    
    return documentTXTPath;
}

-(void)loadFile {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterMediumStyle];
    NSString *today = [format stringFromDate:[NSDate date]];
    [format release];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self fullDevLogFileWithPath]]) {
        self.text.text = [NSString stringWithFormat:@"%@\n%@",[NSString stringWithContentsOfFile:[self fullDevLogFileWithPath] encoding:NSUTF8StringEncoding error:nil],today];
    } else {
        self.text.text = [NSString stringWithFormat:@"%@",today];
    }    
}

-(void)saveFile {
    NSData *fileData = [[NSData alloc] initWithData:[text.text dataUsingEncoding:NSUTF8StringEncoding]];
	[fileData writeToFile:[self fullDevLogFileWithPath] atomically:TRUE];
    [fileData release];
}

-(void)removeDevLogFile
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self fullDevLogFileWithPath]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self fullDevLogFileWithPath] error:NULL];
    }
}

-(void)viewDidLoad {
	[super viewDidLoad];
	if (isAniPad)
		self.text.font = [UIFont systemFontOfSize:24.0];
	else 
		self.text.font = [UIFont systemFontOfSize:14.0];
    
	[self loadFile];
	
	self.sizeOftext.text = [NSString stringWithFormat:@"Current Size: %i", [text.text length]];	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)setUpMailAccount {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System Error"
													message:@"Please setup a mail account first."
												   delegate:self 
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Compose Mail
// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet {
	if(![MFMailComposeViewController canSendMail]) {
		[self setUpMailAccount];
		return;
	}
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    NSArray *toRecipients = [NSArray arrayWithObject:@"your_name@here.com"]; 
    [picker setToRecipients:toRecipients];

    [picker setSubject:[NSString stringWithFormat:@"Error Report"]];
    NSString *emailBody = [NSString stringWithFormat:@"%@",self.text.text];
    emailBody = [NSString stringWithFormat:@"%@\n\nDeveloper: http://yoursite.com\n",emailBody];
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceModel = device.model;
    NSString *deviceOS = device.systemVersion;
    NSString *gameVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    emailBody = [NSString stringWithFormat:@"%@\nDevice: %@\niOS Version: %@\nApp Version: %@\n",emailBody,deviceModel,deviceOS,gameVersion];

    [picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
    if (result == MFMailComposeResultSent) { //mail sent
        // you should thank the user
        self.text.text = @"";
    }
}

-(IBAction)sendEmailAction {
    [self displayComposerSheet];
}

- (void)updateThisView {
	UIDeviceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	textFrameSize = self.text.frame;
    CGRect contentFrame = self.view.bounds;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
		if (weAreEditing) {
			if (isAniPad) {
                if (contentFrame.size.width > 650.0)
                    self.text.frame = CGRectMake(34.0, 70.0, 936.0, 566.0 - 240);
                else
                    self.text.frame = CGRectMake(20.0, 55.0, 502.0, 470.0 - 130);
			} else 
				self.text.frame = CGRectMake(5.0, 49.0, 470, 118);				
		} else {
			if (isAniPad) {
                if (contentFrame.size.width > 650.0)
                    self.text.frame = CGRectMake(34.0, 70.0, 936.0, 566.0);
                else
                    self.text.frame = CGRectMake(20.0, 55.0, 502.0, 470.0);                
			} else 
				self.text.frame = CGRectMake(5.0, 49.0, 470, 192);				
		}
    }
	else { 
		if (weAreEditing) {
			if (isAniPad) {
                if (contentFrame.size.width > 650.0)
				self.text.frame = CGRectMake(34.0, 70.0, 700.0, 842.0 - 220);
			} else 
				self.text.frame = CGRectMake(5.0, 49.0, 310, 193);				
		} else {
			if (isAniPad) {
                if (contentFrame.size.width > 650.0)
				self.text.frame = CGRectMake(34.0, 70.0, 700.0, 842.0);
			} else 
				self.text.frame = CGRectMake(5.0, 49.0, 310, 352);				
		}
    }    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self performSelector:@selector(updateThisView) withObject:nil afterDelay:0.0];
}

-(IBAction)enableEditMode {
	self.text.editable = TRUE;
	weAreEditing = TRUE;
	[self.text becomeFirstResponder];
	self.viewBar.hidden = TRUE;
	self.saveBar.hidden = FALSE;
	[self updateThisView];
}

-(IBAction)saveLogFile {
	self.text.editable = FALSE;
	weAreEditing = FALSE;
	[self.text resignFirstResponder];
	self.viewBar.hidden = FALSE;
	self.saveBar.hidden = TRUE;
 
    NSData *fileData = [[NSData alloc] initWithData:[text.text dataUsingEncoding:NSUTF8StringEncoding]];
	[fileData writeToFile:[self fullDevLogFileWithPath] atomically:TRUE];
    [fileData release];
        
	self.sizeOftext.text = [NSString stringWithFormat:@"Current Size: %i", [text.text length]];	
	[self updateThisView];
	
}

-(IBAction)closeViewAction {
    [self saveFile];
	[self dismissModalViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
	weAreEditing = TRUE;
	self.viewBar.hidden = TRUE;
	self.saveBar.hidden = FALSE;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	weAreEditing = FALSE;
	self.viewBar.hidden = FALSE;
	self.saveBar.hidden = TRUE;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


@end
