//
//  theBallViewController.m
//  theBall
//
//  Created by Faisal Saeed on 5/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "theBallViewController.h"
#import "AudioToolbox/AudioToolbox.h"
#import "QuartzCore/CAAnimation.h"

#import "theBallAppDelegate.h"

#import "CFirstGame.h"
#import "CSecondGame.h"

#define kGameStateRunning	1
#define kGameStatePaused	2

#define kMaxLevels		15

#define kGameSpeed				 0.005
#define	kIncrementGameSpeed		-0.0002

#define XPOSITION	160
#define YPOSITION	240

#define SCREEN_BOUNDARY_LEFT	00
#define SCREEN_BOUNDARY_TOP		00
#define SCREEN_BOUNDARY_RIGHT	320
#define SCREEN_BOUNDARY_BOTTOM	460

#define GAME_DURATION		60// 60 seconds

@interface theBallViewController (private)
UIAlertView * m_pGameEndedAlert;
id m_pGameRunningID;
theBallAppDelegate *appDelegate;
-(void) startNewLevelTimer;

@end

@implementation theBallViewController

@synthesize m_pMovingBalls;
@synthesize m_pImageBall;
@synthesize m_plabelScore;
@synthesize m_pMainOptionView;
@synthesize m_pSaveScoreView;
@synthesize m_pGameView;
@synthesize m_pBackgroundImage;

@synthesize m_pGameNameLabel;
@synthesize m_pGameScoreCountLabel;
@synthesize m_pGameTimeLeftLabel;

@synthesize m_pLevelView;
@synthesize m_pTimerScore;
@synthesize m_pLevelLabel;
@synthesize m_pGeneratedBalls;
@synthesize m_pCurrentScoreTextViewLabels;
@synthesize m_pCurrentScoreTextView;
@synthesize m_pTapToContinue;
@synthesize m_pStartingLevelIndicator;
@synthesize m_pTimeLeftProgress;
//@synthesize m_pGamePickerView;
@synthesize m_pPlayerNameTextField;
@synthesize m_pSetNameAsDefaultBtn;
@synthesize m_pSubmitScoreBtn;
@synthesize m_pCancelSubmitScoreBtn;
@synthesize m_pGameSelectorSegmentControl;
@synthesize m_pGameDescription;
@synthesize m_pQuitGameButton;

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc 
{
    [super dealloc];
	
	if(m_pTimerScore)
	{
		[m_pTimerScore invalidate];
		m_pTimerScore = nil;
	}
	
	if(m_pGameRunningID)
	{
		[m_pGameRunningID invalidate];
		m_pGameRunningID = nil;
	}
	
	if(m_pCurrentGame != nil)
	{
		m_pCurrentGame.m_bGameRunning = FALSE;
		[m_pCurrentGame release];
		m_pCurrentGame = nil;
	}
	
	[m_plabelScore release];
	[m_pImageBall release];
	[m_pMainOptionView release];
	[m_pSaveScoreView release];
	[m_pLevelView release];
	[m_pLevelLabel release];
	
	if(m_pMovingBalls != nil)
	{
		[m_pMovingBalls removeAllObjects];
		[m_pMovingBalls release];
		m_pMovingBalls = nil;
	}
	
	[m_pGameView release];	
	[m_pGameNameLabel release];
	[m_pGameScoreCountLabel release];
	[m_pGameTimeLeftLabel release];
	
	[m_pTimerScore release];
	[m_pCurrentScoreTextViewLabels release];
	[m_pCurrentScoreTextView release];
	[m_pTapToContinue release];
	[m_pStartingLevelIndicator release];
	[m_pTimeLeftProgress release];
	//@synthesize m_pGamePickerView;
	[m_pPlayerNameTextField release];
	[m_pSetNameAsDefaultBtn release];
	[m_pSubmitScoreBtn release];
	[m_pCancelSubmitScoreBtn release];
	[m_pGameSelectorSegmentControl release];
	[m_pGameDescription release];
	[m_pQuitGameButton release];	
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	m_pGameRunningID = nil;
	m_pTimerScore = nil;
	appDelegate = [[UIApplication sharedApplication] delegate];	
	
	[m_pCurrentScoreTextViewLabels setText:@""];
//	[m_pCurrentScoreTextViewLabels setFont:[UIFont systemFontOfSize:14.0]];
	
	[m_pCurrentScoreTextView setText:@""];
//	[m_pCurrentScoreTextView setFont:[UIFont systemFontOfSize:14.0]];
	
	[m_pGameNameLabel setText:@""];
	
	[m_pGameScoreCountLabel setText:@""];
	
	[m_pGameTimeLeftLabel setText:@"60 secs"];
	
	m_iSelectedGame = 0;
	[m_pQuitGameButton setHidden:TRUE];
	
	[m_pGameSelectorSegmentControl setSelectedSegmentIndex:0];
	[m_pGameDescription setText:[[appDelegate m_pGamesArrayDescription] objectAtIndex:0]];
		
}

