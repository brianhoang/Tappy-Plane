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
@property (nonatomic) SKEmitterNode *puffTrail;
@property (nonatomic) CGFloat puffBirthRate;

@end

static NSString* const keyPlaneAnimation = @"PlaneAnimation";

@implementation TPPlane

-(id)init
{
    self = [super initWithImageNamed:@"planeBlue1@2x"];
    if(self){
        
        //setup physics body
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width *0.5];
        self.physicsBody.mass = 0.08;
        
        
        //init arry to told animation actions
        _planeAnimations = [[NSMutableArray alloc]init];
        
        //load animation plist file
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PlaneAnimation" ofType: @"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSString *key in animations){
            [self.planeAnimations addObject:[self animationFromArray:[animations objectForKey:key]  withDuration:0.4]];
        }
        
        //set puff trail particle effect, reading and using sks particle file
        NSString *particleFile = [[NSBundle mainBundle] pathForResource:@"PlaneTrail" ofType:@"sks"];
        _puffTrail = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFile];
        _puffTrail.position = CGPointMake(-self.size.width * 0.5, -10);
        [self addChild:_puffTrail];
        self.puffBirthRate = self.puffTrail.particleBirthRate;
        self.puffTrail.particleBirthRate = 0;
        [self setRandomColor];
        
    }
    return self;
}


-(void)setEngineRunning:(BOOL)engineRunning
{
    _engineRunning = engineRunning;
    if(engineRunning){
        self.puffTrail.targetNode = self.parent;
        [self actionForKey:keyPlaneAnimation].speed = 1;
        self.puffTrail.particleBirthRate = self.puffBirthRate;

    }
    else{
        [self actionForKey:keyPlaneAnimation].speed = 0;
        self.puffTrail.particleBirthRate = 0;

   
    }
}




-(void)setRandomColor
{
    [self removeActionForKey:keyPlaneAnimation ];
    SKAction *animation =[self.planeAnimations objectAtIndex:arc4random_uniform((u_int32_t)self.planeAnimations.count)];

    [self runAction: animation withKey:keyPlaneAnimation];
    if(!self.engineRunning){
        [self actionForKey:keyPlaneAnimation].speed = 0;;
    }
    
}

-(SKAction*)animationFromArray:(NSArray*)textureNames withDuration:(CGFloat)duration
{
    //create array to hold texture
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    //get planes atlas
    SKTextureAtlas *planeAtlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
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

-(void)update{
    
    if(self.accelerating){
        //calling every frame, more force equals faster movement,
        //takes into account the mass of plane
        [self.physicsBody applyForce:CGVectorMake(0.0, 100)];
    }
}

@end
