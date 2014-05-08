//
//  MyScene.m
//  RunDark
//
//  Created by VINICIUS RESENDE FIALHO on 13/03/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import "MyScene.h"
#import "GameOver.h"
#import "MenuPrincipal.h"


#define GRAVIDADEMUNDO -10


@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        //NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        canoTimer = 0;
        self.lastUpdateTimeInteval =0;
        self.estadoPauseJogo = 0;
        self.distanciaPercorrida = 0;
        self.AuxdistanciaPercorrida = 0;
        self.sorteaMonstro = 0;
        self.auxPosMuroPisoHeroi = 0;
        self.nivelMosntro = false;
        self.qtdPower = 5;
        self.verificaBateRecorde = false;
        self.verfificaBotaoFly = false;
        self.tempoPassaroBonus = 10;
        self.tempoPassaraoAux= 0;
        self.tempoPassaroDecrementa = 0;
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0,GRAVIDADEMUNDO );
        self.pontuacao =0;
        self.velocidadeMonstro = 4;
        
        
        self.textoDistancia = [[SKLabelNode alloc]init];
        self.textoDistancia.color = [UIColor whiteColor];
        self.textoDistancia.fontSize = 25.0f;
        self.textoDistancia.position = CGPointMake(160,760);
        self.textoDistancia.zPosition = 2;
        self.textoDistancia.text = @"0";
        self.textoDistancia.fontName = @"Marker Felt Thin";
        [self addChild:self.textoDistancia];
        
        self.tempoFly = [[SKLabelNode alloc]init];
        self.tempoFly.color = [UIColor whiteColor];
        self.tempoFly.fontSize = 25.0f;
        self.tempoFly.position = CGPointMake(330,760);
        self.tempoFly.zPosition = 2;
        self.tempoFly.text = @"0";
        self.tempoFly.fontName = @"Marker Felt Thin";
        [self addChild:self.tempoFly];
        
        SKLabelNode *stringDistancia = [[SKLabelNode alloc]init];
        stringDistancia.color = [UIColor whiteColor];
        stringDistancia.fontSize = 25.0f;
        stringDistancia.position = CGPointMake(80,762);
        stringDistancia.zPosition = 2;
        stringDistancia.text = @"Distancia: ";
        stringDistancia.fontName = @"Marker Felt Thin";
        [self addChild:stringDistancia];
        
        
        SKLabelNode *stringFly = [[SKLabelNode alloc]init];
        stringFly.color = [UIColor whiteColor];
        stringFly.fontSize = 25.0f;
        stringFly.position = CGPointMake(260,762);
        stringFly.zPosition = 2;
        stringFly.text = @"Fly Time: ";
        stringFly.fontName = @"Marker Felt Thin";
        [self addChild:stringFly];
        
        SKLabelNode *stringMagic = [[SKLabelNode alloc]init];
        stringMagic.color = [UIColor whiteColor];
        stringMagic.fontSize = 25.0f;
        stringMagic.position = CGPointMake(450,762);
        stringMagic.zPosition = 2;
        stringMagic.text = @"Qtd Magia: ";
        stringMagic.fontName = @"Marker Felt Thin";
        [self addChild:stringMagic];
        

        self.numMagia = [[SKLabelNode alloc]init];
        self.numMagia.color = [UIColor whiteColor];
        self.numMagia.fontSize = 25.0f;
        self.numMagia.position = CGPointMake(530,762);
        self.numMagia.zPosition = 2;
        self.numMagia.text = @"0";
        self.numMagia.fontName = @"Marker Felt Thin";
        [self addChild: self.numMagia];
        
        [self carregaRanking];

        
        [self carregaRanking];
        
        
        self.ranking = [[SKLabelNode alloc] init];
        self.ranking.text = [NSString stringWithFormat: @"Record: %li", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"pontuacaoRanking"]];
       //[[ NSUserDefaults standardUserDefaults] removeObjectForKey:@"pontuacaoRanking"];

        self.ranking.color = [UIColor whiteColor];
        self.ranking.position = CGPointMake(650,762);
        self.ranking.fontSize = 25.0f;
        self.ranking.fontName = @"Marker Felt Thin";
        [self addChild: self.ranking];
        
        
        
        [self instanciaClassesUnicas];
        
        
    }
    
    return self;
}

-(void)carregaRanking{
    
    self.pontuacaoJogadorNoRanking = [[NSUserDefaults standardUserDefaults] integerForKey:@"pontuacaoRanking"];
    
}

-(void)configurarRanking{
    
    
    //Adiciona a pontuacao do jogador atual a distancia percorrida
    
    self.pontuacaoJogadorAtual = self.distanciaPercorrida;
    
    
    //Verifica se bateu o rercord, se sim guarda a pontuação e nome
    
    if (self.pontuacaoJogadorAtual > self.pontuacaoJogadorNoRanking) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:self.pontuacaoJogadorAtual forKey:@"pontuacaoRanking"];
        
    }
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}



-(void)instanciaClassesUnicas {
    
    //cria cenario
    [self criaFundo];
    [self criaPiso];
    [self criaPersonagem];
    [self moverNuvens];
    [self criaMao];
   
    
    //Intancia a sknode do toasty
    SKTexture *texturaPiso = [SKTexture textureWithImageNamed:@"toasty.png"];
    self.toasty = [SKSpriteNode spriteNodeWithTexture:texturaPiso size:CGSizeMake(200,200)];
    self.toasty.position = CGPointMake(900,320);
    self.toasty.zPosition = 1.0;
    [self addChild:self.toasty];
    
    
    NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"musicaFundo" ofType:@"mp3"]];
    queuePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
    queuePlayer.volume = 1.0;
    queuePlayer.numberOfLoops = -1;
    [queuePlayer play];
 
    
    
    //Add botaoDown
    [self addChild:self.botaoDown];
    [self addChild:self.botaoUp];
    [self addChild:self.botaoPause];
    [self addChild:self.botaoRetorna];
    [self addChild: [self botaoRecomecaJogo]];
    [self addChild:[self botaoVoltarMenu]];
    [self addChild:[self botaoRunPower]];
    [self addChild:[self botaoFlyHeroe]];
    [self addChild:[self botaoHomenRetorna]];
   
}

