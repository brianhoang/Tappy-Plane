//
//  TPPlane.m
//  Tappy Plane
//
//  Created by Brian Hoang on 12/26/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "TPPlane.h"
//#import "Constants.h"

const uint32_t _PLANE_CATEGORY    = 0x1 << 0;
const uint32_t _GROUND_CATEGORY   = 0x1 << 1;

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
        
        //setup physics body again using the website
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
       
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 43 - offsetX, 18 - offsetY);
        CGPathAddLineToPoint(path, NULL, 34 - offsetX, 36 - offsetY);
        CGPathAddLineToPoint(path, NULL, 11 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 28 - offsetY);
        CGPathAddLineToPoint(path, NULL, 10 - offsetX, 4 - offsetY);
        CGPathAddLineToPoint(path, NULL, 29 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 37 - offsetX, 5 - offsetY);
        CGPathCloseSubpath(path);
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        self.physicsBody.mass = 0.08;
        self.physicsBody.categoryBitMask = _PLANE_CATEGORY;
        //lets us know when plane touches ground
        self.physicsBody.contactTestBitMask = _GROUND_CATEGORY;

        
        //init arry to told animation actions
        _planeAnimations = [[NSMutableArray alloc]init];
        
        //load animation plist file
        NSString *pathToPlist = [[NSBundle mainBundle] pathForResource:@"PlaneAnimation" ofType: @"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:pathToPlist];
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
    _engineRunning = engineRunning && (!self.crashed);
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

-(void)setAccelerating:(BOOL)accelerating
{
    _accelerating = accelerating && (!self.crashed);
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


-(void)setCrashed:(BOOL)crashed{
    _crashed = crashed;
    if (crashed){
        self.engineRunning = NO;
        self.accelerating = NO;
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

-(void)collide:(SKPhysicsBody *)body
{
    //ignore collision if already crashed
    if(!self.crashed){
    //if it hits the ground
        if (body.categoryBitMask == _GROUND_CATEGORY){
            self.crashed = YES;
        }
    }
}


-(void)update{
    
    if(self.accelerating){
        //calling every frame, more force equals faster movement,
        //takes into account the mass of plane
        [self.physicsBody applyForce:CGVectorMake(0.0, 100)];
    }
}

@end
