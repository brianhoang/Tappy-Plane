//
//  TileSetTexture.m
//  Tappy Plane
//
//  Created by Brian Hoang on 1/3/15.
//  Copyright (c) 2015 Brian Hoang. All rights reserved.
//

#import "TileSetTexture.h"

@interface TileSetTexture()

@property (nonatomic) NSMutableDictionary *tilesets;
@property (nonatomic) NSDictionary *currentSet;

@end

@implementation TileSetTexture

//+ means can be called on the class
+(instancetype)getProvider
{
    static TileSetTexture* provider = nil;
    @synchronized(self){
        if(!provider){
            provider = [[TileSetTexture alloc]init];
        }
        return provider;
    }
}


-(instancetype)init
{
    self = [super init];
    if(self){
        [self loadTileSets];
        [self randomTiles];
    }
    return self;
}

-(void)loadTileSets
{
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    self.tilesets = [[NSMutableDictionary alloc] init];
    
    //get path to plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TileSet" ofType:@"plist"];
    //load contents of file
    NSDictionary *tileList = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    //loop through tileList
    for(NSString* tileKey in tileList){
        //get dictionary of texture names
        NSDictionary *textureList = [tileList objectForKey:tileKey];
        //create dictionary to hold texture
        NSMutableDictionary *texture = [[NSMutableDictionary alloc]init];
        
        for (NSString* textureKey in textureList){
            //get texture for ey
            SKTexture *textures = [atlas textureNamed:[textureList objectForKey:textureKey]];
            //inset texture into textur dictionary
            [texture setObject:textures forKey:textureKey];
        }
        
        //addd texture dictionary to tilesets
        [self.tilesets setObject:texture forKey:tileKey];
    }
}

-(void)randomTiles
{
    NSArray *tileSetKey = [self.tilesets allKeys];
    NSString *key = [tileSetKey objectAtIndex:arc4random_uniform((uint)tileSetKey.count)];
    self.currentSet = [self.tilesets objectForKey:key];
}


-(SKTexture*)getTextureForKey:(NSString*)key;
{
    return [self.currentSet objectForKey:key];
}

@end
