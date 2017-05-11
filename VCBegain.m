//
//  VCBegain.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCBegain.h"
#import "VCPlayerSelect.h"
#import "VCCharacterInfo.h"
#import "VCMain.h"
#import "MBProgressHUD+MJ.h"
@interface VCBegain ()
@property (strong, nonatomic) NSNumber* gameTime;
@property (strong, nonatomic) NSNumber* dayOrNight;

@property (strong, nonatomic) VRShowAct *RCell_showAction;

@property (strong, nonatomic) NSMutableAttributedString *attributedStr;//富文本 字符串
@property (strong, nonatomic) NSString* actList;
@property (strong, nonatomic) NSString* hintStr;//提示字符串
@end

@implementation VCBegain

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //-1 没有警徽 0 未设置 1正在设置 2已经设置
    _isSelectSheriff=[NSNumber numberWithInt:0];
    curActUserNum=0;
    beActedUserNum=0;
    _gameTime=[NSNumber numberWithInt:1];
    _dayOrNight=[NSNumber numberWithBool:NO];//NO夜晚 YES白天
    _cellArr=[NSMutableArray arrayWithCapacity:1];
    _actOrder=[NSMutableArray arrayWithCapacity:1];
    _witchHaveBane=[NSNumber numberWithBool:YES];
    if([_isHaveBobber boolValue])
    {
        _character1=[_characterArr objectAtIndex:[_characterArr count]-2];
        _character2=[_characterArr objectAtIndex:[_characterArr count]-1];
    }
   // for(int i=0;i<_characterArr.count;++i)
   //     [_actOrder addObject:[GameCharacter allocWithZone:(__bridge struct _NSZone *)([_characterArr objectAtIndex:i]) ]];
    _actOrder=[_characterArr mutableCopy];
    werwolfNum=0;
    civilianNum=0;
    thirdPartNum=0;
    deityNum=0;
    neutralityPart=0;
    [self sortArray:_actOrder orderWithKey:@"gamePriority" ascending:(YES)];
     [self sortArray:_characterArr orderWithKey:@"userNum" ascending:(YES)];
    _Title_Info.title=[NSString stringWithFormat:@"第-%3d  -天夜晚",[_gameTime intValue]];
    _actList=[NSString stringWithFormat:@"%@", _Title_Info.title];
    DBPart* db=[DBPart alloc];
   [db openDB];
    for(int i=0;i<_characterArr.count;++i){
        
        [db insertData:[NSString stringWithFormat: @"insert into user_info(user_name,game_identity) values (player%d,%@)",i, [_characterArr objectAtIndex:i]]];
    }
    [self outputDateOnView ];
 
    [self.view setUserInteractionEnabled:NO];
}


-(void)viewDidAppear:(BOOL)animated
{
    [self dividePart];
    [self gameAction:curActUserNum];
}