-(void)criaFundo{
    fundo = [[SKNode alloc]init];
    fundo.name = @"Fundo";
    fundo.position  = CGPointMake(384,512);
    
    SKTexture *texturaFundo = [SKTexture textureWithImageNamed:@"Fundo.jpg"];
    self.fundoNoiteLua = [SKSpriteNode spriteNodeWithTexture:texturaFundo size:CGSizeMake(768,580)];//self.view.frame.size
    fundo.zPosition = -5;
    [fundo addChild: self.fundoNoiteLua];
    [self addChild:fundo];
}


-(void)criaMao{

    SKTexture *texturaFundo = [SKTexture textureWithImageNamed:@"mao.png"];
    self.mao = [SKSpriteNode spriteNodeWithTexture:texturaFundo size:CGSizeMake(300,900)];//self.view.frame.size
    self.mao.name = @"Mao";
    self.mao.position  = CGPointMake(120,400);
    self.mao.zPosition = -5;
    
    SKAction *moveToLeftFloor = [SKAction moveTo:CGPointMake(-50, self.mao.position.y) duration:2];
    SKAction *moveToRightFloor = [SKAction moveTo:CGPointMake(120, self.mao.position.y + 40) duration:2];
    SKAction *sequenceFloor = [SKAction sequence:@[moveToLeftFloor, moveToRightFloor]];
    [self.mao runAction:[SKAction repeatActionForever:sequenceFloor]];
    
    
    [self addChild:self.mao];
}


-(void)criaPiso {
    
    
    piso = [[SKNode alloc]init];
    piso.name = @"Piso";
    piso.position = CGPointMake(300,230);
    
    SKTexture *texturaPiso = [SKTexture textureWithImageNamed:@"pisoPedra.png"];
    self.pisoCeramica = [SKSpriteNode spriteNodeWithTexture:texturaPiso size:CGSizeMake(2000,50)];
    piso.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1900,100)];
    piso.physicsBody.dynamic = NO;
    piso.physicsBody.affectedByGravity =NO;
    piso.physicsBody.allowsRotation =NO;
    piso.physicsBody.density = 0.6f;
    piso.physicsBody.restitution =0;
    piso.physicsBody.categoryBitMask = pisoCategory;
    piso.physicsBody.contactTestBitMask = heroeCategory | monstroNivel1Category ;
    [piso addChild:self.pisoCeramica];
    
    SKAction *moveToLeftFloor = [SKAction moveTo:CGPointMake(-100, piso.position.y) duration:1];
    SKAction *moveToRightFloor = [SKAction moveTo:CGPointMake(300, piso.position.y) duration:0];
    SKAction *sequenceFloor = [SKAction sequence:@[moveToLeftFloor, moveToRightFloor]];
    [piso runAction:[SKAction repeatActionForever:sequenceFloor]];
    
    
    [self addChild:piso];
}


-(void)criaBuraco{
    buraco = [[SKSpriteNode alloc]init];
   
    
    SKTexture *texturaPiso = [SKTexture textureWithImageNamed:@"buraco.jpg"];
    buraco = [SKSpriteNode spriteNodeWithTexture:texturaPiso size:CGSizeMake(200,50)];
    buraco.name = @"Buraco";
    buraco.position = CGPointMake(800,230);
    buraco.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(150,100)];
    buraco.physicsBody.dynamic = NO;
    buraco.physicsBody.affectedByGravity =NO;
    buraco.physicsBody.allowsRotation =NO;
    buraco.physicsBody.density = 0.6f;
    buraco.physicsBody.restitution =0;
    buraco.physicsBody.categoryBitMask = buracoCategory;
    buraco.physicsBody.contactTestBitMask = heroeCategory;
    
    
    //SKAction *moveToRightFloor = [SKAction moveTo:CGPointMake(00, buraco.position.y) duration:0];
    //SKAction *sequenceFloor = [SKAction sequence:@[moveToLeftFloor]];
   
    
    SKAction *moveToLeftFloor = [SKAction moveTo:CGPointMake(-100, buraco.position.y) duration:4];
    SKAction *acaoRemover = [SKAction removeFromParent];
    [buraco runAction:[SKAction sequence:@[moveToLeftFloor,acaoRemover]]];
    
    [self addChild:buraco];
    

}

-(void)criaPersonagem{
    heroe = [[SKNode alloc]init];
    heroe.name = @"Heroe";
    heroe.position = CGPointMake(250,300);
    
    self.man = [[SKSpriteNode alloc]init];
    self.man.name = @"HumanWhite";
    [self.man setSize:CGSizeMake(100,150)];
    self.man.position = CGPointMake(0, 0);
    self.man.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.man.size.width/2];
    self.man.physicsBody.dynamic = YES;
    self.man.physicsBody.affectedByGravity =YES;
    self.man.physicsBody.allowsRotation =NO;
    self.man.physicsBody.density = 0.2f;
    self.man.physicsBody.usesPreciseCollisionDetection = YES;
    self.man.physicsBody.restitution =0;
    self.man.physicsBody.categoryBitMask = heroeCategory;
    self.man.physicsBody.contactTestBitMask = pisoCategory | monstroNivel1Category | monstroNivel2Category | monstroNivel3Category | monstroNivel4Category ;
    //self.man.physicsBody.velocity = CGVectorMake(80,400);
    
    [self heroRun];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"brilho" ofType:@"sks"];
    self.particulaBrilho = [NSKeyedUnarchiver unarchiveObjectWithFile: path];
    [self.man addChild:self.particulaBrilho];
    
    [heroe addChild:self.man];
    [self addChild:heroe];
    
}

