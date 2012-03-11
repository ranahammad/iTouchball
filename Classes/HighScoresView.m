//
//  HighScoresView.m
//  theBall
//
//  Created by Faisal Saeed on 5/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HighScoresView.h"
#import "theBallAppDelegate.h"

@interface HighScoresView (private)
theBallAppDelegate *appDelegate;
@end

@implementation HighScoresView

@synthesize m_pGameSelectorSegmentControl;
@synthesize m_pScoreTextView;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
		appDelegate = [[UIApplication sharedApplication] delegate];
//		[m_pScoreTextView setFont:[UIFont systemFontOfSize:13.0]];
		[m_pScoreTextView setText:@""];
		[m_pGameSelectorSegmentControl setSelectedSegmentIndex:0];
        // Custom initialization
    }
    return self;
}

-(NSString*) formatIntValue:(int) value length:(int) pLength
{
	NSString* formattedValue = [NSString stringWithFormat:@"%d",value];
	int diffLength = pLength - [formattedValue length];
	
	while (diffLength>0) 
	{
		formattedValue = [NSString stringWithFormat:@"0%@",formattedValue];
		diffLength--;
	}
	return formattedValue;
}

-(NSString*) formatStrValue:(NSString*)strVal length:(int)pLength
{
	if([strVal length] <= pLength)
		return strVal;
	
	NSString *finalStr = [strVal substringToIndex:pLength-4];
	finalStr = [finalStr stringByAppendingString:@"..."];
	return finalStr;
}

-(void) DisplayHighScores:(int) iselectedGame
{
	NSMutableArray *pScoreRecords = [[appDelegate m_pHighScoresRepositoryController] 
									 loadRecordsFromTableOrderBy:SCORE_COL3_SCORE 
									 orderType:1 
									 condition:[NSString stringWithFormat:@"WHERE %@ = %d",SCORE_COL4_GAME,iselectedGame]];
	
	NSString *scoreTextView = @"";
	
	for(int i=0; i<[pScoreRecords count]; i++)
	{
		NSMutableArray *pRecord = [pScoreRecords objectAtIndex:i];
		int score = [[pRecord objectAtIndex:3] intValue];
		int level = [[pRecord objectAtIndex:2] intValue];
		scoreTextView = [scoreTextView stringByAppendingFormat:@"%@  %@  %@\n",[self formatIntValue:level length:2],[self formatIntValue:score length:8],[self formatStrValue:[pRecord objectAtIndex:1] length:16]];
	}
	
	[m_pScoreTextView setText:scoreTextView];
}

-(void) viewDidLoad
{
	[super viewDidLoad];
	[m_pGameSelectorSegmentControl setSelectedSegmentIndex:[appDelegate m_iGameSelected]];
	[self DisplayHighScores:[appDelegate m_iGameSelected]];
}

/*
#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if(component==0)
		return 200;
	return 0;
}

// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse. 
// If you return back a different object, the old one will be released. the view will be centered in the row rect  
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if(row>=0 && row < [[appDelegate m_pGamesArray] count])
		return [[appDelegate m_pGamesArray] objectAtIndex:row];
	
	return @"";
}

#pragma mark UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	switch(component)
	{
		case 0:
			return [[appDelegate m_pGamesArray] count];
		default:
			return 0;
	}
}*/

-(IBAction) mainSreenViewBtnClicked
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(IBAction) reloadScoresBtnClicked
{
	[self DisplayHighScores:[m_pGameSelectorSegmentControl selectedSegmentIndex]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
