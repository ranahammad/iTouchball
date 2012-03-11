//
//  CBall.h
//  theBall
//
//  Created by Faisal Saeed on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CBall : NSObject 
{
	CGPoint		m_ptCenter;
	CGPoint		m_ptDirection;
	CGFloat		m_fRadius;
	BOOL		m_bVisible;
	CGRect		m_pBoundingRectangle;
	NSInteger	m_iTimeLeftForVisibility;
	CGFloat		m_fAngle;

	UIImageView*	m_pBallImageView;
}

@property (nonatomic) CGFloat		m_fAngle;
@property (nonatomic) NSInteger	m_iTimeLeftForVisibility;
@property (nonatomic) CGRect  m_pBoundingRectangle;
@property (nonatomic) CGPoint m_ptCenter;
@property (nonatomic) CGPoint m_ptDirection;
@property (nonatomic) CGFloat m_fRadius;
@property (nonatomic) BOOL		m_bVisible;
@property (nonatomic, retain) UIImageView*	m_pBallImageView;

- (id) initWithBall:(CBall*)pBall;
- (id) initBall:(CGFloat) pRadius centerPt:(CGPoint)pCenterpt;
- (id) initMovingBall:(CGFloat)pRadius boundingRect:(CGRect)pRoundingRect;
- (id) initBall:(CGFloat) pRadius boundingRect:(CGRect)pBoundingRect centerPt:(CGPoint)pCenterpt;
- (BOOL) updateBallPosition;
- (BOOL) hasCollidedWithAnotherBall:(CBall*) pOtherBall;
- (BOOL) hasCollidedWithTouch:(CGPoint) ptTouch;

-(void) updateRadius:(CGFloat)pRadius;
-(void) updateCenterPoint:(CGPoint)pCenterpt;
-(void) incrementRadiusBy:(CGFloat)pIncrement;
@end
