//
//  MyScene.h
//  RunDark
//

//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

static const UInt32 heroeCategory = 0x1 << 0;
static const UInt32 pisoCategory = 0x1 << 2;
static const UInt32 monstroNivel1Category = 0x1 << 1;
static const UInt32 monstroNivel2Category = 0x1 << 4;
static const UInt32 muroCategory = 0x1 << 3;
static const UInt32 monstroNivel3Category = 0x1 << 5;
static const UInt32 monstroNivel4Category = 0x1 << 6;
static const UInt32 powerHeroeCategory = 0x1 << 7;
static const UInt32 maoHeroeCategory = 0x1 << 8;
static const UInt32 buracoCategory = 0x1 << 9;

@interface MyScene : SKScene <SKPhysicsContactDelegate>{
    
    SKNode *fundo;
    SKNode *piso;
    SKNode *heroe;
    SKNode *monstroNivel1;
    SKNode *monstroNivel2;
    SKNode *monstroNivel3;
    SKNode *monstroNivel4;
    SKNode *relevo;
    SKSpriteNode *buttonPauseNode;
    SKSpriteNode *buttonUpNode;
    SKSpriteNode *buttonDownNode;
    SKSpriteNode *buttonRetornaNode;
    SKSpriteNode *buttonRetornaMenuNode;
    SKSpriteNode *buttonComecaJogoNode;
    SKSpriteNode *buttonRunPower;
    SKSpriteNode *buttonReturMan;
    SKSpriteNode *buttonMagic;
    SKSpriteNode *buraco;
    AVAudioPlayer *queuePlayer;
    double canoTimer;
    
}

@property int pontuacao;
@property int AuxdistanciaPercorrida;
@property int distanciaPercorrida;
@property int estadoPauseJogo;
@property NSInteger sorteaMonstro;
@property int velocidadeMonstro;
@property int auxPosMuroPisoHeroi;
@property BOOL nivelMosntro; // false = baixo | true = cima
@property BOOL verificaBateRecorde;
@property BOOL verfificaBotaoFly;
@property int qtdPower;
@property int tempoPassaroBonus;
@property int tempoPassaroDecrementa;
@property int tempoPassaraoAux;
@property int pontuacaoJogadorAtual, pontuacaoJogadorNoRanking;
@property SKLabelNode *ranking;

@property NSArray *humanoFrames;
@property NSArray *humanoJumpFrames;
@property NSArray *humanoDownFrames;

@property NSArray *morteFrames;
@property NSArray *morteFinaliseFrames;

@property NSArray *dragaoFrames;

@property NSArray *gargulaFrames;
@property NSArray *maiconFrames;



-(void)criaFundo;
-(void)criaMorte;
-(void)criaPiso;
-(void)criaPersonagem;
-(void)criaDragao;
-(void)criaGargula;
-(void)criaMuro;
-(void)gameOver;
-(void)apareceToasty;
-(void)instanciaClassesUnicas;
-(void)criaMaicon;
-(void)criaMonstroNivel1;
-(void)criaMonstroNivel2;
-(void)criaMonstroNivel3;
-(void)criaMonstroNivel4;
-(void)chamaRecorde;
-(void)criaPoderHeroi;

-(void)moverNuvens;

-(void)heroJump;
-(void)heroDown;
-(void)heroRun;
-(void)tamanhoVoltaNormalHeroi;
-(void)heroDownNivel2;
-(void)criaMao;
-(void)movePower;


- (SKSpriteNode *)botaoDown;
- (SKSpriteNode *)botaoUp;
- (SKSpriteNode *)botaoPause;
- (SKSpriteNode *)botaoRetorna;
- (SKSpriteNode *)botaoRecomecaJogo;
- (SKSpriteNode *)botaoVoltarMenu;
- (SKSpriteNode *)botaoRunPower;
- (SKSpriteNode *)botaoHomenRetorna;


@property  SKSpriteNode *fundoNoiteLua;
@property SKSpriteNode *pisoCeramica;
@property SKSpriteNode *man;
@property SKSpriteNode *morte;
@property SKSpriteNode *cloud;
@property SKSpriteNode *dragao;
@property SKSpriteNode *muroPedra;
@property SKSpriteNode *toasty;
@property SKSpriteNode *gargula;
@property SKSpriteNode *maicon;
@property SKSpriteNode *mao;
@property SKSpriteNode *power;



@property SKEmitterNode *particulaBrilho;
@property SKEmitterNode *particulaSmooke;

@property SKLabelNode *textoDistancia;
@property SKLabelNode *tempoFly;
@property SKLabelNode *numMagia;

@property (nonatomic) NSTimeInterval lastUpdateTimeInteval;




-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast;
-(NSMutableArray*)loadSpriteSheetFromImageWithName:(NSString*)name withNumberOfSprites:(int)numSprites withNumberOfRows:(int)numRows withNumberOfSpritesPerRow:(int)numSpritesPerRow;




@end