-(void)criaPoderHeroi{
    self.power = [[SKSpriteNode alloc]init];
    self.power.name = @"PowerHeroe";
    [self.power setSize:CGSizeMake(5,50)];
    self.power.position = CGPointMake(320, heroe.position.y + self.man.position.y);
    self.power.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(5,50)];
    self.power.physicsBody.dynamic = YES;
    self.power.physicsBody.affectedByGravity = NO;
    self.power.physicsBody.density = 0.0f;
    self.power.physicsBody.restitution =0;
    self.power.physicsBody.usesPreciseCollisionDetection = YES;
    self.power.physicsBody.categoryBitMask = powerHeroeCategory;
 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"powerHeroe" ofType:@"sks"];
    self.particulaBrilho = [NSKeyedUnarchiver unarchiveObjectWithFile: path];
    [self.power addChild:self.particulaBrilho];
    
    SKAction *acaoMover1 = [SKAction moveTo:CGPointMake(300, heroe.position.y + self.man.position.y) duration:1];
    SKAction *acaoRemover = [SKAction removeFromParent];
    [self.power runAction:[SKAction sequence:@[acaoMover1,acaoRemover]]];
    
    
    [self addChild:self.power];
    
    [monstroNivel1 removeFromParent];
    [monstroNivel2 removeFromParent];
    [monstroNivel3 removeFromParent];
    [monstroNivel4 removeFromParent];
    
}

-(void)movePower{
    
}


-(void)criaMonstroNivel1{
    monstroNivel1 = [[SKNode alloc]init];
    monstroNivel1.name = @"MonstroNivel1";
    monstroNivel1.position = CGPointMake(800,320);
}

-(void)criaMonstroNivel2{
    monstroNivel2 = [[SKNode alloc]init];
    monstroNivel2.name = @"MonstroNivel2";
    monstroNivel2.position = CGPointMake(800,420);

}

-(void)criaMonstroNivel3{
    monstroNivel3 = [[SKNode alloc]init];
    monstroNivel3.name = @"MonstroNivel3";
    monstroNivel3.position = CGPointMake(800,500);
}

-(void)criaMonstroNivel4{
    monstroNivel4 = [[SKNode alloc]init];
    monstroNivel4.name = @"MonstroNivel4";
    monstroNivel4.position = CGPointMake(800,600);
}

-(void)criaMorte {
   
    [self criaMonstroNivel1];
    
    self.morte = [[SKSpriteNode alloc]init];
    self.morte.name = @"Morte";
    [self.morte setSize:CGSizeMake(120,150)];
    self.morte.position = CGPointMake(0,0 );
    self.morte.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(70,140)];
    self.morte.physicsBody.dynamic = YES;
    self.morte.physicsBody.density = 0.1f;
    self.morte.physicsBody.restitution =0.0;
    self.morte.physicsBody.usesPreciseCollisionDetection = YES;
    self.morte.physicsBody.categoryBitMask = monstroNivel1Category;
    self.morte.physicsBody.contactTestBitMask = heroeCategory  | powerHeroeCategory | muroCategory;
    
    self.morteFrames = [self loadSpriteSheetFromImageWithName:@"monstroMorteWalk.png" withNumberOfSprites:11 withNumberOfRows:11 withNumberOfSpritesPerRow:1];
    SKAction *personagemAnimation = [SKAction animateWithTextures:self.morteFrames timePerFrame:0.2f];
    [self.morte runAction:[SKAction repeatActionForever:personagemAnimation]];
    
    SKAction *acaoMover = [SKAction moveTo:CGPointMake(-800, self.morte.position.y) duration:self.velocidadeMonstro];
    [self runAction:[SKAction playSoundFileNamed:@"morteSound.wav" waitForCompletion:NO]];
    SKAction *acaoRemover = [SKAction removeFromParent];
    [self.morte runAction:[SKAction sequence:@[acaoMover,acaoRemover]]];
    
    
    [monstroNivel1 addChild:self.morte];
    [self addChild:monstroNivel1];

}

-(void)criaDragao {
    
    [self criaMonstroNivel2];
    
    self.dragao = [[SKSpriteNode alloc]init];
    self.dragao.name = @"Dragao";
    [self.dragao setSize:CGSizeMake(100,180)];
    self.dragao.position = CGPointMake(0,0 );
    self.dragao.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50,130)];
    self.dragao.physicsBody.dynamic = YES;
    self.dragao.physicsBody.affectedByGravity =NO;
    self.dragao.physicsBody.allowsRotation =NO;
    self.dragao.physicsBody.density = 0.1f;
    self.dragao.physicsBody.restitution =0.2;
    self.dragao.physicsBody.usesPreciseCollisionDetection = YES;
    self.dragao.physicsBody.categoryBitMask = monstroNivel2Category;
    self.dragao.physicsBody.contactTestBitMask = heroeCategory  | powerHeroeCategory | muroCategory;
    self.dragao.physicsBody.velocity = CGVectorMake(0,0);
    
    self.dragaoFrames = [self loadSpriteSheetFromImageWithName:@"dragonRed.png" withNumberOfSprites:6 withNumberOfRows:1 withNumberOfSpritesPerRow:6];
    SKAction *personagemAnimation = [SKAction animateWithTextures:self.dragaoFrames timePerFrame:0.4f];
    [self.dragao runAction:[SKAction repeatActionForever:personagemAnimation]];
    
    SKAction *acaoMover = [SKAction moveTo:CGPointMake(-800, self.dragao.position.y) duration:self.velocidadeMonstro];
    SKAction *acaoRemover = [SKAction removeFromParent];
    [self runAction:[SKAction playSoundFileNamed:@"gokuSound.mp3" waitForCompletion:NO]];
    [self.dragao runAction:[SKAction sequence:@[acaoMover,acaoRemover]]];
    
    
    [monstroNivel2 addChild:self.dragao];
    [self addChild:monstroNivel2];
    
}

