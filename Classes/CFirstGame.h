//
//  CFirstGame.h
//  theBall
//
//  Created by Faisal Saeed on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CParentGame.h"


// First Game
/*
 Description: The ball moves across the screen. The user has to tap and finish the balls
 before time runs out; the ball divides into multiple balls and merge if collide with 
 each other.
 */

@interface CFirstGame : CParentGame 
{
	NSMutableArray *m_pMovingBalls;
}

@property (nonatomic, retain) NSMutableArray *m_pMovingBalls;

- (CGPoint)		getNewCenterPoint:(CGPoint)ptCenter radius:(CGFloat)pNewRadius;
@end
