//
//  MainOptionView.m
//  theBall
//
//  Created by Faisal Saeed on 5/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainOptionView.h"
#import "theBallAppDelegate.h"
#import "HighScoresView.h"
#import "CreditsView.h"
#import "SettingsView.h"
#import "theBallViewController.h"

@interface MainOptionView (private)
theBallAppDelegate *appDelegate;
@end

@implementation MainOptionView


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
        // Custom initialization
    }
    return self;
}

-(IBAction) newGameBtnClicked
{
	theBallViewController *pBallGameViewController = [[theBallViewController alloc] initWithNibName:@"theBallViewController" bundle:[NSBundle mainBundle]];
	[self presentModalViewController:pBallGameViewController animated:YES];
	[pBallGameViewController release];
}

-(IBAction) settingsBtnClicked
{
	SettingsView *pSettingsViewController = [[SettingsView alloc] initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
	[self presentModalViewController:pSettingsViewController animated:YES];
	[pSettingsViewController release];	
}

-(IBAction) highScoresBtnClicked
{
	HighScoresView *pHighScoresViewController = [[HighScoresView alloc] initWithNibName:@"HighScoresViewController" bundle:[NSBundle mainBundle]];
	[self presentModalViewController:pHighScoresViewController animated:YES];
	[pHighScoresViewController release];
}

-(IBAction) creditsBtnClicked
{
	CreditsView *pCreditsViewController = [[CreditsView alloc] initWithNibName:@"CreditsViewController" bundle:[NSBundle mainBundle]];
	[self presentModalViewController:pCreditsViewController animated:YES];
	[pCreditsViewController release];
}

-(void) viewDidLoad
{
	[super viewDidLoad];
}

-(void) viewWillAppear:(BOOL) bAnimated
{
	[super viewWillAppear:bAnimated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc 
{
    [super dealloc];
}


@end
