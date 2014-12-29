//
//  ScrollingLayer.m
//  Tappy Plane
//
//  Created by Brian Hoang on 12/28/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "ScrollingLayer.h"

@interface ScrollingLayer()

//@property (nonatomic) SKSpriteNode *nextTile;
//@property (nonatomic) SKSpriteNode *prevTile;
@property (nonatomic) SKSpriteNode *rightmostTile;
@end


@implementation ScrollingLayer

-(id)initWithTiles:(NSArray *)tileSpriteNodes
{
    if(self = [super init]){
        for (SKSpriteNode *tile in tileSpriteNodes){
            tile.anchorPoint = CGPointZero;
            tile.name = @"Tile";
            [self addChild:tile];
        }
        [self layoutTiles];
    }
    return self;
}


-(void)layoutTiles
{
    self.rightmostTile = nil;
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(self.rightmostTile.position.x +
                                    self.rightmostTile.size.width, node.position.y);
        self.rightmostTile = (SKSpriteNode*)node;
    }];
    
}

-(void)updateWithTimesElapsed:(NSTimeInterval)timeElapsed
{
    [super updateWithTimesElapsed:timeElapsed];
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
