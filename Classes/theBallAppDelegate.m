//
//  theBallAppDelegate.m
//  theBall
//
//  Created by Faisal Saeed on 5/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "theBallAppDelegate.h"
#import "SplashViewController.h"

@implementation theBallAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize m_pBallImage;
@synthesize m_pBallImage1;
@synthesize m_pBallImage2;
@synthesize m_pBallImage3;
@synthesize m_pBallImage4;
@synthesize m_pBallImage5;
@synthesize m_pBallImage6;
@synthesize m_pBallImage7;
@synthesize m_pBallImage8;
@synthesize m_pBallImage9;
@synthesize m_pBallImage10;
@synthesize m_pBallImage11;
@synthesize m_pBallImage12;

@synthesize m_pbackgroundImage1;
@synthesize m_pbackgroundImage2;
@synthesize m_pbackgroundImage3;
@synthesize m_pbackgroundImage4;
@synthesize m_pbackgroundImage5;
@synthesize m_pbackgroundImage6;
@synthesize m_pbackgroundImage7;
@synthesize m_pbackgroundImage8;
@synthesize m_pbackgroundImage9;
@synthesize m_pbackgroundImage10;
@synthesize m_pbackgroundImage11;
@synthesize m_pbackgroundImage12;
@synthesize m_pbackgroundImage13;
@synthesize m_pbackgroundImage14;
@synthesize m_pbackgroundImage15;
@synthesize m_pbackgroundImage16;

@synthesize m_pHighScoresRepositoryController;
@synthesize m_pGameSettingsRepositoryController;

@synthesize m_fGameSpeed;
@synthesize m_bGameSound;
@synthesize m_bGameVibration;
@synthesize m_strDefaultName;
@synthesize m_iGameSelected;

@synthesize m_pGamesArray;
@synthesize m_pGamesArrayDescription;
@synthesize m_pSound1;
@synthesize m_pSound2;
@synthesize m_pSoundClapping;

- (void) loadImages
{
	m_pBallImage	= [UIImage imageNamed:@"nb17.png"];
	m_pBallImage1	= [UIImage imageNamed:@"nb1.png"];
	m_pBallImage2	= [UIImage imageNamed:@"nb2.png"];
	m_pBallImage3	= [UIImage imageNamed:@"nb3.png"];
	m_pBallImage4	= [UIImage imageNamed:@"nb4.png"];
	m_pBallImage5	= [UIImage imageNamed:@"nb5.png"];
	m_pBallImage6	= [UIImage imageNamed:@"nb6.png"];
	m_pBallImage7	= [UIImage imageNamed:@"nb7.png"];
	m_pBallImage8	= [UIImage imageNamed:@"nb8.png"];
	m_pBallImage9	= [UIImage imageNamed:@"nb9.png"];
	m_pBallImage10	= [UIImage imageNamed:@"nb10.png"];
	m_pBallImage11	= [UIImage imageNamed:@"nb11.png"];
	m_pBallImage12	= [UIImage imageNamed:@"nb12.png"];	
	
	m_pbackgroundImage1 = [UIImage imageNamed:@"nbg12.jpg"];
	m_pbackgroundImage2 = [UIImage imageNamed:@"nbg13.jpg"];
	m_pbackgroundImage3 = [UIImage imageNamed:@"nbg14.jpg"];
	m_pbackgroundImage4 = [UIImage imageNamed:@"nbg15.jpg"];
	m_pbackgroundImage5 = [UIImage imageNamed:@"nbg16.jpg"];
	m_pbackgroundImage6 = [UIImage imageNamed:@"nbg17.jpg"];
	m_pbackgroundImage7 = [UIImage imageNamed:@"nbg18.jpg"];
	m_pbackgroundImage8 = [UIImage imageNamed:@"nbg19.jpg"];
	m_pbackgroundImage9 = [UIImage imageNamed:@"nbg10.jpg"];
	m_pbackgroundImage10 = [UIImage imageNamed:@"nbg2.jpg"];
	m_pbackgroundImage11 = [UIImage imageNamed:@"nbg3.jpg"];
	m_pbackgroundImage12 = [UIImage imageNamed:@"nbg4.jpg"];
	m_pbackgroundImage13 = [UIImage imageNamed:@"nbg7.jpg"];
	m_pbackgroundImage14 = [UIImage imageNamed:@"nbg9.jpg"];
	m_pbackgroundImage15 = [UIImage imageNamed:@"nbg20.jpg"];
	m_pbackgroundImage16 = [UIImage imageNamed:@"nbg5.jpg"];
}

