//
//  GameScene.m
//  tset
//
//  Created by Brian Hoang on 12/26/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "TPGameScene.h"
#import "TPPlane.h"
#import "ScrollingLayer.h"
#import "Constants.h"

@interface TPGameScene()

@property (nonatomic) TPPlane *player;
@property (nonatomic) SKNode  *world;
@property (nonatomic) ScrollingLayer *background;
@property (nonatomic) ScrollingLayer *foreground;


@end

@implementation TPGameScene


-(void)didMoveToView:(SKView *)view {
    
    //set background color
    self.backgroundColor = [SKColor colorWithRed:.835294118 green:.929411765 blue:.968627451 alpha:1.0];
    

    
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    
    
    //setup physcis
    self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
    self.physicsWorld.contactDelegate = self;
    
    //setup world
    _world = [SKNode node];
    [self addChild:_world];
  
    /*
    SKSpriteNode *tile1 = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]];
    SKSpriteNode *tile2 = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]];
    SKSpriteNode *tile3 = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]];
    SKSpriteNode *tile4 = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]];
     */
    
    NSMutableArray *backgroundTiles = [[NSMutableArray alloc] init];
  /*
    [backgroundTiles addObject:tile1 ];
    [backgroundTiles addObject:tile2 ];
    [backgroundTiles addObject:tile3 ];
    [backgroundTiles addObject:tile4 ];
   */
    for(int i = 0 ; i<3; i++){
        [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
    }
    //_background = nil;
    _background = [[ScrollingLayer alloc] initWithTiles:backgroundTiles];
    _background.position = CGPointMake(0, 30);
    _background.horizontalScrollSpeed = -60;
    _background.scrolling = YES;
    [_world addChild: _background];
    
    
    //setup foreground
    NSMutableArray *foregroundTile = [[NSMutableArray alloc] init];

    for(int i = 0 ; i<3; i++){
        [foregroundTile addObject:[self generateGroundTile]];
    }
    _foreground = [[ScrollingLayer alloc] initWithTiles:foregroundTile];
    _foreground.position = CGPointMake(0, 0);
    _foreground.horizontalScrollSpeed = -40;
    _foreground.scrolling = YES;

    
    [_world addChild: _foreground];
    
    
    
    //set up player
    _player = [[TPPlane alloc] init];
    //place in middle of scene
    //_player.anchorPoint = CGPointZero;
    _player.position = CGPointMake(self.size.width * .5 - 150, self.size.height * .5 - 150);
    _player.physicsBody.affectedByGravity = NO;
    [_world addChild:_player];
    _player.engineRunning = YES;
    
}


-(SKSpriteNode*)generateGroundTile
{
    
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    
    sprite.anchorPoint = CGPointZero;
    
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    //creates a physicsbody for the foreground using the website
    //dazchong.com/spritekit/ - currently unavailble :(
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 403 - offsetX, 15 - offsetY);
    CGPathAddLineToPoint(path, NULL, 367 - offsetX, 35 - offsetY);
    CGPathAddLineToPoint(path, NULL, 329 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 287 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 235 - offsetX, 11 - offsetY);
    CGPathAddLineToPoint(path, NULL, 205 - offsetX, 28 - offsetY);
    CGPathAddLineToPoint(path, NULL, 168 - offsetX, 20 - offsetY);
    CGPathAddLineToPoint(path, NULL, 122 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 76 - offsetX, 31 - offsetY);
    CGPathAddLineToPoint(path, NULL, 46 - offsetX, 11 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 16 - offsetY);
    
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    sprite.physicsBody.categoryBitMask = _GROUND_CATEGORY;
    return sprite;
}



-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if(contact.bodyA.categoryBitMask == _PLANE_CATEGORY){
        [self.player collide:contact.bodyB];
    }
    else if (contact.bodyB.categoryBitMask == _PLANE_CATEGORY){
        [self.player collide:contact.bodyA];
    }
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches){
        _player.physicsBody.affectedByGravity = YES;
        self.player.accelerating = YES;
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches){
        self.player.accelerating = NO;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    static CFTimeInterval lastCallTime;
    CFTimeInterval timeElapsd = currentTime - lastCallTime;
    if (timeElapsd > 10.0 / 60.0 ){
        timeElapsd = 10.0/60.0;
    }
    lastCallTime = currentTime;
    

    [self.player update];
    if(!self.player.crashed){
        [self.background updateWithTimesElapsed:timeElapsd];
        [self.foreground updateWithTimesElapsed:timeElapsd];
    }
    
}

@end