- (IBAction)pressUserInfo:(id)sender {
    
}
-(void)setUserEnterEnable:(BOOL)yesOrNo
{
    for(int i=0;i<_cellArr.count;++i)
    {
        [[_cellArr objectAtIndex:i] setUserInteractionEnabled:yesOrNo];
    }
}
-(void)nightAct:(int)index
{
    //晚上 行动
   
        if([[[_actOrder objectAtIndex:index]gamePriority] intValue]==7)
        {
            NSString* str=[NSString stringWithFormat:@"\n[%@] 确认身份 ",[[_actOrder objectAtIndex:index] character]];
            [self outputActOnView :str :2];
            [MBProgressHUD showMessage:str];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [self gameAction:++curActUserNum];
            });
            return;
        }
        NSString* str=[NSString stringWithFormat:@"\n[%3@] 开始行动",[[_actOrder objectAtIndex:index]character] ];
        [self outputActOnView :str :2];
        
       
        if([_isHaveBobber boolValue])
        {
             [self changeCardState:[[[_actOrder objectAtIndex:index]userNum] intValue]];
            [self userAction:[[[_actOrder objectAtIndex:index]userNum]intValue]:YES:0];
            return;
        }
    if([[[_actOrder objectAtIndex:index] userNum] intValue]!=100)
        {
           
            if([[[_actOrder objectAtIndex:index] gameIdentity] intValue]==6)
                _Coll_ShowUser.allowsMultipleSelection = YES;
            else
                _Coll_ShowUser.allowsMultipleSelection = NO;
            if([[[_actOrder objectAtIndex:index] gameIdentity] intValue]==1&&([[[_actOrder objectAtIndex:index] Skill] intValue]&antidote)>0)
            {
                [self changeCardState:[[[_actOrder objectAtIndex:index]userNum] intValue]];
                UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择救活目标" message: [NSString stringWithFormat:@"%d 号玩家死亡，是否救活他",curDeadNum+1] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* str=[NSString stringWithFormat:@"\n[女巫]救活了 %d 号玩家",curDeadNum+1];
                    [[_characterArr objectAtIndex:curDeadNum] setGameState:[NSNumber numberWithInt:SURVIVE]];
                    [[[_cellArr objectAtIndex:curDeadNum] Img_selected] setHidden:YES];
                    [[[_cellArr objectAtIndex:curActUserNum] Img_selected]setImage:[UIImage imageNamed:@"seleced"]];
                    [[_characterArr objectAtIndex:index] setSkill:[NSNumber numberWithInt:[[[_characterArr objectAtIndex:index] Skill] intValue]-antidote]];
                    [self outputActOnView :str :2];
                    [self changeCardState:[[[_actOrder objectAtIndex:index]userNum] intValue]];
                    [self gameAction:++curActUserNum];
                    return;
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"空药" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* str=[NSString stringWithFormat:@"\n[女巫] 没有用药 "];
                    [self outputActOnView :str :2];
                    [self changeCardState:[[[_actOrder objectAtIndex:index]userNum] intValue]];
                    [self gameAction:++curActUserNum];
                     return;
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"使用毒药" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   
                    [self deadOut:curDeadNum];
                    [self setUserEnterEnable:YES];
                }]];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
                return;
            }
            if([[[_actOrder objectAtIndex:index] part] intValue]==-1)
            {
                for(int i=0;i<werwolfNum;++i)
                    [self changeCardState:[[[_actOrder objectAtIndex:index+i]userNum] intValue]];
                [self showDisCuss:1];
                [self setUserEnterEnable: YES];
                return;
            }
            else
                [self changeCardState:[[[_actOrder objectAtIndex:index]userNum] intValue]];
            [self showActHint:[[[_actOrder objectAtIndex:index] gameIdentity] intValue]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
            if([[[_actOrder objectAtIndex:index]gameState] intValue]<SURVIVE)
            {
                [self gameAction:++curActUserNum];
            }
            [self setUserEnterEnable: YES];
        }
        else
        {
          [self showActHint:[[[_actOrder objectAtIndex:index] gameIdentity] intValue]];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                ++curActUserNum;
                [self gameAction:curActUserNum];
           });
        }
}

-(void)gameAction:(int)index
{
    if([[[_actOrder objectAtIndex:index]gamePriority] intValue]>7)
    {
        [self changeDayOrNightBack];
        curActUserNum=0;
    }
    if([self didEndGame]){
        if(![_dayOrNight boolValue])
        {
            [self nightAct:index];
        }
        else
        {
           //白天
            if([_isSelectSheriff intValue]==0&&[_gameTime intValue]==1)
            {
                _isSelectSheriff=[NSNumber numberWithInt:1];
                [self setUserEnterEnable: YES];
                NSString* str=[NSString stringWithFormat:@"\n开始竞选警长" ];
                [self outputActOnView :str :4];
                [self showActHint:30];
                
            }
            else{
                
            }
        }
    }
    else
    {
        //游戏结束提示
    }
}

