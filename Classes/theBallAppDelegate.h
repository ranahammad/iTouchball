//
//  theBallAppDelegate.h
//  theBall
//
//  Created by Faisal Saeed on 5/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSqliteController.h"
#import <AudioToolbox/AudioServices.h>

#define SCORE_DATABASENAME	@"scoresDatabase.sqlite"
#define SCORE_TABLENAME		@"scores"
#define SCORE_COL0_PK		@"id"
#define SCORE_COL1_NAME		@"playerName"
#define SCORE_COL2_LEVEL	@"level"
#define SCORE_COL3_SCORE	@"score"
#define SCORE_COL4_GAME		@"game"

#define SETTINGS_DATABASENAME	@"gameSettings.sqlite"
#define SETTINGS_TABLENAME	@"gsTable"
#define SETTINGS_COL0_PK	@"id"
#define SETTINGS_COL1_NAME	@"playerName"
#define SETTINGS_COL2_SPEED	@"speed"
#define SETTINGS_COL3_SOUND	@"sound"
#define SETTINGS_COL4_VIBR	@"vibration"

@class SplashViewController;

@interface theBallAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    SplashViewController *viewController;
	CSqliteController *m_pHighScoresRepositoryController;
	CSqliteController *m_pGameSettingsRepositoryController;
	
	// game settings
	NSMutableArray *	m_pGamesArray;
	NSMutableArray *	m_pGamesArrayDescription;
	
	NSInteger m_iGameSelected;
	CGFloat m_fGameSpeed;
	BOOL m_bGameVibration;
	BOOL m_bGameSound;
	NSString*		m_strDefaultName;
	
	// game sounds
	SystemSoundID	m_pSound1;
	SystemSoundID	m_pSound2;
	SystemSoundID	m_pSoundClapping;
	
	// ball images
	UIImage	*m_pBallImage;
	UIImage *m_pBallImage1;
	UIImage *m_pBallImage2;
	UIImage *m_pBallImage3;
	UIImage *m_pBallImage4;
	UIImage *m_pBallImage5;
	UIImage *m_pBallImage6;
	UIImage *m_pBallImage7;
	UIImage *m_pBallImage8;
	UIImage *m_pBallImage9;
	UIImage *m_pBallImage10;
	UIImage *m_pBallImage11;
	UIImage *m_pBallImage12;
	
	
	// background Images
	UIImage *m_pbackgroundImage1;
	UIImage *m_pbackgroundImage2;
	UIImage *m_pbackgroundImage3;
	UIImage *m_pbackgroundImage4;
	UIImage *m_pbackgroundImage5;
	UIImage *m_pbackgroundImage6;
	UIImage *m_pbackgroundImage7;
	UIImage *m_pbackgroundImage8;
	UIImage *m_pbackgroundImage9;
	UIImage *m_pbackgroundImage10;
	UIImage *m_pbackgroundImage11;
	UIImage *m_pbackgroundImage12;
	UIImage *m_pbackgroundImage13;
	UIImage *m_pbackgroundImage14;
	UIImage *m_pbackgroundImage15;
	UIImage *m_pbackgroundImage16;
}

@property (nonatomic, retain) NSMutableArray *m_pGamesArray;
@property (nonatomic, retain) NSMutableArray *m_pGamesArrayDescription;
@property (nonatomic) SystemSoundID m_pSound1;
@property (nonatomic) SystemSoundID m_pSound2;
@property (nonatomic) SystemSoundID m_pSoundClapping;

@property (nonatomic) NSInteger m_iGameSelected;
@property (nonatomic) BOOL m_bGameSound;
@property (nonatomic) BOOL m_bGameVibration;
@property (nonatomic) CGFloat m_fGameSpeed;
@property (nonatomic, retain) NSString* m_strDefaultName;

@property (nonatomic, retain) CSqliteController *m_pHighScoresRepositoryController;
@property (nonatomic, retain) CSqliteController *m_pGameSettingsRepositoryController;
@property (nonatomic, readonly) UIImage *m_pBallImage;
@property (nonatomic, readonly) UIImage *m_pBallImage1;
@property (nonatomic, readonly) UIImage *m_pBallImage2;
@property (nonatomic, readonly) UIImage *m_pBallImage3;
@property (nonatomic, readonly) UIImage *m_pBallImage4;
@property (nonatomic, readonly) UIImage *m_pBallImage5;
@property (nonatomic, readonly) UIImage *m_pBallImage6;
@property (nonatomic, readonly) UIImage *m_pBallImage7;
@property (nonatomic, readonly) UIImage *m_pBallImage8;
@property (nonatomic, readonly) UIImage *m_pBallImage9;
@property (nonatomic, readonly) UIImage *m_pBallImage10;
@property (nonatomic, readonly) UIImage *m_pBallImage11;
@property (nonatomic, readonly) UIImage *m_pBallImage12;

@property (nonatomic, readonly) UIImage *m_pbackgroundImage1;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage2;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage3;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage4;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage5;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage6;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage7;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage8;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage9;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage10;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage11;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage12;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage13;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage14;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage15;
@property (nonatomic, readonly) UIImage *m_pbackgroundImage16;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SplashViewController *viewController;

-(UIImage*) getBgImage:(NSInteger)pLevel;
-(void) updateSettings:(CGFloat)fSpeed sound:(BOOL)bSound vibration:(BOOL)bVibration;
-(void) updateDefaultName:(NSString*)strName;
-(void) saveScore:(NSString*)strName gameType:(int)iGameType level:(int) iLevel score:(int)iScore;
@end