-(void) gameLoop
{
	if([m_pCurrentGame m_bGameRunning] && m_iTimeRemaining>0)
	{
		[m_pCurrentGame gameLoop];
		[m_pGameScoreCountLabel setText:[NSString stringWithFormat:@"%d",m_pCurrentGame.m_iDivisionCount - m_pCurrentGame.m_iMergeCount]];
	}
	else //if(m_iTimeRemaining == 0 || [m_pCurrentGame m_bGameEnded])
	{
		m_pCurrentGame.m_bGameRunning = FALSE;
		[self gameEnded];
	}
}

-(void) gameEnded
{
	if(m_pTimerScore != nil)
	{
		[m_pTimerScore invalidate];
		m_pTimerScore = nil;
	}
	if(m_pGameRunningID != nil)
	{
		[m_pGameRunningID invalidate];
		m_pGameRunningID = nil;
	}

	m_bScreenTouched = FALSE;

	if(m_iGameState == kGameStateRunning)
	{		
		m_iGameState = kGameStatePaused;
		
		if(appDelegate.m_bGameSound)
			AudioServicesPlaySystemSound(appDelegate.m_pSoundClapping);
		
		NSInteger levelScore = 0;
		
		NSString *strCurrentScore = nil;
		
		if(appDelegate.m_iGameSelected == 0)
		{
			[m_pCurrentScoreTextViewLabels setText:@"Time Bonus:\nBalls Bonus:\n\nLevel Score:\nTotal Score:"];
			
			levelScore = m_iTimeRemaining*100 + (m_pCurrentGame.m_iDivisionCount - m_pCurrentGame.m_iMergeCount)*10;
			
			m_iScore += levelScore;
			strCurrentScore = [[NSString alloc] initWithFormat:@"%d\n%d\n\n%d\n%d", 
										 m_iTimeRemaining*100,
										 (m_pCurrentGame.m_iDivisionCount - m_pCurrentGame.m_iMergeCount)*10,levelScore, m_iScore];
			
			[m_pCurrentScoreTextView setText:strCurrentScore];
			[strCurrentScore release];
			
			if(m_iTimeRemaining == 0)
			{
				[self saveScore:[NSString stringWithFormat:@"Time up, you reached %d Level with %d points",m_iLevel,m_iScore]];
				return;
			}
		}
		else if(appDelegate.m_iGameSelected == 1)
		{
			
			NSInteger iExtraBonus = (m_pCurrentGame.m_iDivisionCount - m_pCurrentGame.m_iMergeCount) * 100;
			
			levelScore += iExtraBonus;
			if(iExtraBonus >= 0)
				levelScore += (m_pCurrentGame.m_iMergeCount * 50);
			
			m_iScore += levelScore;
			if(levelScore>=0)
			{
				[m_pCurrentScoreTextViewLabels setText:@"Protection Points:\nProtection Bonus:\n\n\nLevel Score:\nTotal Score:"];
				strCurrentScore = [[NSString alloc] initWithFormat:@"%d\n%d\n\n\n%d\n%d",
								   (m_pCurrentGame.m_iMergeCount * 50),
								   (m_pCurrentGame.m_iDivisionCount - m_pCurrentGame.m_iMergeCount)*100, levelScore, m_iScore];
				[m_pCurrentScoreTextView setText:strCurrentScore];
				[strCurrentScore release];
			}
			else
			{
				[self saveScore:[NSString stringWithFormat:@"Time up, you reached %d Level with %d points",m_iLevel,m_iScore]];
				return;			
			}
		}
		
		m_iLevel++;
		if(m_iLevel==kMaxLevels)
			[self saveScore:[NSString stringWithFormat:@"Congratulations, you have completed all %d Levels",kMaxLevels]];
		else	
			[self startNewLevelTimer];
	}
	m_iGameState = kGameStatePaused;

}

-(void) saveScore:(NSString*) strTitle
{
	m_pGameEndedAlert = [[UIAlertView alloc] initWithTitle:strTitle 
												   message:[NSString stringWithFormat:@"You scored %d points", m_iScore] delegate:self 
										 cancelButtonTitle:@"OK" 
										 otherButtonTitles:nil];
	[m_pGameEndedAlert show];
}

