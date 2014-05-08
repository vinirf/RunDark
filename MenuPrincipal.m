//
//  MenuPrincipal.m
//  RunDark
//
//  Created by Vinicius Resende Fialho on 15/03/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import "MenuPrincipal.h"
#import "MyScene.h"

@implementation MenuPrincipal


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        fundo = [[SKNode alloc]init];
        fundo.name = @"FundoMenu";
        fundo.position  = CGPointMake(500,500);
        
        SKTexture *texturaFundo = [SKTexture textureWithImageNamed:@"fundoMenu.jpg"];
        self.fundoMenu = [SKSpriteNode spriteNodeWithTexture:texturaFundo size:CGSizeMake(1000,600)];
        [fundo addChild: self.fundoMenu];
        [self addChild:fundo];
        
        NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"menuSound" ofType:@"mp3"]];
        queuePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
        queuePlayer.volume = 1.0;
        queuePlayer.numberOfLoops = -1;
        [queuePlayer play];
        
        [self addChild:[self buttonStartGame]];
        [self addChild:[self buttonRecord]];
        [self addChild:[self buttonExit]];
    }
    
    return self;
}


- (SKSpriteNode *)buttonStartGame{
    SKSpriteNode *fireNode = [SKSpriteNode spriteNodeWithImageNamed:@"buttonJogar.png"];
    fireNode.position = CGPointMake(320,500);
    fireNode.size = CGSizeMake(80,20);
    fireNode.name = @"Jogar";//how the node is identified later
    fireNode.zPosition = +5.0;
    return fireNode;
}

- (SKSpriteNode *)buttonRecord{
    SKSpriteNode *fireNode = [SKSpriteNode spriteNodeWithImageNamed:@"buttonRecorde"];
    fireNode.position = CGPointMake(400,450);
    fireNode.size = CGSizeMake(80,20);
    fireNode.name = @"Recorde";//how the node is identified later
    fireNode.zPosition = +5.0;
    return fireNode;
}

- (SKSpriteNode *)buttonExit{
    SKSpriteNode *fireNode = [SKSpriteNode spriteNodeWithImageNamed:@"buttonSair"];
    fireNode.position = CGPointMake(480,400);
    fireNode.size = CGSizeMake(60,20);
    fireNode.name = @"Exit";//how the node is identified later
    fireNode.zPosition = +5.0;
    return fireNode;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"Jogar"]) {
        
        MyScene *inicioJogo = [[MyScene alloc]initWithSize:CGSizeMake(768, 1024)];
        inicioJogo.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *animate = [SKTransition fadeWithDuration:1.0f];
        [self.view presentScene:inicioJogo transition:animate];
    }
    
    if ([node.name isEqualToString:@"Recorde"]) {
       
    }
    
    if ([node.name isEqualToString:@"Exit"]) {
        //home button press programmatically
        [queuePlayer stop];
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        
        //wait 2 seconds while app is going background
        [NSThread sleepForTimeInterval:2.0];
        
        //exit app when app is in background
        exit(0);
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}



@end
