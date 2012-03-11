//
//  HighScoresView.h
//  theBall
//
//  Created by Faisal Saeed on 5/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HighScoresView : UIViewController
{
	UITextView * m_pScoreTextView;
	UISegmentedControl* m_pGameSelectorSegmentControl;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl * m_pGameSelectorSegmentControl;
@property (nonatomic, retain) IBOutlet UITextView * m_pScoreTextView;

-(IBAction) mainSreenViewBtnClicked;
-(IBAction) reloadScoresBtnClicked;
@end