-(void) updateScore:(id) sender
{
	m_iTimeRemaining--;
	if(m_iTimeRemaining > 1)
		[m_pGameTimeLeftLabel setText:[NSString stringWithFormat:@"%d secs",m_iTimeRemaining]];
	else
		[m_pGameTimeLeftLabel setText:[NSString stringWithFormat:@"%d sec",m_iTimeRemaining]];
	
	[m_pTimeLeftProgress setProgress:(1.0*m_iTimeRemaining/(GAME_DURATION*1.0))];
	
	if(m_iTimeRemaining == 0)
	{
		if(m_pTimerScore != nil)
		{
			[m_pTimerScore invalidate];
			m_pTimerScore = nil;
		}		
	}
}

#pragma mark UIAlertView related functionality
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView == m_pGameEndedAlert)
	{
		[alertView release];
		
		//	m_iScore;
///		CATransition* trans = [CATransition animation];
	//	[trans setType:kCATransitionReveal];
	//	[trans setSubtype:kCATransitionFade];
	//	[trans setDuration:1.0];
		[self.view addSubview:m_pSaveScoreView];
		[self.view bringSubviewToFront:m_pSaveScoreView];
		if(m_pCurrentView == m_pGameView)
		{
			[m_pGameView removeFromSuperview];
			m_pCurrentView = nil;
		}
		m_pCurrentView = m_pSaveScoreView;
	//	[[self.view layer] addAnimation:trans forKey:@"Transistion"];
		
	}
}

#pragma mark Touches related functionality
-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	if(m_pCurrentView == m_pLevelView && m_bStartingLevel == FALSE && m_iGameState == kGameStatePaused)
	{
		[m_pTapToContinue setHidden:TRUE];
		[m_pQuitGameButton setHidden:TRUE];
		[m_pLevelView removeFromSuperview];		
		[self.view addSubview:m_pGameView];
		[m_pCurrentGame makeViewVisible];
		m_pCurrentGame.m_bGameVisible = TRUE;
		m_pCurrentView = m_pGameView;
		m_iTimeRemaining = GAME_DURATION;
		m_iGameState = kGameStateRunning;
		m_pTimerScore = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateScore:) userInfo:nil repeats:TRUE];
		return;
	}
	else if(m_iGameState == kGameStateRunning)
	{
		m_bScreenTouched = TRUE;
		
		[m_pCurrentGame touchesBegan:touches withEvent:event];
		m_iTouchCount--;
		[self touchesMoved:touches withEvent:event];
	}
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch *touch = [[event allTouches] anyObject];
	m_ptScreenTouched = [touch locationInView:touch.view];
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	m_bScreenTouched = FALSE;
}

-(void) startNewLevel
{
	if(m_pCurrentView == m_pLevelView)
	{
		m_iTouchCount = 0;
		m_iMergeCount = 0;
		// reset the level time
		m_iTimeRemaining = GAME_DURATION;		
		[m_pTimeLeftProgress setProgress:(m_iTimeRemaining/GAME_DURATION)];
		[m_pGameTimeLeftLabel setText:[NSString stringWithFormat:@"%d secs",m_iTimeRemaining]];
		
		m_bScreenTouched = FALSE;
		m_iGameState = kGameStatePaused;
		
		m_fSpeedSelected += kIncrementGameSpeed;
			
		//reset the gameloop timer
		if(m_pTimerScore != nil)
		{
			[m_pTimerScore invalidate];
			m_pTimerScore = nil;
		}
				
		[m_pStartingLevelIndicator setHidden:TRUE];
		[m_pTapToContinue setHidden:FALSE];
		[m_pQuitGameButton setHidden:FALSE];
		[m_pCurrentGame startNewLevel:m_iLevel];
		[m_pGameScoreCountLabel setText:[NSString stringWithFormat:@"%d",m_pCurrentGame.m_iDivisionCount - m_pCurrentGame.m_iMergeCount]];

		[m_pBackgroundImage setImage:[appDelegate getBgImage:m_iLevel]];
		m_pGameRunningID = [NSTimer scheduledTimerWithTimeInterval:m_fSpeedSelected 
															target:self 
														  selector:@selector(gameLoop) 
														  userInfo:nil 
														   repeats:YES];
		m_bStartingLevel = FALSE;
		m_pCurrentGame.m_bGameVisible = FALSE;
	}	
}

