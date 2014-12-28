//
//  GameScene.m
//  tset
//
//  Created by Brian Hoang on 12/26/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "TPGameScene.h"
#import "TPPlane.h"
#import "ScrollLayer.h"
#import "SCTileNode.h"

@interface TPGameScene()

@property (nonatomic) TPPlane *player;
@property (nonatomic) SKNode  *world;
@property (nonatomic) ScrollLayer *background;


@end

@implementation TPGameScene{
    SCTileNode *_leftmostTile;
    SCTileNode *_rightmostTile;
    int direction;

}

static const CGFloat kScrollSpeed = 70;

-(void)didMoveToView:(SKView *)view {
    direction = -1;
    
    _leftmostTile = nil;
    _rightmostTile = nil;
    
    //get atlas files
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    
    //setup physcis
    self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
    
    //setup world
    _world = [SKNode node];
    [self addChild:_world];
  
    //setup background
    NSMutableArray *backgroundTiles = [[NSMutableArray alloc]init];
    for (int i = 3; i < 3; i++){
        [ backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
    }
 

        SCTileNode *tile = [SCTileNode spriteNodeWithImageNamed:@"background"];
        tile.anchorPoint = CGPointZero;
        if(!_leftmostTile) {
            _leftmostTile = tile;
        }
        if(_rightmostTile){
            tile.position = CGPointMake(_rightmostTile.position.x + _rightmostTile.size.width, _rightmostTile.position.y );
        }else{
            tile.position = CGPointMake(0, 240);
        }
        tile.prevTile = _rightmostTile;
        _rightmostTile.nextTile = tile;
        _rightmostTile = tile;
    NSLog(@"sdfdsfd %f %f", tile.position.x, tile.position.y);

        [_world addChild:tile];
    
    SCTileNode *tile1 = [SCTileNode spriteNodeWithImageNamed:@"background"];
    tile1.anchorPoint = CGPointZero;
    if(!_leftmostTile) {
        _leftmostTile = tile1;
    }
    if(_rightmostTile){
        tile1.position = CGPointMake(_rightmostTile.position.x + _rightmostTile.size.width, _rightmostTile.position.y  ) ;
    }else{
        tile1.position = CGPointZero;
    }

    tile1.prevTile = _rightmostTile;
    _rightmostTile.nextTile = tile1;
    _rightmostTile = tile1;
    NSLog(@"sdfdsfd %f %f", tile1.position.x, tile1.position.y);

    [_world addChild:tile1];
    
    
    SCTileNode *tile2 = [SCTileNode spriteNodeWithImageNamed:@"background"];
    tile2.anchorPoint = CGPointZero;
    if(!_leftmostTile) {
        _leftmostTile = tile2;
    }
    if(_rightmostTile){
        tile2.position = CGPointMake(_rightmostTile.position.x + _rightmostTile.size.width, _rightmostTile.position.y) ;
    }else{
        tile2.position = CGPointZero;
    }

    tile2.prevTile = _rightmostTile;
    _rightmostTile.nextTile = tile2;
    _rightmostTile = tile2;
    NSLog(@"sdfdsfd %f %f", tile2.position.x, tile2.position.y);

    [_world addChild:tile2];
    
    SCTileNode *tile3 = [SCTileNode spriteNodeWithImageNamed:@"background"];
    tile3.anchorPoint = CGPointZero;
    if(!_leftmostTile) {
        _leftmostTile = tile3;
    }
    if(_rightmostTile){
        tile3.position = CGPointMake(_rightmostTile.position.x + _rightmostTile.size.width, _rightmostTile.position.y) ;
    }else{
        tile3.position = CGPointZero;
    }
    
    tile3.prevTile = _rightmostTile;
    _rightmostTile.nextTile = tile3;
    _rightmostTile = tile3;
    NSLog(@"sdfdsfd %f %f", tile3.position.x, tile3.position.y);
    
    [_world addChild:tile3];

    
    _leftmostTile.prevTile= _rightmostTile;
    _rightmostTile.nextTile = _leftmostTile;
    

    
    //set up player
    _player = [[TPPlane alloc] init];
    //place in middle of scene
    _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    _player.physicsBody.affectedByGravity = NO;
    [_world addChild:_player];
    _player.engineRunning = YES;
    
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
    //[self.player update];
    static CFTimeInterval lastCallTime;
    CFTimeInterval timeElapsd = currentTime - lastCallTime;
    if (timeElapsd > 10.0 / 60.0 ){
        timeElapsd = 10.0/60.0;
    }
    lastCallTime = currentTime;
    
    CGFloat scrollDistance = kScrollSpeed * timeElapsd;
    
    SCTileNode *tile = _leftmostTile;
    do{
        tile.position = CGPointMake(tile.position.x + (scrollDistance * direction), tile.position.y);
        tile = tile.nextTile;
    }while (tile != _leftmostTile);
    
    if(direction == -1){
        if(_leftmostTile.position.x + _leftmostTile.size.width < 0){
         _leftmostTile.position = CGPointMake(_rightmostTile.position.x + _rightmostTile.size.width ,
                                              _leftmostTile.position.y);
            _rightmostTile = _leftmostTile;
            _leftmostTile = _leftmostTile.nextTile;
        }
    }
    if(self.player.accelerating){
        //calling every frame, more force equals faster movement,
        //takes into account the mass of plane
        [_player.physicsBody applyForce:CGVectorMake(0.0, 100)];
    }
    
}

@end