//输出技能提示
-(void)showActHint:(int)gameId
{
    
    switch (gameId) {
        case 0:
        {
            _hintStr=[NSString stringWithFormat: @"请选择杀人目标！！！"] ;
        }
            break;
        case 3:
        {
            _hintStr=[NSString stringWithFormat: @"请选择检验目标！！！"] ;
        }
            break;
        case 4:
        {
            _hintStr=[NSString stringWithFormat: @"请选择守护目标！！！"] ;
        }
            break;
        case 1:
        {
            _hintStr=[NSString stringWithFormat: @"请选择用药目标！！！"] ;
        }
            break;
        case 21:
        {
            _hintStr=[NSString stringWithFormat: @"请选择禁言目标！！！"] ;
        }
            break;
        case 6:
        {
            _hintStr=[NSString stringWithFormat: @"请选择情侣！！！"] ;
        }
            break;
        case 7:
        {
            _hintStr=[NSString stringWithFormat: @"请选择偷看！！！"] ;
        }
            break;
        case 17:
        {
        
        }
            break;
        case 20:
        {
            _hintStr=[NSString stringWithFormat: @"情侣确认身份！！！"] ;
        }
            break;
        case 30:
        {
            _hintStr=[NSString stringWithFormat: @"请选择警长！！！"] ;
        }
            break;
        default:
            break;
    }
    [MBProgressHUD showMessage:_hintStr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //移除提示框遮盖
            [MBProgressHUD hideHUD];
        });

}

-(void)changeDayOrNightBack
{
    if([_dayOrNight boolValue]==NO){
        _CollImg_back.image=[UIImage imageNamed:@"day_back"];
        _Title_Info.title=[NSString stringWithFormat:@"第-%3d  -天白天",[_gameTime intValue]];
        _actList=[NSString stringWithFormat:@"\n%@" ,_Title_Info.title];
        [self outputDateOnView];
    }
    else{
        _gameTime=[NSNumber numberWithInt:[_gameTime intValue]+1];
        _CollImg_back.image=[UIImage imageNamed:@"night_back"];
        _Title_Info.title=[NSString stringWithFormat:@"第-%3d  -天夜晚",[_gameTime intValue]];
        _actList=[NSString stringWithFormat:@"\n%@" ,_Title_Info.title];
        [self outputDateOnView];
    }
    _dayOrNight =[NSNumber numberWithBool: ![_dayOrNight boolValue] ];
}
-(void)changeCardState:(int)index
{
    if([[[_characterArr objectAtIndex:index] userNum] intValue]==100)
        return;
    if([[[_characterArr objectAtIndex:index] gameState] intValue]>=SURVIVE||![_dayOrNight boolValue])
    {
        [[_cellArr objectAtIndex:index] Img_headImg].hidden=![[_cellArr objectAtIndex:index] Img_headImg].hidden;
    }
}
-(void)outputDateOnView
{
    [self makeActList:_actList Type:1 Num:0];

    [_RCell_showAction.Text_showAct setAttributedText:_attributedStr];
      [_RCell_showAction.Text_showAct scrollRangeToVisible:NSMakeRange(_attributedStr.length, 1)];
}

-(void)outputActOnView :(NSString*)str :(int)type
{
    [self makeActList:str Type:type Num:1];
    [_RCell_showAction.Text_showAct setAttributedText:_attributedStr];
    [_RCell_showAction.Text_showAct scrollRangeToVisible:NSMakeRange(_attributedStr.length, 1)];
  
//    [self.RCell_showAction reloadInputViews];
//    
//    [self reloadInputViews ];
 
}

-(void)showDisCuss :(int )type
{
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"商讨战术" message:@"确定结束商讨战术？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showActHint:0];
        //[self dismissViewControllerAnimated:YES completion:^{
           //         }];
          }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}

