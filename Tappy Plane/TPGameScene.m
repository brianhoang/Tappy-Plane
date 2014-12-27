//
//  GameScene.m
//  tset
//
//  Created by Brian Hoang on 12/26/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "TPGameScene.h"
#import "TPPlane.h"

@interface TPGameScene()

@property (nonatomic) TPPlane *player;
@property (nonatomic) SKNode  *world;

@end

@implementation TPGameScene


-(void)didMoveToView:(SKView *)view {
    
    
    //setup world
    _world = [SKNode node];
    [self addChild:_world];
    
    //set up player
    _player = [[TPPlane alloc] init];
    //place in middle of scene
    _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    [_world addChild:_player];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches){
        [self.player setRandomColor];
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