-(void)criaMaicon {
    
    [self criaMonstroNivel3];
    
    self.maicon = [[SKSpriteNode alloc]init];
    self.maicon.name = @"Maicon";
    [self.maicon setSize:CGSizeMake(100,130)];
    self.maicon.position = CGPointMake(0,0 );
    self.maicon.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30,120)];
    self.maicon.physicsBody.dynamic = YES;
    self.maicon.physicsBody.affectedByGravity =NO;
    self.maicon.physicsBody.allowsRotation =NO;
    self.maicon.physicsBody.density = 0.1f;
    self.maicon.physicsBody.restitution =0.0;
    self.maicon.physicsBody.usesPreciseCollisionDetection = YES;
    self.maicon.physicsBody.categoryBitMask = monstroNivel3Category;
    self.maicon.physicsBody.contactTestBitMask = heroeCategory  | powerHeroeCategory | muroCategory;
    self.maicon.physicsBody.velocity = CGVectorMake(0,0);
    
    self.maiconFrames = [self loadSpriteSheetFromImageWithName:@"spriteMaicon.png" withNumberOfSprites:6 withNumberOfRows:1 withNumberOfSpritesPerRow:6];
    SKAction *personagemAnimation = [SKAction animateWithTextures:self.maiconFrames timePerFrame:0.2f];
    [self.maicon runAction:[SKAction repeatActionForever:personagemAnimation]];
    
    SKAction *acaoMover = [SKAction moveTo:CGPointMake(-800, self.maicon.position.y) duration:self.velocidadeMonstro];
    [self runAction:[SKAction playSoundFileNamed:@"maiconSound.mp3" waitForCompletion:NO]];
    SKAction *acaoRemover = [SKAction removeFromParent];
    [self.maicon runAction:[SKAction sequence:@[acaoMover,acaoRemover]]];
    
    
    [monstroNivel3 addChild:self.maicon];
    [self addChild:monstroNivel3];
    
}

-(void)criaGargula {
    
    [self criaMonstroNivel4];
    
    self.gargula = [[SKSpriteNode alloc]init];
    self.gargula.name = @"Gargula";
    [self.gargula setSize:CGSizeMake(180,180)];
    self.gargula.position = CGPointMake(0,0 );
    self.gargula.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(120,160)];
    self.gargula.physicsBody.dynamic = YES;
    self.gargula.physicsBody.affectedByGravity =NO;
    self.gargula.physicsBody.allowsRotation =NO;
    self.gargula.physicsBody.density = 0.1f;
    self.gargula.physicsBody.restitution =0.2;
    self.gargula.physicsBody.usesPreciseCollisionDetection = YES;
    self.gargula.physicsBody.categoryBitMask = monstroNivel4Category;
    self.gargula.physicsBody.contactTestBitMask = heroeCategory  | powerHeroeCategory | muroCategory;
    self.gargula.physicsBody.velocity = CGVectorMake(0,0);
    
    self.gargulaFrames = [self loadSpriteSheetFromImageWithName:@"gargula.png" withNumberOfSprites:5 withNumberOfRows:1 withNumberOfSpritesPerRow:5];
    SKAction *personagemAnimation = [SKAction animateWithTextures:self.gargulaFrames timePerFrame:0.2f];
    [self.gargula runAction:[SKAction repeatActionForever:personagemAnimation]];
    
    SKAction *acaoMover = [SKAction moveTo:CGPointMake(-800, self.gargula.position.y) duration:self.velocidadeMonstro];
    [self runAction:[SKAction playSoundFileNamed:@"dragonSound.mp3" waitForCompletion:NO]];
    SKAction *acaoRemover = [SKAction removeFromParent];
    [self.gargula runAction:[SKAction sequence:@[acaoMover,acaoRemover]]];
    
    
    [monstroNivel4 addChild:self.gargula];
    [self addChild:monstroNivel4];
    
}

-(void)criaMuro{
    
    self.man.physicsBody.density = 0.18f;
    
    relevo = [[SKNode alloc]init];
    relevo.name = @"Relevo";
    relevo.position = CGPointMake(3000,400);
    
    self.muroPedra = [[SKSpriteNode alloc]init];
    self.muroPedra.name = @"ParedePedra";
    //SKTexture *texturaMuro = [SKTexture textureWithImageNamed:@"muroPedra.png"];
    SKColor *cor = [SKColor blackColor];
    self.muroPedra = [[SKSpriteNode alloc ]initWithColor:cor  size:CGSizeMake(3000,75)];
    self.muroPedra.position = CGPointMake(0,0 );
    self.muroPedra.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(2980,90)];
    self.muroPedra.physicsBody.dynamic = NO;
    self.muroPedra.physicsBody.affectedByGravity =NO;
    self.muroPedra.physicsBody.allowsRotation =NO;
    self.muroPedra.zPosition = 0.0;
    self.muroPedra.physicsBody.density = 0.1f;
    self.muroPedra.physicsBody.restitution =0.0;
    self.muroPedra.physicsBody.usesPreciseCollisionDetection = YES;
    self.muroPedra.physicsBody.categoryBitMask = muroCategory;
    self.muroPedra.physicsBody.contactTestBitMask = heroeCategory | monstroNivel1Category | monstroNivel2Category | monstroNivel3Category | monstroNivel4Category;

    
    SKAction *acaoMover = [SKAction moveTo:CGPointMake(-8000, self.muroPedra.position.y) duration:30];
    SKAction *acaoRemover = [SKAction removeFromParent];
    [self.muroPedra runAction:[SKAction sequence:@[acaoMover,acaoRemover]]];
    
    
    [relevo addChild:self.muroPedra];
    [self addChild:relevo];
    

}