-(void)userAction :(int)index :(BOOL)isSelected :(int)selectedNum
{
    switch ([[[_characterArr objectAtIndex:index]gameIdentity] intValue]) {
        case 5:
        {
            _robberNum=[NSNumber numberWithInt:index];
           [self performSegueWithIdentifier:@"ribborSelectCard" sender:nil];
        }
            break;
        case 22:
        case 0:
        {
            if([[[_characterArr objectAtIndex:selectedNum] gameState] intValue]<SURVIVE)
            {
                [MBProgressHUD showError:@"你不能杀死出局目标!!!"];
                [[[_cellArr objectAtIndex:selectedNum] Img_selected] setHidden:YES];
            }
            if(isSelected)
            {
                UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择杀死对象" message:@"确认选择吗？" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    curDeadNum=selectedNum;
                    NSString* str=[NSString stringWithFormat:@"\n[狼人] 杀死了 %d 号",selectedNum+1];
                    
                    [self outputActOnView :str :2];
                    [[_characterArr objectAtIndex:curDeadNum] setGameState:[NSNumber numberWithInt:DEAD_BY_WERWOLF]];
                    [self deadOut:curDeadNum];
                    for(int i=0;i<werwolfNum;++i)
                        [self changeCardState:[[[_actOrder objectAtIndex:curActUserNum+i]userNum] intValue]];
                    curActUserNum+= werwolfNum;
                    [self gameAction:curActUserNum];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"空刀" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* str=[NSString stringWithFormat:@"\n[狼人] 空刀了 "];
                    [self outputActOnView :str :2];
                    for(int i=0;i<werwolfNum;++i)
                        [self changeCardState:[[[_actOrder objectAtIndex:curActUserNum+i]userNum] intValue]];
                    curActUserNum+= werwolfNum;
                    [self gameAction:curActUserNum];
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            }
        }
            break;
        case 3:
        {
            if([[[_characterArr objectAtIndex:selectedNum] gameState] intValue]<SURVIVE)
            {
                [MBProgressHUD showError:@"你不能检验出局目标!!!"];
                [[[_cellArr objectAtIndex:selectedNum] Img_selected] setHidden:YES];
            }
            if(isSelected)
            {
                UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择检验对象" message:@"确认选择吗？" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* str;
                    if([[[_characterArr objectAtIndex:selectedNum] part] intValue]<0)
                        str=[NSString stringWithFormat:@"\n[预言家] 检验了 %d 号是 [ 狼人 ]",selectedNum+1];
                    else
                        str=[NSString stringWithFormat:@"\n[预言家] 检验了 %d 号是 [ 好人 ]",selectedNum+1];
                    [self outputActOnView :str :2];
                    
                    [MBProgressHUD showMessage:[str substringFromIndex:1]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUD];
                        [self changeCardState:index];
                        [self gameAction:++curActUserNum];
                    });
                   
                    return;
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"空验" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* str=[NSString stringWithFormat:@"\n[预言家] 空验了 "];
                    [self outputActOnView :str :2];
                    [self changeCardState:index];
                    [self gameAction:++curActUserNum];
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
                
            }

        }
            break;
        case 4:
        {
            if([[[_characterArr objectAtIndex:selectedNum] gameState] intValue]<SURVIVE)
            {
                [MBProgressHUD showError:@"你不能守护出局目标!!!"];
                [[[_cellArr objectAtIndex:selectedNum] Img_selected] setHidden:YES];
            }
            int count=(int)[[_characterArr objectAtIndex:index] skillOb].count;
            if(count!=0&&[[[[_characterArr objectAtIndex:index] skillOb] objectAtIndex:count-1] intValue]==selectedNum)
            {
                [MBProgressHUD showError:@"你不能连续2天守护同一目标!!!"];
                [[[_cellArr objectAtIndex:selectedNum] Img_selected] setHidden:YES];
            }
            if(isSelected)
            {
                UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择守护对象" message:@"确认选择吗？" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* str=[NSString stringWithFormat:@"\n[守卫] 守护了 %d 号 ",selectedNum+1];
                    [self outputActOnView :str :2];
                    [[[_characterArr objectAtIndex:index] skillOb] addObject:[NSNumber numberWithInt:selectedNum]];
                    [self changeCardState:index];
                   [self gameAction:++curActUserNum];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"空守" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* str=[NSString stringWithFormat:@"\n[守卫] 空守了 "];
                    [self outputActOnView :str :2];
                    [self changeCardState:index];
                    [self gameAction:++curActUserNum];
                }]];

                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];

            }
        }
            break;
        case 1:
        {
            if([[[_characterArr objectAtIndex:selectedNum] gameState] intValue]<SURVIVE)
            {
                [MBProgressHUD showError:@"你不能毒死出局目标!!!"];
                [[[_cellArr objectAtIndex:selectedNum] Img_selected] setHidden:YES];
            }
            if(isSelected)
            {
                UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择毒死对象" message:@"确认选择吗？" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* str=[NSString stringWithFormat:@"\n[女巫] 毒死了 %d 号",selectedNum+1];
                    [[_characterArr objectAtIndex:selectedNum] setGameState:[NSNumber numberWithInt:DEAD_BY_WITCH]];
                    [self deadOut:selectedNum];
                    [[_characterArr objectAtIndex:index] setSkill:[NSNumber numberWithInt:[[[_characterArr objectAtIndex:index] Skill] intValue]-bane]];
                    [self outputActOnView :str :2];
                        [self changeCardState:[[[_actOrder objectAtIndex:index]userNum] intValue]];
                    [self gameAction:++curActUserNum];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"空药" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* str=[NSString stringWithFormat:@"\n[女巫] 没有用药 "];
                    [self outputActOnView :str :2];
                    [self changeCardState:[[[_actOrder objectAtIndex:index]userNum] intValue]];
                    [self gameAction:++curActUserNum];
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            }

        }
            break;
        case 21:
        {
            _robberNum=[NSNumber numberWithInt:index];
            [self performSegueWithIdentifier:@"ribborSelectCard" sender:nil];
        }
            break;
        case 6:
        {
            if(isSelected)
            {
                 [[[_characterArr objectAtIndex:index] skillOb] addObject:[NSNumber numberWithInt:selectedNum]];
            }
            else
            {
                [[[_characterArr objectAtIndex:index] skillOb] removeObject:[NSNumber numberWithInt:selectedNum]];
            }
            
            if([[_characterArr objectAtIndex:[[[_actOrder objectAtIndex:curActUserNum] userNum] intValue]] skillOb].count==2)
            {
                int idx1=[[[[_characterArr objectAtIndex:index] skillOb] objectAtIndex:0] intValue] ,idx2=[[[[_characterArr objectAtIndex:index] skillOb] objectAtIndex:1] intValue] ;
                UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择情侣" message:@"确认选择吗？" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[_characterArr objectAtIndex:idx1] setGameState:[NSNumber numberWithInt: lovers ]];
                    [[_characterArr objectAtIndex:idx2 ]setGameState:[NSNumber numberWithInt: lovers ]];
                    NSString* str=[NSString stringWithFormat:@"\n[丘比特] 选择了 %d 号 ,%d 号 为情侣",idx1+1,idx2+1];
                    [self outputActOnView :str :2];
                    [[_characterArr objectAtIndex:index] setGamePriority:[NSNumber numberWithInt:7]];

                    [self changeCardState:idx1];
                    [self changeCardState:idx2];
                    [self reloadInputViews];
                    str=[NSString stringWithFormat:@"\n[情侣] 确认身份" ];
                    
                    [self outputActOnView :str :2];
                    [self showActHint:20];
                   
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2000* NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                        [self changeCardState:idx1];
                        [self changeCardState:idx2];
                        [self reloadInputViews];
                        [[[_cellArr objectAtIndex:idx1] Img_selected] setHidden:YES];
                        [[[_cellArr objectAtIndex:idx2] Img_selected] setHidden:YES];
                        [self changeCardState:index];
                        [self gameAction:++curActUserNum];
                    });
                    
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];

            }
        }
            break;
        case 7:
        {
            _robberNum=[NSNumber numberWithInt:index];
            [self performSegueWithIdentifier:@"ribborSelectCard" sender:nil];
        }
            break;
        case 17:
        {
            _robberNum=[NSNumber numberWithInt:index];
            [self performSegueWithIdentifier:@"ribborSelectCard" sender:nil];
        }
            break;
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([[[_characterArr objectAtIndex:selectedNum] gameState] intValue]>=SURVIVE){
            [[[_cellArr objectAtIndex:selectedNum] Img_selected] setHidden:YES];
        }

    });
    if([[[_actOrder objectAtIndex:curActUserNum] gameIdentity] intValue]!=6)
        [self setUserEnterEnable: NO];
    return ;
}
-(void)makeActList:(NSString*)str Type:(int)type Num:(int)num
{
    
    if(type==1)
    {
        //创建 NSMutableAttributedString
        if(_attributedStr==nil)
            _attributedStr = [[NSMutableAttributedString alloc] initWithString: @""];
        NSMutableAttributedString* substr=NULL;
        substr=[[NSMutableAttributedString alloc]initWithString:str];
        
        //添加属性
        
        //给所有字符设置字体为Zapfino，字体高度为24像素
        [substr addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"AmericanTypewriter-Bold" size: 24]
                               range: NSMakeRange(0, str.length)];
        //分段控制，最开始4个字符颜色设置成蓝色
        [substr  addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(3,5)];
        //分段控制，第5个字符开始的3个字符，即第5、6、7字符设置为红色
        [substr  addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(str.length-2,2)];
         [_attributedStr appendAttributedString:substr];
    }
    else if(type==2)
    {
       // NSAttributedString* subStr=[[NSMutableAttributedString alloc] initWithString: str];
        //添加属性
        NSMutableAttributedString* substr=NULL;
        substr=[[NSMutableAttributedString alloc]initWithString:str];
        
        //给所有字符设置字体为Zapfino，字体高度为15像素
        [substr addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"AmericanTypewriter-Bold" size: 18]
                       range: NSMakeRange(0, str.length)];
       
        //分段控制，第5个字符开始的3个字符，即第5、6、7字符设置为红色
        [substr  addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(0,6)];
        [_attributedStr appendAttributedString:substr];
    }
    else if(type==3)
    {
        NSMutableAttributedString* substr=NULL;
        substr=[[NSMutableAttributedString alloc]initWithString:str];
        
        //给所有字符设置字体为Zapfino，字体高度为15像素
        [substr addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"AmericanTypewriter-Bold" size: 18]
                       range: NSMakeRange(0, str.length)];
        //分段控制，最开始4个字符颜色设置成蓝色
        [substr  addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(1,3 )];
        //分段控制，第5个字符开始的3个字符，即第5、6、7字符设置为红色
        [substr  addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(str.length-4,4)];
        [_attributedStr appendAttributedString:substr];
    }
    else if(type==4)
    {
        NSMutableAttributedString* substr=NULL;
        substr=[[NSMutableAttributedString alloc]initWithString:str];
        
        //给所有字符设置字体为Zapfino，字体高度为15像素
        [substr addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"AmericanTypewriter-Bold" size: 18]
                       range: NSMakeRange(0, str.length)];
        //分段控制，最开始4个字符颜色设置成蓝色
        [substr  addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(0, str.length )];
        [_attributedStr appendAttributedString:substr];
    }

}

