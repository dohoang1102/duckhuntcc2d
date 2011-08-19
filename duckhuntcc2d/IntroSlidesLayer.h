//
//  IntroSlidesLayer.h
//  duckhuntcc2d
//
//  Created by Matthew on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface IntroSlidesLayer : CCLayer {
    NSMutableArray *backgrounds;
    CCSprite *_background;
}

- (void)tick:(ccTime *)dt;
- (void)flipSlide:(CCSprite *)sprite;
- (void)nextScene;

@end