-(void)moverNuvens{
    
    self.cloud = [SKSpriteNode spriteNodeWithImageNamed:@"nuvem.png"];
    self.cloud.size = CGSizeMake(800, 500);
    self.cloud.position = CGPointMake(1100, 730);
    [self addChild:self.cloud];
    
    SKAction *moveToLeftCloud = [SKAction moveTo:CGPointMake(-210, self.cloud.position.y) duration:8];
    SKAction *moveToRightCloud = [SKAction moveTo:CGPointMake(1100, 730) duration:0];
    
    SKAction *sequenceCloud = [SKAction sequence:@[moveToLeftCloud, moveToRightCloud]];
    [self.cloud runAction:[SKAction repeatActionForever:sequenceCloud]];
}


-(void)didSimulatePhysics{
  //NSLog(@"v = %f",self.man.position.y);
}

-(void)heroRun{
    
    self.humanoFrames = [self loadSpriteSheetFromImageWithName:@"heroRun.png" withNumberOfSprites:6 withNumberOfRows:1 withNumberOfSpritesPerRow:6];
    SKAction *personagemAnimation = [SKAction animateWithTextures:self.humanoFrames timePerFrame:0.10f];
    [self.man runAction:[SKAction repeatActionForever:personagemAnimation]];
}

-(void)heroFly{
    self.humanoFrames = [self loadSpriteSheetFromImageWithName:@"birdWhite.png" withNumberOfSprites:5 withNumberOfRows:1 withNumberOfSpritesPerRow:5];
    SKAction *personagemAnimation = [SKAction animateWithTextures:self.humanoFrames timePerFrame:0.10f];
    [self.man runAction:[SKAction repeatActionForever:personagemAnimation]];
}

-(void)heroJump{
    self.humanoJumpFrames = [self loadSpriteSheetFromImageWithName:@"heroJump.png" withNumberOfSprites:5 withNumberOfRows:1 withNumberOfSpritesPerRow:5];
    SKAction *personagemAnimation = [SKAction animateWithTextures:self.humanoJumpFrames timePerFrame:0.18f];
    [self.man runAction:[SKAction repeatAction:personagemAnimation count:1]];

}

-(void)heroDown{
      self.man.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(70,20)];
    self.man.position = CGPointMake(0, 0);
     [self.man setSize:CGSizeMake(100,80)];
    self.humanoDownFrames = [self loadSpriteSheetFromImageWithName:@"heroDown" withNumberOfSprites:6 withNumberOfRows:1 withNumberOfSpritesPerRow:6];
    SKAction *personagemAnimation = [SKAction animateWithTextures:self.humanoDownFrames timePerFrame:0.20f];
    [self.man runAction:[SKAction repeatAction:personagemAnimation count:1]];
    
}
-(void)heroDownNivel2{
    self.man.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(70,70)];
    self.man.position = CGPointMake(0, 200);
    [self.man setSize:CGSizeMake(100,80)];
    self.humanoDownFrames = [self loadSpriteSheetFromImageWithName:@"heroDown" withNumberOfSprites:6 withNumberOfRows:1 withNumberOfSpritesPerRow:6];
    SKAction *personagemAnimation = [SKAction animateWithTextures:self.humanoDownFrames timePerFrame:0.20f];
    [self.man runAction:[SKAction repeatAction:personagemAnimation count:1]];
}

- (SKSpriteNode *)botaoDown{
    buttonDownNode = [SKSpriteNode spriteNodeWithImageNamed:@"buttonDown.png"];
    buttonDownNode.position = CGPointMake(80,300);
    buttonDownNode.size = CGSizeMake(90,90);
    buttonDownNode.name = @"down";//how the node is identified later
    buttonDownNode.zPosition = +5.0;
    return buttonDownNode;
}

-(SKSpriteNode *)botaoUp{
    buttonUpNode = [SKSpriteNode spriteNodeWithImageNamed:@"buttonUp.png"];
    buttonUpNode.position = CGPointMake(700,300);
    buttonUpNode.size = CGSizeMake(90,90);
    buttonUpNode.name = @"up";//how the node is identified later
    buttonUpNode.zPosition = +5.0;
    return buttonUpNode;
}

- (SKSpriteNode *)botaoPause {
    buttonPauseNode = [SKSpriteNode spriteNodeWithImageNamed:@"pause.png"];
    buttonPauseNode.position = CGPointMake(730,380);
    buttonPauseNode.size = CGSizeMake(30,30);
    buttonPauseNode.name = @"pause";//how the node is identified later
    buttonPauseNode.zPosition = +5.0;
    return buttonPauseNode;
}

- (SKSpriteNode *)botaoRetorna {
    buttonRetornaNode = [SKSpriteNode spriteNodeWithImageNamed:@"play.png"];
    buttonRetornaNode.position = CGPointMake(730,380);
    buttonRetornaNode.size = CGSizeMake(30,30);
    buttonRetornaNode.name = @"retorna";//how the node is identified later
    buttonRetornaNode.zPosition = +2.0;
    buttonRetornaNode.hidden = YES;
    return buttonRetornaNode;
}

