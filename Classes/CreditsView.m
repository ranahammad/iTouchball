//
//  CreditsView.m
//  theBall
//
//  Created by Faisal Saeed on 5/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CreditsView.h"


@implementation CreditsView

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


- (IBAction) mainScreenBtnClicked
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction) vahzayBtnClicked
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.vahzay.com"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
