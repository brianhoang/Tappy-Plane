//
//  TPPlane.m
//  Tappy Plane
//
//  Created by Brian Hoang on 12/26/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "TPPlane.h"


@interface TPPlane()

//holes animation actions
@property (nonatomic) NSMutableArray *planeAnimations;

@end

@implementation TPPlane

-(id)init
{
    self = [super initWithImageNamed:@"planeBlue1@2x"];
    if(self){
        
        //init arry to told animation actions
        _planeAnimations = [[NSMutableArray alloc]init];
        
        //load animation plist file
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PlaneAnimation" ofType: @"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSString *key in animations){
            [self.planeAnimations addObject:[self animationFromArray:[animations objectForKey:key]  withDuration:0.4]];
        }
        [self setRandomColor];
        
    }
    return self;
}

-(void)setRandomColor
{
    [self runAction:[self.planeAnimations objectAtIndex:arc4random_uniform(self.planeAnimations.count)]];
}


-(SKAction*)animationFromArray:(NSArray*)textureNames withDuration:(CGFloat)duration
{
    //create array to hold texture
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    //get planes atlas
    SKTextureAtlas *planeAtlas = [SKTextureAtlas atlasNamed:@"Planes"];
    
    //look through textureNmaes array and load textures
    for (NSString *textureName in textureNames){
        [frames addObject:[planeAtlas textureNamed:textureName]];
    }
    
    //calculate times per frame
    CGFloat frameTime = duration / (CGFloat)frames.count;
    
    //create and return animation action
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:frameTime
                                                                resize:NO restore:NO]];
}

@end