- (SKSpriteNode *)botaoRecomecaJogo{
    buttonComecaJogoNode = [SKSpriteNode spriteNodeWithImageNamed:@"buttonJogarNovamente.png"];
    buttonComecaJogoNode.position = CGPointMake(400,600);
    buttonComecaJogoNode.size = CGSizeMake(120,40);
    buttonComecaJogoNode.name = @"JogarNovamente";//how the node is identified later
    buttonComecaJogoNode.zPosition = +2.0;
    buttonComecaJogoNode.hidden = YES;
    return buttonComecaJogoNode;
}

-(SKSpriteNode *)botaoVoltarMenu{
    buttonRetornaMenuNode = [SKSpriteNode spriteNodeWithImageNamed:@"botaoVoltarMenu.png"];
    buttonRetornaMenuNode.position = CGPointMake(400,500);
    buttonRetornaMenuNode.size = CGSizeMake(120,40);
    buttonRetornaMenuNode.name = @"VoltarMenu";//how the node is identified later
    buttonRetornaMenuNode.zPosition = +8.0;
    buttonRetornaMenuNode.hidden = YES;
    return buttonRetornaMenuNode;
}

- (SKSpriteNode *)botaoRunPower{
    buttonRunPower = [SKSpriteNode spriteNodeWithImageNamed:@"buttonMagic.png"];
    buttonRunPower.position = CGPointMake(50,380);
    buttonRunPower.size = CGSizeMake(50,50);
    buttonRunPower.name = @"powerHeroe";//how the node is identified later
    buttonRunPower.zPosition = +5.0;
    return buttonRunPower;
}

- (SKSpriteNode *)botaoFlyHeroe{
    buttonMagic = [SKSpriteNode spriteNodeWithImageNamed:@"buttonFly.png"];
    buttonMagic.position = CGPointMake(115,380);
    buttonMagic.size = CGSizeMake(50,50);
    buttonMagic.name = @"flyHeroe";//how the node is identified later
    buttonMagic.zPosition = +5.0;
    return buttonMagic;
}

- (SKSpriteNode *)botaoHomenRetorna{
    buttonReturMan = [SKSpriteNode spriteNodeWithImageNamed:@"buttonMen.png"];
    buttonReturMan.position = CGPointMake(160,330);
    buttonReturMan.size = CGSizeMake(50,50);
    buttonReturMan.name = @"retornaHomen";//how the node is identified later
    buttonReturMan.zPosition = +5.0;
    return buttonReturMan;
}

-(void)tamanhoVoltaNormalHeroi{
    self.man.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.man.size.width/2];
    self.man.physicsBody.dynamic = YES;
    self.man.physicsBody.affectedByGravity =YES;
    self.man.physicsBody.allowsRotation =NO;
    self.man.physicsBody.density = 0.2f;
    self.man.physicsBody.restitution =0;
    self.man.physicsBody.categoryBitMask = heroeCategory;
    self.man.physicsBody.contactTestBitMask = monstroNivel1Category | pisoCategory ;
    [self.man setSize:CGSizeMake(100,150)];
}

-(void)hardJump{
    self.man.physicsBody.density = 0.2f;
}

-(void)pauseCena{
    self.estadoPauseJogo = 1;
    buttonRetornaNode.zPosition = +7.0;
    buttonPauseNode.zPosition = +5.0;
    monstroNivel1.paused =YES;
    monstroNivel2.paused =YES;
    monstroNivel3.paused =YES;
    monstroNivel4.paused =YES;
    self.muroPedra.paused = YES;
    buraco.paused = YES;
    buttonDownNode.hidden = YES;
    buttonRunPower.hidden = YES;
    buttonUpNode.hidden = YES;
    buttonMagic.hidden=YES;
    buttonReturMan.hidden = YES;
    
}

-(void)retornaCena{
    self.estadoPauseJogo = 0;
    buttonRetornaNode.zPosition = +5.0;
    buttonPauseNode.zPosition = +7.0;
    monstroNivel1.paused =NO;
    monstroNivel2.paused =NO;
    monstroNivel3.paused =NO;
    monstroNivel4.paused =NO;
    self.muroPedra.paused = NO;
    buraco.paused = NO;
    buttonDownNode.hidden = NO;
    buttonRunPower.hidden = NO;
    buttonUpNode.hidden = NO;
    buttonMagic.hidden=NO;
    buttonReturMan.hidden=NO;
}

