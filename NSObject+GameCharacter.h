//
//  NSObject+GameCharacter.h
//  wolfmen_killers
//
//  Created by wrongmean on 2017/4/29.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <Foundation/Foundation.h>

//游戏状态
typedef NS_ENUM(int,State)  {
    //死亡方式
    DEAD_BY_WERWOLF=0,
    DEAD_BY_WITCH=1,
    DEAD_BY_HUNTER=2,
    DEAD_BY_WERWOLF_KING=3,
    OUT_BY_CIVILIAN=4,
    DEAD_NOT_DEFINE=5,
    DEAD_BY_BOOM=-1,
    DEAD_FOR_LOVE=-2,
    //存活状态
    SURVIVE=6,
    Idol,//偶像
    lovers,//情侣
    
    beBannedToPost,//被禁言
    
};

//枚举技能类型
typedef NS_ENUM(int, Skill)  {
    none=0,//无技能
    vote,//投票
    bane=2,// 毒药
    antidote,//解药
    shoot,//开枪
    destruction,//自爆
    cantOut,//不能出局
    assignLovers,//制定恋人
    choiceCharacter,//选择身份
    verify,//验人
    defend,//守护
    killHumen,
    discussWar,//商量战术
    peep,//偷看
    choiceIdol,//选择偶像
    bannedToPost,//禁言
    exchangeCard,//换牌
    roar,//咆哮
    challenge,
    choiceNextVoter,//选择投票者
    doubleHP,//双命
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