-(void) startNewLevelTimer
{
	m_bStartingLevel = TRUE;
	[self.view addSubview:m_pLevelView];
	[self.view bringSubviewToFront:m_pLevelView];
	if(m_pCurrentView == m_pGameView)
	{
		[m_pGameView removeFromSuperview];
		m_pCurrentView = nil;
	}

	m_pCurrentView = m_pLevelView;

	[m_pLevelLabel setText:[NSString stringWithFormat:@"Starting Level %d",m_iLevel]];
	
	[m_pStartingLevelIndicator setHidden:FALSE];
	[m_pTapToContinue setHidden:TRUE];
	[m_pQuitGameButton setHidden:TRUE];
		
	[NSTimer scheduledTimerWithTimeInterval:1.0 
									 target:self 
								   selector:@selector(startNewLevel) 
								   userInfo:nil 
									repeats:NO];
}

- (void) startNewGame:(int)iGameSelected
{
	m_iLevel = 1;
	m_iScore = 0;
	m_iMergeCount = 0;
	m_iTouchCount = 0;
	
	[m_pCurrentScoreTextViewLabels setText:@""];
	[m_pCurrentScoreTextView setText:@""];
	
	m_fSpeedSelected = (kGameSpeed + ([appDelegate m_fGameSpeed] * kIncrementGameSpeed));
	[m_pGameNameLabel setText:[[appDelegate m_pGamesArray] objectAtIndex:iGameSelected]];

	if(m_pCurrentGame != nil)
		[m_pCurrentGame release];
	
	m_iSelectedGame = iGameSelected;
	
	switch (iGameSelected)
	{
		case 0:
			m_pCurrentGame =  [[CFirstGame alloc] initWithPlayArea:m_pGameView 
													  boundingRect:CGRectMake(SCREEN_BOUNDARY_LEFT, SCREEN_BOUNDARY_TOP, SCREEN_BOUNDARY_RIGHT - SCREEN_BOUNDARY_LEFT, SCREEN_BOUNDARY_BOTTOM - SCREEN_BOUNDARY_TOP)];
			
			[self startNewLevelTimer];
			break;
		case 1:
			m_fSpeedSelected -= (3*kIncrementGameSpeed);
			m_pCurrentGame =  [[CSecondGame alloc] initWithPlayArea:m_pGameView 
													  boundingRect:CGRectMake(SCREEN_BOUNDARY_LEFT, SCREEN_BOUNDARY_TOP, SCREEN_BOUNDARY_RIGHT - SCREEN_BOUNDARY_LEFT, SCREEN_BOUNDARY_BOTTOM - SCREEN_BOUNDARY_TOP)];
			[self startNewLevelTimer];
			break;
		default:
			break;
	}
}

#pragma mark IBActions

- (IBAction) playGameBtnClicked
{
	[self startNewGame:appDelegate.m_iGameSelected];
}

- (IBAction) mainScreenBtnClicked
{
	if(m_pCurrentGame != nil)
	{
		m_pCurrentGame.m_bGameRunning = FALSE;
		[m_pCurrentGame release];
		m_pCurrentGame = nil;
	}
	
	if(m_pGameRunningID != nil)
	{
		[m_pGameRunningID invalidate];
		m_pGameRunningID = nil;
	}
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark save score screen methods

-(IBAction) endKeyboard
{
	
}

- (IBAction) submitScoreBtnClicked
{
	if(m_pCurrentView == m_pSaveScoreView)
	{
		NSString *strName = [m_pPlayerNameTextField text];
		if([strName length] == 0)
			strName = [appDelegate m_strDefaultName];

		[appDelegate saveScore:strName 
					  gameType:[appDelegate m_iGameSelected] 
						 level:m_iLevel 
						 score:m_iScore];
		[m_pSaveScoreView removeFromSuperview];
		m_pCurrentView = nil;
	}
}

- (IBAction) cancelSubmitScoreBtnClicked
{
	if(m_pCurrentView == m_pSaveScoreView)
	{
		[m_pSaveScoreView removeFromSuperview];
		m_pCurrentView = nil;
	}
}

- (IBAction) setNameAsDefaultBtnClicked
{
	if([[m_pPlayerNameTextField text] length] > 0)
		[appDelegate updateDefaultName:[m_pPlayerNameTextField text]];
}

- (IBAction) gameSelectorSegmentControlClicked
{
	appDelegate.m_iGameSelected = [m_pGameSelectorSegmentControl selectedSegmentIndex];
	[m_pGameDescription setText:[[appDelegate m_pGamesArrayDescription] objectAtIndex:appDelegate.m_iGameSelected]];
}

/*
#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if(component==0)
		return 320;
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
}
*/

@end