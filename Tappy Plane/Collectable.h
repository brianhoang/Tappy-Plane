//
//  Collectable.h
//  Tappy Plane
//
//  Created by Brian Hoang on 1/3/15.
//  Copyright (c) 2015 Brian Hoang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Collectable;

@protocol CollectableDelegate <NSObject>

-(void)wasCollected:(Collectable*)collectable;

@end

@interface Collectable : SKSpriteNode

//weak to prevent circular reference
@property (nonatomic, weak ) id<CollectableDelegate> delegate;
@property (nonatomic) NSInteger pointValue;

-(void) collect;

@end
