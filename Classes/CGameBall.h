//
//  CGameBall.h
//  theBall
//
//  Created by Faisal Saeed on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBall.h"

@interface CGameBall : CBall 
{
	NSInteger m_iLevel;
	NSInteger m_iSelfIdx;
	NSInteger m_iParentIdx;
	//NSInteger m_iChildCount;
	//NSMutableArray *m_pChildIdxArray;
	NSInteger m_iChildIdx1;
	NSInteger m_iChildIdx2;
}

@property (nonatomic) NSInteger m_iLevel;
@property (nonatomic) NSInteger m_iSelfIdx;
@property (nonatomic) NSInteger m_iParentIdx;
@property (nonatomic) NSInteger m_iChildIdx1;
@property (nonatomic) NSInteger m_iChildIdx2;
//@property (nonatomic) NSInteger m_iChildCount;
//@property (nonatomic,retain) NSMutableArray *m_pChildIdxArray;

-(id) initBallWithLevel:(CGFloat) pRadius boundingRect:(CGRect)pBoundingRect centerPt:(CGPoint)pCenterpt level:(int)pLevel;

@end
