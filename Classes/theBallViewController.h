//
//  theBallViewController.h
//  theBall
//
//  Created by Faisal Saeed on 5/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EAGLView.h"
#import "CParentGame.h"

@interface theBallViewController : UIViewController 
								<UINavigationControllerDelegate>
 
{
	CParentGame*				m_pCurrentGame;
	UISegmentedControl*			m_pGameSelectorSegmentControl;
	UILabel*					m_pGameDescription;
	
	UIImageView*				m_pBackgroundImage;
	
	UILabel*					m_pGameNameLabel;
	UILabel*					m_pGameTimeLeftLabel;
	UILabel*					m_pGameScoreCountLabel;
		
	// game views
	UIView*						m_pMainOptionView;
	UIView*						m_pCurrentView;
	UIView*						m_pGameView;
	
	NSInteger					m_iSelectedGame;
	// Objects used while playing game
	id							m_pTimerScore;
	BOOL						m_bStartingLevel;
	BOOL						m_bScreenTouched;
	CGPoint						m_ptBallVelocity;
	CGPoint						m_ptScreenTouched;	
	CGFloat						m_fSpeedSelected;
	NSInteger					m_iGameState;	
	NSInteger					m_iScore;
	NSInteger					m_iLevel;
	NSInteger					m_iTouchCount;
	NSInteger					m_iTimeRemaining;
	NSInteger					m_iMergeCount;
	UILabel*					m_plabelScore;
	//UIPickerView*				m_pGamePickerView;
	UIImageView*				m_pImageBall;
	NSMutableArray*				m_pMovingBalls;
	NSMutableArray*				m_pGeneratedBalls;

	// Level screen and its objects
	UIView*						m_pLevelView;
	UILabel*					m_pLevelLabel;
	UITextView*					m_pCurrentScoreTextView;
	UITextView*					m_pCurrentScoreTextViewLabels;
	UILabel*					m_pTapToContinue;
	UIActivityIndicatorView*	m_pStartingLevelIndicator;
	UIProgressView*				m_pTimeLeftProgress;
	UIButton*					m_pQuitGameButton;
	
	// save score screen and its objects
	UIView*						m_pSaveScoreView;
	UITextField*				m_pPlayerNameTextField;
	UIButton*					m_pSetNameAsDefaultBtn;
	UIButton*					m_pSubmitScoreBtn;
	UIButton*					m_pCancelSubmitScoreBtn;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl * m_pGameSelectorSegmentControl;
@property (nonatomic, retain) IBOutlet UILabel* m_pGameDescription;
@property (nonatomic, retain) IBOutlet UIImageView* m_pBackgroundImage;
@property (nonatomic, retain) IBOutlet UILabel* m_pGameTimeLeftLabel;
@property (nonatomic, retain) IBOutlet UILabel* m_pGameNameLabel;
@property (nonatomic, retain) IBOutlet UILabel* m_pGameScoreCountLabel;

@property (nonatomic, retain) id m_pTimerScore;
@property (nonatomic, retain) NSMutableArray *m_pMovingBalls;
@property (nonatomic, retain) NSMutableArray *m_pGeneratedBalls;

@property (nonatomic, retain) IBOutlet UIView* m_pMainOptionView;
@property (nonatomic, retain) IBOutlet UIView* m_pSaveScoreView;
@property (nonatomic, retain) IBOutlet UIView* m_pGameView;
@property (nonatomic, retain) IBOutlet UIView* m_pLevelView;
@property (nonatomic, retain) IBOutlet UILabel *m_pLevelLabel;
@property (nonatomic, retain) IBOutlet UILabel *m_plabelScore;
@property (nonatomic, retain) IBOutlet UIImageView *m_pImageBall;
//@property (nonatomic, retain) IBOutlet UIPickerView *m_pGamePickerView;
@property (nonatomic, retain) IBOutlet UIProgressView *m_pTimeLeftProgress;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *m_pStartingLevelIndicator;
@property (nonatomic, retain) IBOutlet UILabel *m_pTapToContinue;
@property (nonatomic, retain) IBOutlet UITextView *m_pCurrentScoreTextView;
@property (nonatomic, retain) IBOutlet UITextView *m_pCurrentScoreTextViewLabels;
@property (nonatomic, retain) IBOutlet UITextField* m_pPlayerNameTextField;
@property (nonatomic, retain) IBOutlet UIButton* m_pSetNameAsDefaultBtn;
@property (nonatomic, retain) IBOutlet UIButton* m_pSubmitScoreBtn;
@property (nonatomic, retain) IBOutlet UIButton* m_pCancelSubmitScoreBtn;
@property (nonatomic, retain) IBOutlet UIButton* m_pQuitGameButton;

- (void)		gameEnded;

- (void)		saveScore:(NSString*) strTitle;
- (void)		startNewGame:(int)iGameSelected;

// select new game methods
- (IBAction)	playGameBtnClicked;
- (IBAction)	mainScreenBtnClicked;

// save score screen methods
- (IBAction)	endKeyboard;
- (IBAction)	submitScoreBtnClicked;
- (IBAction)	cancelSubmitScoreBtnClicked;
- (IBAction)	setNameAsDefaultBtnClicked;
- (IBAction)	gameSelectorSegmentControlClicked;
@end


