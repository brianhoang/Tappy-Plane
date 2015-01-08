//
//  TPGameScene.h
//  Tappy Plane
//
//  Created by Brian Hoang on 12/26/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Collectable.h"
#import "GameOverMenu.h"

@interface TPGameScene : SKScene <SKPhysicsContactDelegate, CollectableDelegate ,GameOverMenuDelegate>

@end
