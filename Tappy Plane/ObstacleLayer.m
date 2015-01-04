//
//  ObstacleLayer.m
//  Tappy Plane
//
//  Created by Brian Hoang on 12/31/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "ObstacleLayer.h"
#import "Constants.h"
#import "TileSetTexture.h"

@interface ObstacleLayer()

//maker used to know when to place an obstacle
@property (nonatomic) CGFloat marker;

@end

const uint32_t _STAR_CATEGORY     = 0x1 << 2;

static const CGFloat markerBuffer = 200.0;

//verticle space between top and bottom mountain (for plane to fly through)
static const CGFloat verticalGap = 90.0;
//spaces between first mounatain and next one
static const CGFloat spaceBetweenMarker = 180;
//star postition
static const int starPosition = 200;
//keep star in range
static const CGFloat starRange = 50.0;


static NSString *const keyMountainUp = @"MountainUp";
static NSString *const keyMountainDown = @"MountainDown";
static NSString *const keyStar = @"star";


@implementation ObstacleLayer


-(void)reset{
    
    //if new game, move current objects to the left of screen for reuse
    for (SKNode *node in self.children){
        node.position = CGPointMake(-1000, 0);
        //getting new textures
        if(node.name == keyMountainUp){
            ((SKSpriteNode*)node).texture = [[TileSetTexture getProvider] getTextureForKey:@"mountainUp"];
        }
        if(node.name == keyMountainDown){
            ((SKSpriteNode*)node).texture = [[TileSetTexture getProvider] getTextureForKey:@"mountainDown"];
        }

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
        //buffer us used so that we add an obsticle before we get to the marker
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
    //get star node
    SKSpriteNode *star = [self getUnusedObjectForKey:keyStar];
    
    //calculate max movement of mountain
    //half the ceiling because obstacle graphics where for a smaller screen
    //of iphone 6, half the ceiling otherwise maxvar is negative (meaning no excess off screen)
    CGFloat maxVar = ((mountainUp.size.height + mountainDown.size.height + verticalGap) - ((self.ceiling)  - self.floor));
    //should never be negitive
    if (maxVar < 0 ){
        maxVar = maxVar * -1;
    }
    CGFloat yAdjustment = (CGFloat)arc4random_uniform(maxVar);

    //position mountain nodes
mountainUp.position = CGPointMake(self.marker, self.floor + (mountainUp.size.height *0.5)- (yAdjustment));
mountainDown.position = CGPointMake(self.marker, mountainUp.position.y + mountainDown.size.height + verticalGap);
    
    //postion star node
    //position.y will give us the midle of the mountain, adding half the size will give us the top
    CGFloat midpoint = mountainUp.position.y + (mountainUp.size.height * 0.5) + (verticalGap * 0.5);
    //will give us a postive or negaive postion of star within gap
    CGFloat yPosition = midpoint + arc4random_uniform(starPosition) - (starPosition * 0.5);
    
    //incase the star is out of scene
    //choose the max or min of the two parameters
    yPosition = fmaxf(yPosition, self.floor + starRange);
    yPosition = fminf(yPosition, self.ceiling - starRange);
    
    star.position = CGPointMake(self.marker + (spaceBetweenMarker * 0.5), yPosition);
    
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
        object = [SKSpriteNode spriteNodeWithTexture: [[TileSetTexture getProvider] getTextureForKey:@"mountainUp"]];
        
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
    
   else if(key == keyMountainDown){
       object = [SKSpriteNode spriteNodeWithTexture: [[TileSetTexture getProvider] getTextureForKey:@"mountainDown"]];
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
    
   else if (key == keyStar) {
        object = [Collectable spriteNodeWithTexture:[graphics textureNamed: @"starGold"]];
       ((Collectable*)object).pointValue = 1;
       ((Collectable*)object).delegate = self.collectableDelegate;
        //want a circle because we just want the plane somewhere close, does not need
        //to be exact
        object.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:object.size.width * 0.3 ];
        object.physicsBody.categoryBitMask = _STAR_CATEGORY;
        //star is not affected by gravity
        object.physicsBody.dynamic = NO;
        
        [self addChild:object];
    }
    
    if(object){
        object.name = key;
    }
    return object;
}

@end
