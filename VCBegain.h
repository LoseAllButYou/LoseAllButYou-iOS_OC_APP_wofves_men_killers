//
//  VCBegain.h
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//
#import "NSObject+GameCharacter.h"
#import <UIKit/UIKit.h>
#import "VBeginCell.h"
#import "NSObject+DBPart.h"
#import "VRShowAct.h"

#import <math.h>
#import "VCRobberSelect.h"
@class VCBegain;
@interface VCBegain : UIViewController
{
    int deityNum;
    int civilianNum;
    int werwolfNum;
    int wolfPartNum;
    int thirdPartNum;//第三方人数
    int neutralityPart;//中立人数
    int winPart;//获胜阵营
    int curActUserNum;
    int beActedUserNum;
    int curDeadNum;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *Title_Info;
@property (weak, nonatomic) IBOutlet UICollectionView *Coll_ShowUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Btn_changDayNight;
@property (strong, nonatomic)NSNumber* isHaveBobber;//是否有盗贼
@property (strong, nonatomic)NSNumber* isHaveCupid;//是否有丘比特
@property (strong, nonatomic)NSNumber* isSelectSheriff;//是否选择警长
@property (strong, nonatomic)NSNumber* robberSelect;//盗贼选择
@property (strong, nonatomic) NSMutableArray* characterArr;
@property(strong,nonatomic)GameCharacter* character1;

@property(strong,nonatomic)GameCharacter* character2;
@property(strong,nonatomic)NSNumber* robberNum;//盗贼 身份玩家号码
@property(strong,nonatomic)NSNumber* witchHaveBane;//盗贼 身份玩家号码
@property (weak, nonatomic) IBOutlet UIImageView *CollImg_back;
@property (strong ,nonatomic) NSMutableArray* actOrder;
@property (strong, nonatomic) NSMutableArray* cellArr;
//ios自带 array 排序工具 1.array 2.排序字段 3.升序或者降序
-(void) sortArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo;
-(void)outputActOnView :(NSString*)str :(int)type;
-(void)gameAction:(int)index;
-(void)changeCardState:(int)index;
@end