-(void) loadSounds
{
	NSString *pPath1 = [[NSBundle mainBundle] pathForResource:@"ambient_button_201" ofType:@"wav"];
	CFURLRef pURL1 = (CFURLRef ) [NSURL fileURLWithPath:pPath1];
	AudioServicesCreateSystemSoundID (pURL1, &m_pSound1);
	
	pPath1 = [[NSBundle mainBundle] pathForResource:@"beep2" ofType:@"wav"];
	pURL1 = (CFURLRef ) [NSURL fileURLWithPath:pPath1];
	AudioServicesCreateSystemSoundID (pURL1, &m_pSound2);
	
	pPath1 = [[NSBundle mainBundle] pathForResource:@"clappingSoundFile" ofType:@"caf"];
	pURL1 = (CFURLRef ) [NSURL fileURLWithPath:pPath1];
	AudioServicesCreateSystemSoundID (pURL1, &m_pSoundClapping);
}

-(void) loadHighScores
{
	// init and allocate repositoryController
	m_pHighScoresRepositoryController = [[CSqliteController alloc] init];
	
	if([m_pHighScoresRepositoryController connectToDatabase:SCORE_DATABASENAME])
	{
		if([m_pHighScoresRepositoryController initTable:SCORE_TABLENAME])
		{
			// before loading we have to tell the controller how many columns are there and what are its data types
			[m_pHighScoresRepositoryController addColumnToTable:SCORE_COL0_PK dateType:DATA_TYPE_INT];
			[m_pHighScoresRepositoryController addColumnToTable:SCORE_COL1_NAME dateType:DATA_TYPE_STRING];
			[m_pHighScoresRepositoryController addColumnToTable:SCORE_COL2_LEVEL dateType:DATA_TYPE_INT];
			[m_pHighScoresRepositoryController addColumnToTable:SCORE_COL3_SCORE dateType:DATA_TYPE_INT];
			[m_pHighScoresRepositoryController addColumnToTable:SCORE_COL4_GAME dateType:DATA_TYPE_INT];
		}
		// if connection is successful, then we have to load records from file;
	}	
}

-(void) loadGameSettings
{
	// init and allocate repositoryController
	m_pGameSettingsRepositoryController = [[CSqliteController alloc] init];
	
	if([m_pGameSettingsRepositoryController connectToDatabase:SETTINGS_DATABASENAME])
	{
		if([m_pGameSettingsRepositoryController initTable:SETTINGS_TABLENAME])
		{
			// before loading we have to tell the controller how many columns are there and what are its data types
			[m_pGameSettingsRepositoryController addColumnToTable:SETTINGS_COL0_PK dateType:DATA_TYPE_INT];
			[m_pGameSettingsRepositoryController addColumnToTable:SETTINGS_COL1_NAME dateType:DATA_TYPE_STRING];
			[m_pGameSettingsRepositoryController addColumnToTable:SETTINGS_COL2_SPEED dateType:DATA_TYPE_INT];
			[m_pGameSettingsRepositoryController addColumnToTable:SETTINGS_COL3_SOUND dateType:DATA_TYPE_INT];
			[m_pGameSettingsRepositoryController addColumnToTable:SETTINGS_COL4_VIBR dateType:DATA_TYPE_INT];
			
			NSMutableArray *pArray = [m_pGameSettingsRepositoryController loadRecordsFromTable];
			if([pArray count] > 0)
			{
				NSMutableArray *pRecord = [pArray objectAtIndex:0];
				NSString *pValue = [pRecord objectAtIndex:2];
				m_fGameSpeed = [pValue intValue];
				pValue = [pRecord objectAtIndex:3];
				m_bGameSound = ([pValue intValue] == 1)? TRUE:FALSE;
				pValue = [pRecord objectAtIndex:4];
				m_bGameVibration = ([pValue intValue] == 1)? TRUE:FALSE;
				if(m_strDefaultName != nil)
					[m_strDefaultName release];
				m_strDefaultName = [[NSString alloc] initWithString:[pRecord objectAtIndex:1]];
			}
			else
			{
				m_fGameSpeed = 0;
				m_bGameSound = TRUE;
				m_bGameVibration = FALSE;				
				if(m_strDefaultName == nil)
					m_strDefaultName = [[NSString alloc] initWithFormat:@"Unknown"];
			}
			return;
		}
		// if connection is successful, then we have to load records from file;
	}
	m_fGameSpeed = 0;
	m_bGameSound = TRUE;
	m_bGameVibration = FALSE;
	if(m_strDefaultName == nil)
		m_strDefaultName = [[NSString alloc] initWithFormat:@"Unknown"];
}

