//
//  TileSetTexture.h
//  Tappy Plane
//
//  Created by Brian Hoang on 1/3/15.
//  Copyright (c) 2015 Brian Hoang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface TileSetTexture : NSObject

+(instancetype)getProvider;

-(void)randomTiles;
-(SKTexture*)getTextureForKey:(NSString*)key;

@end
