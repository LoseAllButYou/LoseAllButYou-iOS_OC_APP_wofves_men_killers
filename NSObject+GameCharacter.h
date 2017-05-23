//
//  NSObject+GameCharacter.h
//  wolfmen_killers
//
//  Created by wrongmean on 2017/4/29.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <Foundation/Foundation.h>

//划分阵营
typedef NS_ENUM(int,part)  {
    wolf=1<<4,
    neutrality=1,
    civilian=1<<1,
     deity=1<<2,
    third=1<<3
};

//游戏状态
typedef NS_ENUM(int,State)  {
    //死亡方式
    DEAD_NOT_DEFINE=0,
    DEAD_BY_WITCH=1,
    DEAD_BY_HUNTER=1<<1,
    DEAD_BY_WERWOLF_KING=1<<2,
    OUT_BY_CIVILIAN=1<<3,
    DEAD_BY_WERWOLF=1<<4,
    DEAD_BY_BOOM=1<<5,
    DEAD_FOR_LOVE=1<<6,
    //存活状态
    SURVIVE=1<<7,
    Idol=1<<8,//偶像
    lovers=1<<9,//情侣
    beDefend=1<<10,//被守护
    beBannedToPost=1<<11,//被禁言
    
};

//枚举技能类型
typedef NS_ENUM(int, Skill)  {
    none=0,//无技能
    vote=1,//投票
    bane=1<<1,// 毒药
    antidote=1<<2,//解药
    shoot=1<<3,//开枪
    destruction=1<<4,//自爆
    cantOut=1<<5,//不能出局
    assignLovers=1<<6,//制定恋人
    choiceCharacter=1<<7,//选择身份
    verify=1<<8,//验人
    defend=1<<9,//守护
    killHumen=1<<10,
    discussWar=1<<11,//商量战术
    peep=1<<12,//偷看
    choiceIdol=1<<13,//选择偶像
    bannedToPost=1<<14,//禁言
    exchangeCard=1<<15,//换牌
    roar=1<<16,//咆哮
    challenge=1<<17,
    choiceNextVoter=1<<18,//选择投票者
    doubleHP=1<<19,//双命
};

@interface GameCharacter:NSObject<NSCopying,NSMutableCopying>
@property (nonatomic,strong)NSString* character;
@property (nonatomic,strong)NSNumber* gamePriority;
@property (nonatomic,strong)NSString* imgName;
@property (nonatomic,strong)NSString* userName;
@property (atomic,strong)NSNumber* userNum;
@property (nonatomic,strong)NSNumber* gameState;//游戏状态
@property (nonatomic,strong)NSNumber* Skill;//游戏技能
@property (nonatomic,strong)NSNumber* gameIdentity;//游戏身份id

@property (nonatomic,strong)NSMutableArray* skillOb;//游戏技能目标 多个
@property (nonatomic,strong)NSNumber* part;//游戏阵营
-(void)alloc;
-(void)autoSet;
//-(id)copyWithZone:(NSZone *)zone;
@end

