//
//  CFirstGame.m
//  theBall
//
//  Created by Faisal Saeed on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CFirstGame.h"
#import "theBallAppDelegate.h"

@interface CFirstGame (private)
theBallAppDelegate *appDelegate;
@end

#define kMinimumBallRadius	8.0
#define kRadiusDivider		2.0
#define kInitialBallRadius	64.0


@implementation CFirstGame
@synthesize m_pMovingBalls;

-(id) init
{
	if(self = [super init])
	{
		appDelegate = [[UIApplication sharedApplication] delegate];
	}
	return self;
}

-(id) initWithPlayArea:(UIView*)pParentView boundingRect:(CGRect)pBoundingRect
{
	if(self = [super initWithPlayArea:pParentView boundingRect:pBoundingRect])
	{
		appDelegate = [[UIApplication sharedApplication] delegate];
		m_pMovingBalls = [[NSMutableArray alloc] init];
	}
	return self;
}

- (CGPoint) getNewCenterPoint:(CGPoint)ptCenter radius:(CGFloat)pNewRadius
{	
	CGFloat newXPos = ptCenter.x;
	if((newXPos - pNewRadius) <= m_pBoundingRect.origin.x)
		newXPos = (ptCenter.x - pNewRadius + 1);
	else if ((newXPos + pNewRadius) >= m_pBoundingRect.origin.x + m_pBoundingRect.size.width)
		newXPos = (ptCenter.x + pNewRadius - 1);
	
	CGFloat newYPos = ptCenter.y;
	if((newYPos - pNewRadius) <= m_pBoundingRect.origin.y)
		newYPos = (ptCenter.y - pNewRadius + 1);
	else if ((newXPos + pNewRadius) >= m_pBoundingRect.origin.y + m_pBoundingRect.size.height)
		newYPos = (ptCenter.y + pNewRadius - 1);
	
	return CGPointMake(newXPos,newYPos);
}

-(void) gameLoop
{
	[super gameLoop];
	// update ball positions and directions;
	if(m_bGameRunning && m_bGameVisible)
	{
		if([m_pMovingBalls count] == 0)
		{
			m_bGameRunning = FALSE;
			return;
		}
		
		for(int i=0; i<[m_pMovingBalls count]; i++)
		{
			CBall *pBall = [m_pMovingBalls objectAtIndex:i];
			
			if([pBall updateBallPosition])
				m_iWallCollisionCount++;

			// check if balls collided with each other
			for(int j=0; j<[m_pMovingBalls count]; j++)
			{
				CBall* tBall = [m_pMovingBalls objectAtIndex:j];
				
				if(pBall != tBall)
				{
					if([pBall hasCollidedWithAnotherBall:tBall])
					{							
						m_iMergeCount+=50;
						if(appDelegate.m_bGameSound)
							AudioServicesPlaySystemSound(appDelegate.m_pSound2);
						
						if(appDelegate.m_bGameVibration)
							AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
						
						[pBall updateRadius:(pBall.m_fRadius + tBall.m_fRadius)];
						[[tBall m_pBallImageView] removeFromSuperview];
						[m_pMovingBalls removeObjectAtIndex:j];
						[pBall setM_ptCenter:[self getNewCenterPoint:pBall.m_ptCenter radius:pBall.m_fRadius]];
						return;
					}
				}
			}
		}			
	}
	
}

-(void) startNewLevel:(NSInteger)iLevel
{
	[super startNewLevel:iLevel];
	if([m_pMovingBalls count] >0)
	{
		for(int i=0; i<[m_pMovingBalls count]; i++)
		{
			CBall *pBall = [m_pMovingBalls objectAtIndex:i];
			[[pBall m_pBallImageView] removeFromSuperview];
			[pBall release];
		}
		[m_pMovingBalls removeAllObjects];
	}
	
	CBall *pBall = [[CBall alloc] initBall:kInitialBallRadius 
							  boundingRect:m_pBoundingRect 
								  centerPt:CGPointMake(m_pBoundingRect.origin.x + m_pBoundingRect.size.width/2,
													   m_pBoundingRect.origin.y + m_pBoundingRect.size.height/2)];
	[[pBall m_pBallImageView] setImage:[appDelegate m_pBallImage]];
	[m_pMovingBalls addObject:pBall];
	m_bGameRunning = TRUE;
	m_bGameEnded = FALSE;
}

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesBegan:touches withEvent:event];
	if(m_bGameRunning && m_bCanReceiveTouch && m_bGameVisible)
	{
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint ptTouch = [touch locationInView:touch.view];
		
		m_iTouchCount++;
		// draw and detect collision with screen touches
		// if balls are collided, divide them and insert them in 
		if([m_pMovingBalls count] > 0)
		{
			for(int	i = 0; i<[m_pMovingBalls count]; i++)
			{
				CBall *pBall = [m_pMovingBalls objectAtIndex:i];
				if([pBall hasCollidedWithTouch:ptTouch])
				{
					if(appDelegate.m_bGameSound)
						AudioServicesPlaySystemSound(appDelegate.m_pSound1);
					
					m_iDivisionCount+=100;
					[pBall updateRadius:(pBall.m_fRadius / kRadiusDivider)];
					
					if(pBall.m_fRadius < kMinimumBallRadius)
					{
						[[pBall m_pBallImageView] removeFromSuperview];
						[m_pMovingBalls removeObjectAtIndex:i];
						return;
					}
					
					CBall *pNewBall = [[CBall alloc] initWithBall:pBall];
					[pNewBall setM_ptDirection:CGPointMake(-1.0 * pBall.m_ptDirection.x,-1.0* pBall.m_ptDirection.y)];
					
					CGFloat newXPos = pBall.m_ptCenter.x - (2*pNewBall.m_fRadius);
					
					if((newXPos - pNewBall.m_fRadius) <= m_pBoundingRect.origin.x)
						newXPos = pBall.m_ptCenter.x + (2*pNewBall.m_fRadius);
					
					CGFloat newYPos = pBall.m_ptCenter.y - (2*pNewBall.m_fRadius);
					
					if((newYPos - pNewBall.m_fRadius) <= m_pBoundingRect.origin.y)
						newYPos = pBall.m_ptCenter.y + (2*pNewBall.m_fRadius);
					
					[pNewBall setM_ptCenter:CGPointMake(newXPos,newYPos)];
					
					[m_pMovingBalls addObject:pNewBall];
					[self.m_pParentView addSubview:[pNewBall m_pBallImageView]];
					return;
				}
			}
		}
	}
}

-(void) makeViewVisible
{
	CBall *pBall = [m_pMovingBalls objectAtIndex:0];
	[m_pParentView addSubview:[pBall m_pBallImageView]];
	[m_pParentView bringSubviewToFront:[pBall m_pBallImageView]];
}

-(void) dealloc
{
	[super dealloc];
	for(int i=0; i<[m_pMovingBalls count]; i++)
	{
		CBall *pBall = [m_pMovingBalls objectAtIndex:i];
		[[pBall m_pBallImageView] release];
		[pBall release];
	}
	[m_pMovingBalls release];
}


@end