- (IBAction)pressStop:(id)sender {
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"退出游戏" message:@"确认退出当前游戏吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
//死亡处理
-(void)deadOut:(int)index
{
    switch ([[[_characterArr objectAtIndex:index] gameState] intValue]) {
        case DEAD_BY_WERWOLF:
        {
            [[[_cellArr objectAtIndex:index] Img_selected] setImage:[UIImage imageNamed:@"userState_wolf"]];
             [[[_cellArr objectAtIndex:index] Img_selected] setHidden:NO];
            [[_cellArr objectAtIndex:index] setUserInteractionEnabled:NO];
        }
            break;
        case DEAD_BY_WITCH:
        {
            [[[_cellArr objectAtIndex:index] Img_selected] setImage:[UIImage imageNamed:@"userState_poison"]];
            [[[_cellArr objectAtIndex:index] Img_selected] setHidden:NO];
       
            [[_cellArr objectAtIndex:index] setUserInteractionEnabled:NO];
        }
            break;
        case DEAD_BY_WERWOLF_KING:
        {
            [[[_cellArr objectAtIndex:index] Img_selected] setImage:[UIImage imageNamed:@"userState_wolfKing"]];
            [[[_cellArr objectAtIndex:index] Img_selected] setHidden:NO];
            [[_cellArr objectAtIndex:index] setUserInteractionEnabled:NO];
        }
            break;
        case OUT_BY_CIVILIAN:
        {
            [[[_cellArr objectAtIndex:index] Img_selected] setImage:[UIImage imageNamed:@"userState_exiled"]];
            [[[_cellArr objectAtIndex:index] Img_selected] setHidden:NO];
            [[_cellArr objectAtIndex:index] setUserInteractionEnabled:NO];
        }
            break;
        case DEAD_NOT_DEFINE:
        {
            [[[_cellArr objectAtIndex:index] Img_selected] setImage:[UIImage imageNamed:@"userState_boom"]];
            [[[_cellArr objectAtIndex:index] Img_selected] setHidden:NO];
            [[_cellArr objectAtIndex:index] setUserInteractionEnabled:NO];
        }
            break;
        case DEAD_BY_HUNTER:
        {
            [[[_cellArr objectAtIndex:index] Img_selected] setImage:[UIImage imageNamed:@"userState_shoted"]];
            [[[_cellArr objectAtIndex:index] Img_selected] setHidden:NO];
            [[_cellArr objectAtIndex:index] setUserInteractionEnabled:NO];
        }
            break;
        case DEAD_BY_BOOM:
        {
            [[[_cellArr objectAtIndex:index] Img_selected] setImage:[UIImage imageNamed:@"userState_boom"]];
            [[[_cellArr objectAtIndex:index] Img_selected] setHidden:NO];
            [[_cellArr objectAtIndex:index] setUserInteractionEnabled:NO];
        }
            break;
        case DEAD_FOR_LOVE:
        {
            [[[_cellArr objectAtIndex:index] Img_selected] setImage:[UIImage imageNamed:@"userState_DeadForLove"]];
            [[[_cellArr objectAtIndex:index] Img_selected] setHidden:NO];
            [[_cellArr objectAtIndex:index] setUserInteractionEnabled:NO];
        }
            break;
        default:
            break;
    }
    //阵营人数 变更
}
//判断游戏是否结束
-(bool)didEndGame
{
    if(thirdPartNum!=0)
    {
        if(civilianNum+deityNum>=wolfPartNum)
            return NO;
        else if(civilianNum+deityNum<wolfPartNum)
        {
            winPart=-1;
            return YES;
        }
        else if(civilianNum+deityNum+wolfPartNum==0)
        {
            winPart=3;
            return YES;
        }
    }
    else
    {
        if(wolfPartNum>civilianNum+deityNum||deityNum==0||civilianNum==0)
        {
            winPart=-1;
            return YES;
        }
        else if(wolfPartNum==0)
        {
            winPart=1;
            return YES;
        }
        else
            return NO;
    }
    return NO;
}

//ios自带 array 排序工具 1.array 2.排序字段 3.升序或者降序
-(void) sortArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo{
    
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:yesOrNo];
    
    NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
    [dicArray sortUsingDescriptors:descriptors];
}
-(void)dividePart
{
    for(int i=0;i<_actOrder.count;++i)
    {
        if([[[_actOrder objectAtIndex:i] part] intValue]==-1)
        {
            wolfPartNum++;
            werwolfNum++;
        }
        else if([[[_actOrder objectAtIndex:i] part] intValue]==0)
            neutralityPart++;
        else if([[[_actOrder objectAtIndex:i] part] intValue]==1)
        {
            civilianNum++;
        }
        else
            deityNum++;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)wolfBoom:(int)index
{
    curDeadNum=index;
    //白狼王 发动技能
    if([[[_characterArr objectAtIndex:index] gameIdentity] intValue]==22)
    {
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"狼人自爆" message:@"确定自爆吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString* str=[NSString stringWithFormat:@"\n%d 号玩家白狼王自爆并发动技能",index+1];
            [self outputActOnView :str :4];
            [self showActHint:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
            [self.view setUserInteractionEnabled:YES];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:^{
            
        }];

    }
    [[_characterArr objectAtIndex:index] setGameState:[NSNumber numberWithInt: DEAD_BY_BOOM]];

    [self deadOut:index];
}

#pragma mark ---UICollectionView DataSource
//选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([[[_characterArr objectAtIndex:(int)indexPath.row] gameState] intValue]>=SURVIVE){
        if([_isSelectSheriff intValue]==1)
        {
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择警长" message:@"确认选择警长？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString* str=[NSString stringWithFormat:@"\n%d 号玩家当选警长",(int)indexPath.row+1];
                [self outputActOnView :str :4];
                _isSelectSheriff=[NSNumber numberWithInt:2];
                [self setUserEnterEnable:NO];
            }]];
            if([[[_characterArr objectAtIndex:indexPath.row] part] intValue]&-1)
            {
                [alert addAction:[UIAlertAction actionWithTitle:@"自爆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* str=[NSString stringWithFormat:@"\n%d 号玩家自爆吞掉警徽",(int)indexPath.row+1];
                    [self outputActOnView :str :4];
                    _isSelectSheriff=[NSNumber numberWithInt:-1];
                    [self wolfBoom:(int)indexPath.row];
                }]];
                
            }

            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            return;
        }
        if([_dayOrNight boolValue]&&[[[_characterArr objectAtIndex:indexPath.row] part] intValue]&-1)
        {
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"狼人自爆" message:@"确定自爆吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString* str=[NSString stringWithFormat:@"\n%d 号玩家自爆",(int)indexPath.row+1];
                [self outputActOnView :str :4];
                [self wolfBoom:(int)indexPath.row];
                [self.view setUserInteractionEnabled:NO];
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            return;
        }
        [[[_cellArr objectAtIndex:indexPath.row] Img_selected]setHidden:NO];
        [self userAction:[[[_actOrder objectAtIndex:curActUserNum] userNum] intValue]:YES:(int)indexPath.row];
    }
}

