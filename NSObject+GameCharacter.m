//
//  NSObject+GameCharacter.m
//  wolfmen_killers
//
//  Created by wrongmean on 2017/4/29.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "NSObject+GameCharacter.h"

@implementation GameCharacter:NSObject
-(void)alloc
{
    _gameIdentity=[NSNumber numberWithInt:0];
    _character=@"";
    _gamePriority=[NSNumber numberWithInt:0];
    _imgName=@"";
    _userName=@"";
    _userNum=[NSNumber numberWithInt:100];
    _gameState=[NSNumber numberWithInt:SURVIVE];
    _Skill=[NSNumber numberWithInt:vote];
    _skillOb=[NSMutableArray arrayWithCapacity:1];
    _part=[NSNumber numberWithInt:deity];//-1 狼 1中立 2平民 4神 8第三方
}

-(void)autoSet
{
    switch ([_gameIdentity intValue]) {
        case 0:
            _Skill=[NSNumber numberWithInt:killHumen|destruction];
             _part=[NSNumber numberWithInt:wolf];
            break;
        case 1:
            _Skill=[NSNumber numberWithInt:bane|antidote|vote];
            break;
        case  2:
            _Skill=[NSNumber numberWithInt:vote];
            _part=[NSNumber numberWithInt:neutrality];
            break;
        case  3:
            _Skill=[NSNumber numberWithInt:verify|vote];
            break;
        case  4:
            _Skill=[NSNumber numberWithInt:defend|vote];
            break;
        case  5:
            _Skill=[NSNumber numberWithInt: exchangeCard|vote];
            break;
        case  6:
            _Skill=[NSNumber numberWithInt:assignLovers|vote];
            break;
        case  7:
            _Skill=[NSNumber numberWithInt: peep|vote];
            break;
        case  8:
            _Skill=[NSNumber numberWithInt: roar|vote];
            break;
        case  9:_Skill=[NSNumber numberWithInt:vote];
            _part=[NSNumber numberWithInt:wolf];
            break;
        case  10:
            _Skill=[NSNumber numberWithInt:vote];
            _part=[NSNumber numberWithInt:civilian];
            break;
        case  11:
            _Skill=[NSNumber numberWithInt:vote];
            _part=[NSNumber numberWithInt:civilian];
            break;
        case  12:
            _Skill=[NSNumber numberWithInt:vote];
            break;
        case  13:
            _Skill=[NSNumber numberWithInt:verify|vote];
            break;
        case  14:
            _Skill=[NSNumber numberWithInt:shoot|vote];
            break;
        case  15:
            _Skill=[NSNumber numberWithInt:cantOut|vote];
            break;
        case  16:
            _Skill=[NSNumber numberWithInt:challenge|vote];
            break;
        case  17:
            _Skill=[NSNumber numberWithInt:vote];
            break;
        case  18:
            _Skill=[NSNumber numberWithInt:vote];
            break;
        case  19:
            _Skill=[NSNumber numberWithInt:choiceNextVoter|vote];
            
            _part=[NSNumber numberWithInt:neutrality];
            break;
        case  20:
            _Skill=[NSNumber numberWithInt:doubleHP|vote];
            break;
        case   21:
            _Skill=[NSNumber numberWithInt:bannedToPost|vote];
            break;
        case   22:
            _Skill=[NSNumber numberWithInt:destruction|killHumen];
             _part=[NSNumber numberWithInt:wolf];
            break;
        case   23:
            _Skill=[NSNumber numberWithInt:choiceIdol];
            _part=[NSNumber numberWithInt:civilian];
            break;
        default:
            break;
    }
}
-(GameCharacter*)copy :(GameCharacter*)tmp
{
    _gameIdentity=[[tmp gameIdentity] mutableCopy];
    _character=[[tmp character] mutableCopy];
    _gamePriority=[[tmp gamePriority] mutableCopy];
    _imgName=[[tmp imgName] mutableCopy];
    _userName=[[tmp userName] mutableCopy];
    _userNum=[[tmp userNum] mutableCopy];
    _gameState=[[tmp gameState] mutableCopy];
    _Skill=[[tmp Skill] mutableCopy];
    _skillOb=[[tmp skillOb] mutableCopy];
    _part=[[tmp part] mutableCopy];
    return self;
}
-(id)copyWithZone:(NSZone *)zone
{
    GameCharacter* tmp=[GameCharacter allocWithZone:zone]; _gameIdentity=[[tmp gameIdentity] mutableCopy];
    _character=[[tmp character] mutableCopy];
    _gamePriority=[[tmp gamePriority] mutableCopy];
    _imgName=[[tmp imgName] mutableCopy];
    _userName=[[tmp userName] mutableCopy];
    _userNum=[[tmp userNum] mutableCopy];
    _gameState=[[tmp gameState] mutableCopy];
    _Skill=[[tmp Skill] mutableCopy];
    _skillOb=[[tmp skillOb] mutableCopy];
    _part=[[tmp part] mutableCopy];
    return self;
}
@end
