//
//  CBall.m
//  theBall
//
//  Created by Faisal Saeed on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CBall.h"

#define ARC4RANDOM_MAX						0x100000000

#define DIRECTION_FACTOR					0.75

@interface CBall (private)
- (void) initDirection;
@end

@implementation CBall

@synthesize m_fAngle;
@synthesize m_bVisible;
@synthesize m_pBallImageView;
@synthesize m_ptDirection;
@synthesize m_ptCenter;
@synthesize m_fRadius;
@synthesize m_pBoundingRectangle;
@synthesize	m_iTimeLeftForVisibility;

- (void) initDirection
{

	CGFloat xDirection = cos(m_fAngle);// * DIRECTION_FACTOR;
	CGFloat yDirection = sin(m_fAngle);// * DIRECTION_FACTOR;
			
	self.m_ptDirection = CGPointMake(xDirection , yDirection);
}

- (id) initWithBall:(CBall*)pBall
{
	if(self = [self initBall:pBall.m_fRadius boundingRect:pBall.m_pBoundingRectangle centerPt:pBall.m_ptCenter])
	{
		[self.m_pBallImageView setImage:[pBall.m_pBallImageView image]];
		m_fAngle = pBall.m_fAngle;
	}
	
	return self;
}

- (id) initBall:(CGFloat) pRadius centerPt:(CGPoint)pCenterpt
{
	if(self = [super init])
	{
		m_pBoundingRectangle = CGRectZero;
		self.m_ptCenter = CGPointMake(pCenterpt.x,pCenterpt.y);
		m_fRadius = pRadius;
		self.m_pBallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.m_ptCenter.x-pRadius,self. m_ptCenter.y-pRadius, 2*pRadius, 2*pRadius)];
		m_bVisible = TRUE;
	}
	return self;	
}

-(id) initBall:(CGFloat) pRadius boundingRect:(CGRect)pBoundingRect centerPt:(CGPoint)pCenterpt
{
	if(self = [super init])
	{
		m_pBoundingRectangle = pBoundingRect;
		self.m_ptCenter = CGPointMake(pCenterpt.x,pCenterpt.y);
		m_fRadius = pRadius;
		self.m_pBallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.m_ptCenter.x-pRadius,self. m_ptCenter.y-pRadius, 2*pRadius, 2*pRadius)];
		m_bVisible = TRUE;
		m_fAngle = floorf(((double)arc4random() / ARC4RANDOM_MAX) * (2*M_PI));
		
		if(fmod(m_fAngle,(M_PI/2)) == 0.0)
			m_fAngle += (M_PI/4);
		[self initDirection];
	}
	return self;
}

- (id) initMovingBall:(CGFloat)pRadius boundingRect:(CGRect)pRoundingRect
{
	CGFloat xPos = floorf(((double)arc4random() / ARC4RANDOM_MAX) * (pRoundingRect.size.width - 2*pRadius));
	CGFloat yPos = floorf(((double)arc4random() / ARC4RANDOM_MAX) * (pRoundingRect.size.height - 2*pRadius));
	
	if(yPos < 25.0)
		yPos = 25.0;
	if(xPos < 25.0)
		xPos = 25.0;
	
	if(self = [self initBall:pRadius boundingRect:pRoundingRect centerPt:CGPointMake(xPos+pRadius,yPos+pRadius)])
	{
//		m_iBallType = (floorf(((double)arc4random() / ARC4RANDOM_MAX) * 11.0f) + 1);
//		[self.m_pBallImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ball%d.png",m_iBallType]]];	
	}
	return self;
}

-(void) dealloc
{
	[m_pBallImageView setImage:nil];
	[m_pBallImageView release];
	[super dealloc];
}

-(void) updateCenterPoint:(CGPoint)pCenterpt
{
	m_ptCenter = CGPointMake(pCenterpt.x, pCenterpt.y);
	[self.m_pBallImageView setFrame:CGRectMake(self.m_ptCenter.x-m_fRadius,self. m_ptCenter.y-m_fRadius, 2*m_fRadius, 2*m_fRadius)];	
}

-(void) updateRadius:(CGFloat)pRadius
{
	m_fRadius = pRadius;
	[self.m_pBallImageView setFrame:CGRectMake(self.m_ptCenter.x-m_fRadius,self. m_ptCenter.y-m_fRadius, 2*m_fRadius, 2*m_fRadius)];
}

-(void) incrementRadiusBy:(CGFloat)pIncrement
{
	m_fRadius = m_fRadius + pIncrement;
	[self.m_pBallImageView setFrame:CGRectMake(self.m_ptCenter.x-m_fRadius,self. m_ptCenter.y-m_fRadius, 2*m_fRadius, 2*m_fRadius)];
}

-(void) calculateNewPosition
{
	CGPoint newPt;
	newPt = CGPointMake(self.m_ptCenter.x + self.m_ptDirection.x, self.m_ptCenter.y	+ self.m_ptDirection.y);
	self.m_ptCenter = CGPointMake(self.m_ptCenter.x + ((newPt.x) * cos(m_fAngle)),
							  self.m_ptCenter.y - ((newPt.y) * sin(m_fAngle)));
}