////取消选中cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if([[[_characterArr objectAtIndex:(int)indexPath.row] gameState] intValue]>=SURVIVE){
        [[[_cellArr objectAtIndex:indexPath.row] Img_selected]setHidden:YES];
        [self userAction:[[[_actOrder objectAtIndex:curActUserNum] userNum] intValue]:NO:(int)indexPath.row];
    }
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//允许选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//允许取消选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; // called when the user taps on an already-selected item in multi-select mode
{
    return YES;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return [_mutDic_userSelect ];
    if([_isHaveBobber boolValue])
        return _characterArr.count-2;
     return _characterArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"cell";
    NSString* imgName;
    imgName=[[_characterArr objectAtIndex:indexPath.row] imgName];
    UIImage* img=[UIImage imageNamed:imgName];
    
    VBeginCell* cell = (VBeginCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    cell.Label_num.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row +1];
    cell.Img_charactor.image=img;
    cell.Img_selected.image=[UIImage imageNamed:@"selected"];
    [_cellArr addObject:cell];
    
    return cell;
}

//判断 collectionview 子视图类型 赋值
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader&&_RCell_showAction==NULL ) {
      _RCell_showAction =(VRShowAct*) [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Rcell" forIndexPath:indexPath];
         _RCell_showAction.Text_showAct.attributedText = _attributedStr;
    }
    return _RCell_showAction;
}

//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    CGFloat x=[[UIScreen mainScreen]bounds].size.width;
    //CGFloat y=[[UIScreen mainScreen]bounds].size.height;
    return CGSizeMake(x/(int)sqrt(_characterArr.count)-10,x/(int)sqrt(_characterArr.count)-10);
}

//定义每个UICollectionView 的边距
- ( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
    return UIEdgeInsetsMake ( 4,4,4,4 );
}
//设置水平间距 (同一行的cell的左右间距）
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}
//垂直间距 (同一列cell上下间距)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqual: @"ribborSelectCard"]) {
        VCRobberSelect* robberSelect = segue.destinationViewController ;
        robberSelect  .modalPresentationStyle = UIModalPresentationPopover;
        robberSelect  .popoverPresentationController.delegate = self;
        robberSelect .begain=self;
        robberSelect.name1=[_character1 imgName];
        robberSelect.name2=[_character2 imgName];
        //[self.view addSubview:userInfo.view];
    }
    if ([segue.identifier  isEqual: @"userInfo"]) {
        VCCharacterInfo* info = segue.destinationViewController ;
        info  .modalPresentationStyle = UIModalPresentationPopover;
        info .popoverPresentationController.delegate = self;
    }
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}


@end
