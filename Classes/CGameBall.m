//
//  CGameBall.m
//  theBall
//
//  Created by Faisal Saeed on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CGameBall.h"


@implementation CGameBall

@synthesize m_iLevel;
@synthesize m_iSelfIdx;
@synthesize m_iParentIdx;
//@synthesize m_iChildCount;
//@synthesize m_pChildIdxArray;
@synthesize m_iChildIdx1;
@synthesize m_iChildIdx2;

-(id) initBallWithLevel:(CGFloat) pRadius boundingRect:(CGRect)pBoundingRect centerPt:(CGPoint)pCenterpt level:(int)pLevel
{
	if(self = [super initBall:pRadius boundingRect:pBoundingRect centerPt:pCenterpt])
	{
		m_iLevel = pLevel;
		m_iSelfIdx = -1;
		m_iParentIdx = -1;
//		m_iChildCount = 2;
//		m_pChildIdxArray = [[NSMutableArray alloc] init];
		m_iChildIdx1 = -1;
		m_iChildIdx2 = -1;
		m_bVisible = FALSE;
	}
	return self;
}

-(void) dealloc
{
//	[m_pChildIdxArray release];
	[super dealloc];
}

@end
