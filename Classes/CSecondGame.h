//
//  CFirstGame.h
//  theBall
//
//  Created by Faisal Saeed on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CParentGame.h"

@interface CSecondGame : CParentGame 
{
	CBall	*m_pMovingBall;
	NSMutableArray *m_pTouchBalls;
	UILabel *m_pBonusLabel;
	
	NSInteger m_iTotalTapsForLevel;
}

@property (nonatomic, retain) IBOutlet UILabel *m_pBonusLabel;
@property (nonatomic, retain) CBall* m_pMovingBall;
@property (nonatomic, retain) NSMutableArray *m_pTouchBalls;

@end
