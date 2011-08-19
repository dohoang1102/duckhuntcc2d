//
//  IntroSlidesLayer.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IntroSlidesLayer.h"
#import "MenuLayer.h"

@implementation IntroSlidesLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroSlidesLayer *layer = [IntroSlidesLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super" return value
    if( (self=[super init])) {
        self.isTouchEnabled = YES;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGPoint position =  ccp( size.width /2 , size.height/2 );
        
        CCSprite *back1 = [CCSprite node];
        CCLabelTTF *lbl = [CCLabelTTF labelWithString:@"My First Game" fontName:@"AmericanTypewriter" fontSize:25.0f];
        lbl.position = position;
        [back1 addChild:lbl];
        
        CCSprite *back2 = [CCSprite node];
        lbl = [CCLabelTTF labelWithString:@"By Matthew Nunes" fontName:@"AmericanTypewriter" fontSize:20.0f];
        lbl.position = position;
        [back2 addChild:lbl];
        
        CCSprite *back3 = [CCSprite node];
        lbl = [CCLabelTTF labelWithString:@"©2011" fontName:@"AmericanTypewriter" fontSize:15.0f];
        lbl.position = position;
        [back3 addChild:lbl];
        
        backgrounds = [[NSMutableArray arrayWithObjects:back1, back2, back3, nil] retain];
        
        [self tick:0];
        [self schedule:@selector(tick:) interval:3];
    }
    return self;
}

- (void)tick:(ccTime *)dt
{
    if( [backgrounds count] > 0 ) {
        [self flipSlide:[backgrounds objectAtIndex:0]];
        [backgrounds removeObjectAtIndex:0];
    }
    else {
        [self nextScene];
    }
}

- (void)nextScene
{
    CCScene *menuScene = [MenuLayer scene];
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:0.5 scene:menuScene];
    [[CCDirector sharedDirector] replaceScene:transition];
}

- (void)flipSlide:(CCSprite *)sprite
{
    if( [[self children] containsObject:_background] ) {
        [self removeChild:_background cleanup:YES];
    }
    
    _background = sprite;
    [self addChild:_background];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self nextScene];
}

- (void)dealloc
{
    // _background is released automatically
    [backgrounds release];
    [super dealloc];
}

@end