-(void)TiraEfeitoPoder{
    self.view.backgroundColor = [UIColor clearColor]; //or whatever...
    self.view.alpha = 1.0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    
    if ([node.name isEqualToString:@"up"]) {
        if(self.man.position.y < self.auxPosMuroPisoHeroi ){
            [self.man.physicsBody applyImpulse:CGVectorMake(0,50)];
            [self heroJump];
        }
    }
    
    if ([node.name isEqualToString:@"retornaHomen"]) {
        self.verfificaBotaoFly = false;
        //buttonMagic.hidden = YES;
        buttonDownNode.hidden = NO;
        buttonUpNode.hidden = NO;
        buttonRunPower.hidden =NO;
        [self heroRun];
        self.man.physicsBody.density = 0.2f;
        [self.man.physicsBody applyForce:CGVectorMake(0, 50)];
        
    }
    
    if ([node.name isEqualToString:@"pause"]) {
        buttonRetornaNode.hidden = NO;
        buttonRetornaMenuNode.hidden = NO;
        buttonComecaJogoNode.hidden =NO;
        buttonPauseNode.hidden = YES;
        [self pauseCena];
    
    }
    
    if ([node.name isEqualToString:@"retorna"]) {
        buttonRetornaNode.hidden = YES;
        buttonPauseNode.hidden = NO;
        buttonRetornaMenuNode.hidden = YES;
        buttonComecaJogoNode.hidden =YES;
        [self retornaCena];
    
    }
    
    if ([node.name isEqualToString:@"JogarNovamente"]) {
        MyScene *inicioJogo = [[MyScene alloc]initWithSize:CGSizeMake(768, 1024)];
        inicioJogo.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *animate = [SKTransition fadeWithDuration:1.0f];
        [self.view presentScene:inicioJogo transition:animate];
    }
    
    if ([node.name isEqualToString:@"VoltarMenu"]) {
        MenuPrincipal *voltaMenu = [[MenuPrincipal alloc]initWithSize:CGSizeMake(768, 1024)];
        voltaMenu.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *animate = [SKTransition fadeWithDuration:1.0f];
        [self.view presentScene:voltaMenu transition:animate];
    }
    
    
    if ([node.name isEqualToString:@"down"]) {
        if(self.nivelMosntro == false){
            [self heroDown];
            [NSTimer scheduledTimerWithTimeInterval:1.40 target:self selector:@selector(tamanhoVoltaNormalHeroi) userInfo:nil repeats:NO];
        }else{
            [self heroDownNivel2];
            [NSTimer scheduledTimerWithTimeInterval:1.40 target:self selector:@selector(tamanhoVoltaNormalHeroi) userInfo:nil repeats:NO];
        }
    }
    
    if ([node.name isEqualToString:@"powerHeroe"]) {
        if(self.qtdPower >0 ){
            self.qtdPower = self.qtdPower - 1;
            [self criaPoderHeroi];
            
            
            self.view.backgroundColor = [UIColor whiteColor];
            self.view.alpha = 0.3;
    
            
            [NSTimer scheduledTimerWithTimeInterval:.50 target:self selector:@selector(TiraEfeitoPoder) userInfo:nil repeats:NO];
            
        
            
        }
    }
    
    if ([node.name isEqualToString:@"flyHeroe"]) {
        
        if(self.tempoPassaroBonus >1){
            self.verfificaBotaoFly = true;
            buttonMagic.hidden = NO;
            buttonDownNode.hidden = YES;
            buttonUpNode.hidden = YES;
            [self heroFly];
            self.man.physicsBody.density = 0.3f;
            self.man.physicsBody.velocity = CGVectorMake(0, 0);
            [self.man.physicsBody applyForce:CGVectorMake(0, 3000)];
        }
        
    }

}

-(void)nada{
    [monstroNivel1 removeFromParent];
}

-(void)tiraMuroMonstroNivel1e2{
    [monstroNivel1 removeFromParent];
    [monstroNivel2 removeFromParent];
}

-(void)chamaRecorde {
    self.scene.view.paused = YES;
}

-(void)update:(CFTimeInterval)currentTime {
    //Condicao para calcular distancia percorrida
    if(self.estadoPauseJogo == 0 ){
        
        if(self.tempoPassaroBonus == 0){
            self.verfificaBotaoFly = false;
            buttonDownNode.hidden = NO;
            buttonUpNode.hidden = NO;
            buttonMagic.hidden = YES;
            [self heroRun];
            self.man.physicsBody.density = 0.2f;
            [self.man.physicsBody applyForce:CGVectorMake(0, 50)];
            self.tempoPassaroBonus +=1;
        }
        
        if(self.verfificaBotaoFly == true){
            if (self.tempoPassaraoAux % 40 == 0) {
                if(self.tempoPassaroBonus >0){
                    self.tempoPassaroBonus -=1;
                    self.tempoPassaraoAux = 0;
                }
            }
        }
        
        if(self.tempoPassaroBonus >= 10){
            buttonMagic.hidden = NO;
        }
        
        
        self.AuxdistanciaPercorrida += 1;
        self.tempoPassaraoAux +=1;
    
        
        if(self.AuxdistanciaPercorrida > 40){
            self.distanciaPercorrida +=1;
            self.AuxdistanciaPercorrida = 0;
            self.textoDistancia.text = [NSString stringWithFormat:@"%d", self.distanciaPercorrida];
            self.tempoFly.text = [NSString stringWithFormat:@"%d", self.tempoPassaroBonus];
             self.numMagia.text = [NSString stringWithFormat:@"%d", self.qtdPower];
            
            
            //Controla a velocidade dos monstros
            if(self.distanciaPercorrida % 30 == 0){
                if(self.velocidadeMonstro > 1){
                    self.velocidadeMonstro -= 0.10;
                }
            }
            
            
            if(self.distanciaPercorrida % 30 == 0){
                self.qtdPower = self.qtdPower + 1;

            }
            
            //Serve para poder fazer um muro, e segurar o pulo maior por 3 segundos
            if(self.distanciaPercorrida %50 == 0){
                self.nivelMosntro = true;
                [self criaMuro];
                [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(tiraMuroMonstroNivel1e2) userInfo:nil repeats:NO];
                
            }
            
            if(self.distanciaPercorrida %13 == 0){
                [self criaBuraco];
                
            }
            
            if(self.distanciaPercorrida %35 == 0){
                self.tempoPassaroBonus += 10;
            }
          
            
            if(self.verificaBateRecorde != true){
                [self configurarRanking];
                //Aparece Toasty
                if (self.pontuacaoJogadorAtual > self.pontuacaoJogadorNoRanking){
                    [self apareceToasty];
                    self.verificaBateRecorde = true;
                }
            }
            
            
            if(self.distanciaPercorrida % 7 == 0){
                self.sorteaMonstro = arc4random()%2;
                
                if(self.nivelMosntro == false) {
                    switch (self.sorteaMonstro) {
                        case 0:
                            [self criaMorte];
                            break;
                            
                        case 1:
                            [self criaDragao];
                            break;
                    }
                }else{
                    switch (self.sorteaMonstro) {
                        case 0:
                            [self criaMaicon];
                            break;
                            
                        case 1:
                            [self criaGargula];
                            break;
                    }
                }
            }
            
            
            
            

        }

        
        
    }
    
}



