//
//  EAGLView.h
//  glApp
//
//  Created by Faisal Saeed on 4/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

enum cornorType {TOPLEFT = 0, BOTTOMLEFT, BOTTOMRIGHT, TOPRIGHT};

struct vertex // a 3D vertex
{
	GLfloat x;
	GLfloat y;
	GLfloat z;
};

struct rectangle // a 3D rectangle
{
	struct vertex cornors[4];
};


/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
@interface EAGLView : UIView
{
    
@private
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
	
	float m_fXAxisRotation;
	float m_fYAxisRotation;
	float m_fZAxisRotation;
	
	GLuint textures[10];
	
	GLfloat rota;
	GLfloat moveAhead;
	struct rectangle m_vImageHolder;
	struct vertex m_vImageCenter;
}

@property (nonatomic) float moveAhead;
@property (nonatomic) struct vertex m_vImageCenter;
@property (nonatomic) float m_fXAxisRotation;
@property (nonatomic) float m_fYAxisRotation;
@property (nonatomic) float m_fZAxisRotation;

@property NSTimeInterval animationInterval;

- (void)setupView;
- (void)checkGLError:(BOOL)visibleCheck;
- (void)loadTexture:(NSString *)name intoLocation:(GLuint)location;

- (CGRect) getScreenBounds;
- (void)updateRectangleVertex:(enum cornorType)pCornorType newVertex:(struct vertex) pNewVertex;
- (void)updateRotationParams:(float)xParam YAxis:(float)yParam ZAxis:(float)zParam;
- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;

@end
