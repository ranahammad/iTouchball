//
//  SettingsView.m
//  theBall
//
//  Created by Faisal Saeed on 5/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsView.h"
#import "theBallAppDelegate.h"

@interface SettingsView (private)
theBallAppDelegate *appDelegate;
@end

@implementation SettingsView
@synthesize m_pGameSoundSwitch;
@synthesize m_pGameVibrationSwitch;
@synthesize m_pGameSpeedSlider;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
        // Custom initialization
		appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void) loadSettings
{
	[m_pGameSoundSwitch setOn:[appDelegate m_bGameSound]];
	[m_pGameVibrationSwitch setOn:[appDelegate m_bGameVibration]];
	[m_pGameSpeedSlider setValue:[appDelegate m_fGameSpeed]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	[self loadSettings];
}

-(IBAction) mainScreenBtnClicked
{
	[appDelegate updateSettings:[m_pGameSpeedSlider value] sound:[m_pGameSoundSwitch isOn] vibration:[m_pGameVibrationSwitch isOn]];
	// save settings
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
