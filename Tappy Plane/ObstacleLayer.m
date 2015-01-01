//
//  ObstacleLayer.m
//  Tappy Plane
//
//  Created by Brian Hoang on 12/31/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "ObstacleLayer.h"
#import "Constants.h"
@interface ObstacleLayer()

//maker used to know when to place an obstacle
@property (nonatomic) CGFloat marker;

@end

static const CGFloat markerBuffer = 200.0;
static const CGFloat verticalGap = 90.0;
static const CGFloat spaceBetweenMarker = 180;

static NSString *const keyMountainUp = @"MountainUp";
static NSString *const keyMountainDown = @"MountainDown";


@implementation ObstacleLayer


-(void)reset{
    
    //if new game, move current objects to the left of screen for reuse
    for (SKNode *node in self.children){
        node.position = CGPointMake(-1000, 0);
    }
    
    //reposition marker
    if(self.scene){
        self.marker = self.scene.size.width +markerBuffer;
    }
}


-(void)updateWithTimesElapsed:(NSTimeInterval)timeElapsed
{
    [super updateWithTimesElapsed:timeElapsed];
    
    if(self.scrolling && self.scene) {
        //find marker's location in scene corrdinates
        CGPoint markerLocationInScene = [self convertPoint:CGPointMake(self.marker, 0) toNode:self.scene];
        //when marker comes onto screen, add new obstacles
        if(markerLocationInScene.x - (self.scene.size.width * self.scene.anchorPoint.x) < self.scene.size.width + markerBuffer){
            [self addObstacleSet];
        }
    }
    
}


-(void)addObstacleSet
{
    //get mountain nodes
    SKSpriteNode *mountainUp = [self getUnusedObjectForKey:keyMountainUp];
    SKSpriteNode *mountainDown = [self getUnusedObjectForKey:keyMountainDown];
    
    //calculate max movement of mountain
    //half the ceiling because obstacle graphics where for a smaller screen
    //of iphone 6, half the ceiling otherwise maxvar is negative (meaning no excess off screen)
    CGFloat maxVar = ((mountainUp.size.height + mountainDown.size.height + verticalGap) - ((self.ceiling * 0.5)  - self.floor));
    //should never be negitive
    if (maxVar < 0 ){
        maxVar = maxVar * -1;
    }
    CGFloat yAdjustment = (CGFloat)arc4random_uniform(maxVar);


    //position mountain nodes
    
        mountainUp.position = CGPointMake(self.marker, self.floor + (mountainUp.size.height *0.5)- (yAdjustment));

    mountainDown.position = CGPointMake(self.marker, mountainUp.position.y + mountainDown.size.height + verticalGap);
    
    //reposition marker
    self.marker += spaceBetweenMarker;
}


-(SKSpriteNode*)getUnusedObjectForKey:(NSString*)key
{
    if (self.scene){
        //get left edge of scene in local coord
        CGFloat leftEdge = [self.scene convertPoint:CGPointMake(-self.scene.size.width * self.scene.anchorPoint.x, 0) toNode:self].x;
        
        //try find object for key to the left of the screen
        for(SKSpriteNode *node in self.children){
            if(node.name == key && node.frame.origin.x + node.frame.size.width < leftEdge){
                return node;
            }
            
        }
    }
    
    //cant find unused node with key, so create a new one
    return [self createObjectForKey:key];
}


-(SKSpriteNode*)createObjectForKey: (NSString*) key
{
    SKSpriteNode *object = nil;
    
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    if(key == keyMountainUp){
        object = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"MountainGrass"]];
        
        //from that website that is unavaibale
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 55 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 0 - offsetY);
        CGPathCloseSubpath(path);
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = _GROUND_CATEGORY;
        
        [self addChild:object];
    }
    
    if(key == keyMountainDown){
        object = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"MountainGrassDown"]];
        
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 55 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 199 - offsetY);
        CGPathCloseSubpath(path);
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = _GROUND_CATEGORY;

        [self addChild:object];

    }
    
    if(object){
        object.name = key;
    }
    return object;
}

@end
