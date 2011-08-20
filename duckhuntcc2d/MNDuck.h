//
//  MNDuck.h
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MNDuck : CCSprite {
    
}

+(MNDuck *)newDuck;

-(void)setRandomY;
-(void)setOffscreenRight;
-(CGFloat)width;
-(CGFloat)height;
-(CGFloat)x;
-(CGFloat)y;
-(CGRect)rect;
-(BOOL)containsTouchLocation:(UITouch *)touch;

@end