-(void)gameOver{
    [self configurarRanking];
    GameOver *over = [[GameOver alloc]initWithSize:CGSizeMake(384,512)];
    SKTransition *animate = [SKTransition fadeWithDuration:1.0f];
    [self.view presentScene:over transition:animate];
}

-(void)apareceToasty {
    SKAction *moveToLeftFloor = [SKAction moveTo:CGPointMake(670, self.toasty.position.y) duration:1.5];
    SKAction *moveToRightFloor = [SKAction moveTo:CGPointMake(900, self.toasty.position.y) duration:1.5];
    SKAction *sequenceFloor = [SKAction sequence:@[moveToLeftFloor, moveToRightFloor]];
    [self runAction:[SKAction playSoundFileNamed:@"toasty.mp3" waitForCompletion:NO]];
    [self.toasty runAction:sequenceFloor];
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    
//    if ((firstBody.categoryBitMask & powerHeroeCategory) !=7) {
//        if((secondBody.categoryBitMask & monstroNivel1Category) !=7){
//            NSLog(@"morete");
//            [monstroNivel1 removeFromParent];
//        }else if((secondBody.categoryBitMask & monstroNivel2Category) !=7) {
//            NSLog(@"goku");
//            [monstroNivel2 removeFromParent];
//        }else if((secondBody.categoryBitMask & monstroNivel3Category) !=7) {
//            [monstroNivel3 removeFromParent];
//        }else if((secondBody.categoryBitMask & monstroNivel4Category) !=7) {
//            [monstroNivel4 removeFromParent];
//        }
//    }
    
//    if ((firstBody.categoryBitMask & monstroNivel1Category) !=1) {
//        if((secondBody.categoryBitMask & powerHeroeCategory) !=1){
//            NSLog(@"morete");
//            [monstroNivel1 removeFromParent];
//        }
//    }

    
   
    
    if ((firstBody.categoryBitMask & heroeCategory) !=0) {
        if((secondBody.categoryBitMask & monstroNivel1Category) !=0){
            
            if(self.man.position.y >  self.morte.position.y + 110 ){
                //MataMonstro
                self.morteFrames = [self loadSpriteSheetFromImageWithName:@"morteExplode.png" withNumberOfSprites:3 withNumberOfRows:1 withNumberOfSpritesPerRow:3];
                SKAction *personagemAnimation = [SKAction animateWithTextures:self.morteFrames timePerFrame:0.2f];
                [self.morte runAction:[SKAction repeatAction:personagemAnimation count:1]];
                [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(nada) userInfo:nil repeats:NO];
                
            }else{
                //GameOver
                [[self man] removeFromParent];
                [self gameOver];
            }

        }else if((secondBody.categoryBitMask & pisoCategory)!=0){
            self.nivelMosntro = false;
            self.auxPosMuroPisoHeroi = 31;
            
        }else if((secondBody.categoryBitMask & buracoCategory)!=0){
            self.man.zPosition = +20;
            self.physicsWorld.gravity = CGVectorMake(0,-20 );
            piso.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0,0)];
            buraco.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0,0)];
            self.man.physicsBody.density = 5.0f;
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gameOver) userInfo:nil repeats:NO];
            
            
        } else if((secondBody.categoryBitMask & monstroNivel2Category)!=0){
            [[self man] removeFromParent];
            [self gameOver];
            
        }else if((secondBody.categoryBitMask & muroCategory)!=0){
            int aux = relevo.position.y;
            
            if(heroe.position.x == self.muroPedra.position.x - 50){
                [monstroNivel1 removeFromParent];
                [monstroNivel2 removeFromParent];
                self.nivelMosntro = true;
            }
            
            if(self.man.position.y < aux - 228){
                [[self man] removeFromParent];
                [self gameOver];
            }else{
                self.nivelMosntro = true;
                self.auxPosMuroPisoHeroi = 246.0;
            }
             aux = 1000;
            
        }else if((secondBody.categoryBitMask & monstroNivel4Category)!=0){
            [self gameOver];
            
        }else if((secondBody.categoryBitMask & monstroNivel3Category)!=0) {
            if(self.man.position.y > monstroNivel3.position.y - 230 ){
                //MataMonstro
                [monstroNivel3 removeFromParent];
                
            }else{
                //GameOver
                [[self man] removeFromParent];
                [self gameOver];
            }
            
        }
        
    }
    
   
    
}


-(NSMutableArray*)loadSpriteSheetFromImageWithName:(NSString*)name withNumberOfSprites:(int)numSprites withNumberOfRows:(int)numRows withNumberOfSpritesPerRow:(int)numSpritesPerRow {
    NSMutableArray* animationSheet = [NSMutableArray array];
    
    SKTexture* mainTexture = [SKTexture textureWithImageNamed:name];
    
    for(int j = numRows-1; j >= 0; j--) {
        for(int i = 0; i < numSpritesPerRow; i++) {
            
            SKTexture* part = [SKTexture textureWithRect:CGRectMake(i*(1.0f/numSpritesPerRow), j*(1.0f/numRows), 1.0f/numSpritesPerRow, 1.0f/numRows) inTexture:mainTexture];
            
            [animationSheet addObject:part];
            
            if(animationSheet.count == numSprites)
                break;
        }
        
        if(animationSheet.count == numSprites)
            break;
        
    }
    return animationSheet;
}


@end
