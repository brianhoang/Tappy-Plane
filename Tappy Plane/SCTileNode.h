//
//  SCTileNode.h
//  Tappy Plane
//
//  Created by Brian Hoang on 12/28/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SCTileNode : SKSpriteNode

@property (nonatomic) SCTileNode *nextTile;
@property (nonatomic) SCTileNode *prevTile;

@end
