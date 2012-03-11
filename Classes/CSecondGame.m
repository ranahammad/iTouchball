//
//  CFirstGame.m
//  theBall
//
//  Created by Faisal Saeed on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CSecondGame.h"
#import "theBallAppDelegate.h"

@interface CSecondGame (private)
theBallAppDelegate *appDelegate;
@end


#define kMinimumBallRadius	8.0
#define kRadiusDivider		2.0
#define kInitialBallRadius	32.0
#define kMaxAllowedTouch	3
#define kTouchRadius		10.0
#define kTouchVisibilityTime	500

@implementation CSecondGame
@synthesize m_pMovingBall;
@synthesize m_pBonusLabel;
@synthesize m_pTouchBalls;

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
		m_pBonusLabel = [[UILabel alloc] init];
		[m_pBonusLabel setFrame:CGRectMake(pBoundingRect.origin.x, 
										   pBoundingRect.origin.y + pBoundingRect.size.height - 20
										   ,100, 30)];
		[m_pBonusLabel setText:@""];
		[m_pBonusLabel setBackgroundColor:[UIColor clearColor]];
		[m_pBonusLabel setFont:[UIFont fontWithName:@"Marker Felt" size:25.0]];
		[m_pBonusLabel setTextColor:[UIColor lightGrayColor]];
		[m_pBonusLabel setTextAlignment:UITextAlignmentCenter];
		
		[m_pParentView addSubview:m_pBonusLabel];
		
		m_pMovingBall = [[CBall alloc] initBall:kInitialBallRadius 
								  boundingRect:m_pBoundingRect 
									  centerPt:CGPointMake(m_pBoundingRect.origin.x + m_pBoundingRect.size.width/2,
														   m_pBoundingRect.origin.y + m_pBoundingRect.size.height/2)];
		[[m_pMovingBall m_pBallImageView] setImage:[appDelegate m_pBallImage]];
		
		m_pTouchBalls = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) gameLoop
{
	[super gameLoop];
	// update ball positions and directions;
	if(m_bGameRunning && m_bGameVisible)
	{		
		if([m_pMovingBall updateBallPosition])
		{
			if(appDelegate.m_bGameVibration)
				AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
			
			m_iTouchCount = 0;
			[m_pBonusLabel setText:@""];
		}
		
		if([m_pTouchBalls count] > 0)
		{
			for(int i=0; i<[m_pTouchBalls count]; i++)
			{
				CBall *pBall = [m_pTouchBalls objectAtIndex:i];
				if([pBall m_bVisible])
				{
					if(pBall.m_iTimeLeftForVisibility <= (kTouchVisibilityTime/2))
						[pBall incrementRadiusBy:-0.2];
					else
						[pBall incrementRadiusBy:0.2];
					pBall.m_iTimeLeftForVisibility--;

					if(pBall.m_iTimeLeftForVisibility == 0)
					{
						[pBall updateRadius:kTouchRadius];
						[[pBall m_pBallImageView] removeFromSuperview];
						pBall.m_bVisible = FALSE;
						[m_pTouchBalls removeObjectAtIndex:i];
						
						i--;
						return;
					}			
					
					if([m_pMovingBall hasCollidedWithAnotherBall:pBall])
					{
						m_iTouchCount++;
						m_iDivisionCount+=m_iTouchCount;
						//m_iDivisionCount = (m_iTotalTapsForLevel + m_iMergeCount) + (m_iTouchCount);
						if(appDelegate.m_bGameSound)
							AudioServicesPlaySystemSound(appDelegate.m_pSound1);
						
						[m_pBonusLabel setText:[NSString stringWithFormat:@"+%d",m_iTouchCount]];
						[m_pBonusLabel setCenter:pBall.m_ptCenter];
						[pBall updateRadius:kTouchRadius];
						[[pBall m_pBallImageView] removeFromSuperview];
						pBall.m_bVisible = FALSE;
						[m_pTouchBalls removeObjectAtIndex:i];
						
						i--;
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
	if([m_pTouchBalls count] > 0)
	{
		for(int i=0; i<[m_pTouchBalls count]; i++)
		{
			CBall* pBall = [m_pTouchBalls objectAtIndex:i];
			[[pBall m_pBallImageView] removeFromSuperview];
		}
		
		[m_pTouchBalls removeAllObjects];
	}
	
	m_iTotalTapsForLevel = ((iLevel * 25) + 25);
	m_iMergeCount = m_iTotalTapsForLevel;
	
	m_bGameRunning = TRUE;
	m_bGameEnded = FALSE;
}

-(void) makeViewVisible
{
	[m_pParentView addSubview:[m_pMovingBall m_pBallImageView]];
	[m_pParentView bringSubviewToFront:[m_pMovingBall m_pBallImageView]];
}

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesBegan:touches withEvent:event];
	if(m_bGameRunning && m_bCanReceiveTouch && m_bGameVisible)
	{
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint ptTouch = [touch locationInView:touch.view];
		
		// draw and detect collision with screen touches
		// if balls are collided, divide them and insert them in 
		if([m_pTouchBalls count] < kMaxAllowedTouch)
		{
			CBall *pBall = [[CBall alloc] initBall:kTouchRadius 
									  boundingRect:m_pBoundingRect 
										  centerPt:ptTouch];
			pBall.m_iTimeLeftForVisibility = kTouchVisibilityTime;
			[[pBall m_pBallImageView] setImage:[appDelegate m_pBallImage10]];
			[self.m_pParentView addSubview:[pBall m_pBallImageView]];
			[self.m_pParentView bringSubviewToFront:[pBall m_pBallImageView]];
			[m_pTouchBalls addObject:pBall];
			[pBall release];			
		}
	}
}

-(void) dealloc
{
	[super dealloc];
	[m_pBonusLabel release];
	[m_pMovingBall release];
}

@end
