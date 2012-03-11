//
//  CParentGame.m
//  theBall
//
//  Created by Faisal Saeed on 5/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CParentGame.h"

@implementation CParentGame

@synthesize m_bCanReceiveTouch;
@synthesize m_bGameRunning;
@synthesize m_bGameVisible;
@synthesize m_bGameEnded;
@synthesize m_pParentView;
@synthesize m_pBoundingRect;

@synthesize m_iWallCollisionCount;
@synthesize m_iMergeCount;
@synthesize m_iTouchCount;
@synthesize m_iDivisionCount;

-(id) init
{
	if(self = [super init])
	{
		m_bGameRunning = FALSE;
		m_bGameEnded = FALSE;
		m_bGameVisible = FALSE;
		m_iWallCollisionCount = 0;
		m_iMergeCount = 0;
		m_iTouchCount = 0;
		m_iDivisionCount = 0;		
	}
	return self;
}

-(id) initWithPlayArea:(UIView*)pParentView boundingRect:(CGRect)pBoundingRect
{
	if(self = [self init])
	{
		m_bCanReceiveTouch = TRUE;
		m_pParentView = pParentView;
		m_pBoundingRect = CGRectMake(pBoundingRect.origin.x, 
									 pBoundingRect.origin.y, 
									 pBoundingRect.size.width, 
									 pBoundingRect.size.height);
	}
	return self;
}

-(void) gameLoop
{

}

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{

}

-(void) startNewLevel:(NSInteger)iLevel
{
	m_iWallCollisionCount = 0;
	m_iTouchCount = 0;
	m_iDivisionCount = 0;
	m_iMergeCount = 0;
	m_bGameEnded = FALSE;
	m_bGameRunning = FALSE;
}

-(void) makeViewVisible
{

}

-(void) dealloc
{
	[super dealloc];
}

@end
