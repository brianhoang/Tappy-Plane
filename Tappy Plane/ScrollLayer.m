//
//  ScrollLayer.m
//  Tappy Plane
//
//  Created by Brian Hoang on 12/27/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "ScrollLayer.h"

@interface ScrollingNode()

@property (nonatomic) SKSpriteNode *rightmostTile;

@end


@implementation ScrollLayer

-(id)initWithTiles:(NSArray *)tilesSprite
{
   // if (self = [super init]) {
        for (SKSpriteNode *tile in tilesSprite) {
            tile.anchorPoint = CGPointZero;
            tile.name = @"Tile";
            [self addChild:tile];
        }
        [self layoutTiles];
   // }
    return self;
}

//loop throught all tiles on node and place them one after another
//dont care about order of tiles
-(void)layoutTiles
{
    self.rightmostTile = nil;
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(self.rightmostTile.position.x +
                                    self.rightmostTile.size.width, node.position.y);
        self.rightmostTile = (SKSpriteNode*)node;
    }];
    
}


-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed
{
    [super updateWithTimeElpased:timeElapsed];
    if (self.scrolling && self.horizontalScrollSpeed < 0 && self.scene) {
        [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
            CGPoint nodePostionInScene = [self convertPoint:node.position toNode:self.scene];
            if (nodePostionInScene.x + node.frame.size.width <
                -self.scene.size.width * self.scene.anchorPoint.x) {
                node.position = CGPointMake(self.rightmostTile.position.x +
                                            self.rightmostTile.size.width, node.position.y);
                self.rightmostTile = (SKSpriteNode*)node;
            }
        }];
    }
}



@end
