//
//  CParentGame.h
//  theBall
//
//  Created by Faisal Saeed on 5/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBall.h"
#import <AudioToolbox/AudioServices.h>

@interface CParentGame : NSObject 
{

	BOOL	m_bCanReceiveTouch;
	BOOL	m_bGameRunning;
	BOOL	m_bGameEnded;
	BOOL	m_bGameVisible;
	UIView	*m_pParentView;
	CGRect	m_pBoundingRect;
	
	NSInteger	m_iWallCollisionCount;
	NSInteger	m_iTouchCount;
	NSInteger	m_iMergeCount;
	NSInteger	m_iDivisionCount;
}

@property (nonatomic) NSInteger m_iWallCollisionCount;
@property (nonatomic) NSInteger m_iTouchCount;
@property (nonatomic) NSInteger m_iMergeCount;
@property (nonatomic) NSInteger m_iDivisionCount;

//@property (nonatomic, retain) IBOutlet UIView *m_pView;
@property (nonatomic) BOOL	m_bGameVisible;
@property (nonatomic) BOOL	m_bGameRunning;
@property (nonatomic) BOOL	m_bGameEnded;
@property (nonatomic) BOOL	m_bCanReceiveTouch;
@property (nonatomic, retain) UIView *m_pParentView;
@property (nonatomic) CGRect m_pBoundingRect;

-(id) initWithPlayArea:(UIView*)pParentView 
		  boundingRect:(CGRect)pBoundingRect;

-(void) startNewLevel:(NSInteger)iLevel;
-(void) gameLoop;
-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
-(void) makeViewVisible;
@end