- (BOOL) updateBallPosition
{
	BOOL bCollision = FALSE;
	// move the BALL image around the screen
	// controlling the movement of ball
	
//	[self calculateNewPosition];
	CGFloat finalX = self.m_ptCenter.x + self.m_ptDirection.x;
	CGFloat finalY = self.m_ptCenter.y	+ self.m_ptDirection.y;
	//self.m_ptCenter = CGPointMake(self.m_ptCenter.x + self.m_ptDirection.x, self.m_ptCenter.y	+ self.m_ptDirection.y);

	if(finalX <= m_pBoundingRectangle.origin.x)
		finalX = m_pBoundingRectangle.origin.x + 1 + self.m_ptDirection.x + m_fRadius;
	else if(finalX >= (m_pBoundingRectangle.origin.x + m_pBoundingRectangle.size.width))
		finalX = (m_pBoundingRectangle.origin.x + m_pBoundingRectangle.size.width) - 1 - m_fRadius;
	
	if(finalY <= m_pBoundingRectangle.origin.y)
		finalY = m_pBoundingRectangle.origin.y + 1 + self.m_ptDirection.y + m_fRadius;
	else if(finalY >= (m_pBoundingRectangle.origin.y + m_pBoundingRectangle.size.height))
		finalY = (m_pBoundingRectangle.origin.y + m_pBoundingRectangle.size.height) - 1 - m_fRadius;
	
	self.m_ptCenter = CGPointMake(finalX, finalY);
	[self.m_pBallImageView setCenter:m_ptCenter];
	// check if the ball strikes left or right cornor
	if((self.m_ptCenter.x + m_fRadius) > (m_pBoundingRectangle.origin.x + m_pBoundingRectangle.size.width) ||
	   (self.m_ptCenter.x - m_fRadius) < (m_pBoundingRectangle.origin.x))
	{
		self.m_ptDirection = CGPointMake(-1.0 * self.m_ptDirection.x, self.m_ptDirection.y);
		bCollision = TRUE;
	}
	
	
	if((self.m_ptCenter.y + m_fRadius) > (m_pBoundingRectangle.origin.y	+ m_pBoundingRectangle.size.height) ||
	   (self.m_ptCenter.y - m_fRadius) < (m_pBoundingRectangle.origin.y))
	{
		self.m_ptDirection = CGPointMake(self.m_ptDirection.x, -1.0 * self.m_ptDirection.y);	
		bCollision = TRUE;
	}
	
	return bCollision;
}

- (BOOL) hasCollidedWithTouch:(CGPoint) ptTouch
{
	CGFloat diffX = self.m_ptCenter.x - ptTouch.x;
	CGFloat diffY = self.m_ptCenter.y - ptTouch.y;
	CGFloat diffR = MAX(m_fRadius, 40.0);//sqrt(pow(diffX,2.0) + pow(diffY,2.0));
//	CGFloat tVal = sqrt(pow(diffX,2.0) + pow(diffY,2.0));
	
	//CGFloat slope = 0.0;
	
	if(pow(diffX,2.0) + pow(diffY,2.0) <= pow(diffR,2.0))
	{
/*		if(diffY == 0)
			m_ptDirection.x = -1.0 * m_ptDirection.x;
		else if (diffX == 0)
			m_ptDirection.y = -1.0 * m_ptDirection.y;
		else
		{
			slope = diffY/diffX;		
			if((slope > 0 && slope <=1) || (slope < 0 && slope >= -1))
				m_ptDirection.x = -1.0 * m_ptDirection.x;
			else if(slope > 1 || slope < -1)
				m_ptDirection.y = -1.0 * m_ptDirection.y;
		}
*/
		// calculate angle
		return TRUE;
	}
	return FALSE;
}

- (BOOL) hasCollidedWithAnotherBall:(CBall*) pOtherBall
{
	// current ball enters the area of pOtherBall
	// (x1- x2)^2 + (y1 - y2)^2 - (r1 -r2)^2 <=0
	
	
	CGFloat diffX = pOtherBall.m_ptCenter.x - self.m_ptCenter.x;
	CGFloat diffY = pOtherBall.m_ptCenter.y - self.m_ptCenter.y;
	CGFloat diffR = sqrt(pow(diffX,2.0) + pow(diffY,2.0));
	CGFloat sumRadii = (m_fRadius + pOtherBall.m_fRadius) * 0.99;
	
	CGFloat slope = 0.0;
	
	if(diffR <= sumRadii)
	{
		if(diffY == 0)
			m_ptDirection.x = -1.0 * m_ptDirection.x;
		else if (diffX == 0)
			m_ptDirection.y = -1.0 * m_ptDirection.y;
		else
		{
			slope = diffY/diffX;		
			if((slope > 0 && slope <=1) || (slope < 0 && slope >= -1))
				m_ptDirection.x = -1.0*m_ptDirection.x;
			else if(slope > 1 || slope < -1)
				m_ptDirection.y = -1.0 * m_ptDirection.y;
		}
		return TRUE;
	}
	return FALSE;
}


@end