-(void) loadGamesNames
{
	m_pGamesArray = [[NSMutableArray alloc] init];
	
	NSString *strGame1 = [[NSString alloc] initWithFormat:@"Eliminator"];
	[m_pGamesArray addObject:strGame1];
	[strGame1 release];

	NSString *strGame2 = [[NSString alloc] initWithFormat:@"Protector"];
	[m_pGamesArray addObject:strGame2];
	[strGame2 release];
	
	
	m_pGamesArrayDescription = [[NSMutableArray alloc] init];
	
	NSString *strGameDesc1 = [[NSString alloc] initWithFormat:@"Eliminate the ball completely before time runs out. Watch out for the little balls merging."];
	[m_pGamesArrayDescription addObject:strGameDesc1];
	[strGameDesc1 release];
	
	NSString *strGameDesc2 = [[NSString alloc] initWithFormat:@"Keep the ball away from screen boundaries as much as possible. Try to score more combos."];
	[m_pGamesArrayDescription addObject:strGameDesc2];
	[strGameDesc2 release];
	
//	NSString *strGame3 = [[NSString alloc] initWithFormat:@"Game 2"];
//	[m_pGamesArray addObject:strGame3];
//	[strGame3 release];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	[self loadImages];
	[self loadHighScores];
	[self loadSounds];
	[self loadGameSettings];
	
	[self loadGamesNames];
	m_iGameSelected = 0;
	
	viewController = [[SplashViewController alloc] init];
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc 
{
	[m_strDefaultName release];
	[m_pGameSettingsRepositoryController release];
	[m_pHighScoresRepositoryController release];

	[m_pGamesArray release];
	[m_pGamesArrayDescription release];
	
    [viewController release];
    [window release];
    [super dealloc];
}

-(UIImage*) getBgImage:(NSInteger)pLevel
{
	pLevel = pLevel%16;
	switch (pLevel) 
	{
		case 0:
			return m_pbackgroundImage1;
		case 1:
			return m_pbackgroundImage2;
		case 2:
			return m_pbackgroundImage3;
		case 3:
			return m_pbackgroundImage4;
		case 4:
			return m_pbackgroundImage5;
		case 5:
			return m_pbackgroundImage6;
		case 6:
			return m_pbackgroundImage7;
		case 7:
			return m_pbackgroundImage8;
		case 8:
			return m_pbackgroundImage9;
		case 9:
			return m_pbackgroundImage10;
		case 10:
			return m_pbackgroundImage11;
		case 11:
			return m_pbackgroundImage12;
		case 12:
			return m_pbackgroundImage13;
		case 13:
			return m_pbackgroundImage14;
		case 14:
			return m_pbackgroundImage15;
		default:
			return m_pbackgroundImage16;
	}
	
}

#pragma mark repository related methods
-(void) updateSettings:(CGFloat)fSpeed sound:(BOOL)bSound vibration:(BOOL)bVibration
{
	m_fGameSpeed = fSpeed;
	m_bGameSound = bSound;
	m_bGameVibration = bVibration;
	
	// store player name, level, score in db
	NSMutableArray * pRecord = [[NSMutableArray alloc] init];
	[pRecord addObject:@""];
	if(m_strDefaultName == nil)
		[pRecord addObject:@""];
	else
		[pRecord addObject:m_strDefaultName];
	
	int speed = m_fGameSpeed;
	[pRecord addObject:[NSString stringWithFormat:@"%d",speed]];
	[pRecord addObject:[NSString stringWithFormat:@"%d",(bSound == TRUE)?1:0]];
	[pRecord addObject:[NSString stringWithFormat:@"%d",(bVibration == TRUE)?1:0]];
	
	[m_pGameSettingsRepositoryController deleteAllRecords];
	[m_pGameSettingsRepositoryController addRecordInTable:pRecord isAutoPrimaryKeyEnabled:TRUE];
	[pRecord removeAllObjects];
	[pRecord release];
}

-(void) updateDefaultName:(NSString*)strName
{
	if(strName != nil)
	{
		if(m_strDefaultName != nil)
		{
			[m_strDefaultName release];
			m_strDefaultName = [[NSString alloc] initWithString:strName];
			[self updateSettings:m_fGameSpeed 
						   sound:m_bGameSound 
					   vibration:m_bGameVibration];
		}
	}
}

-(void) saveScore:(NSString*)strName gameType:(int)iGameType level:(int) iLevel score:(int)iScore
{
	// store player name, level, score in db
	NSMutableArray * pRecord = [[NSMutableArray alloc] init];
	[pRecord addObject:@""];
	[pRecord addObject:strName];
	[pRecord addObject:[NSString stringWithFormat:@"%d",iLevel]];
	[pRecord addObject:[NSString stringWithFormat:@"%d",iScore]];
	[pRecord addObject:[NSString stringWithFormat:@"%d",iGameType]];
	
	[m_pHighScoresRepositoryController addRecordInTable:pRecord isAutoPrimaryKeyEnabled:TRUE];
	[pRecord removeAllObjects];
	[pRecord release];	
}

@end
