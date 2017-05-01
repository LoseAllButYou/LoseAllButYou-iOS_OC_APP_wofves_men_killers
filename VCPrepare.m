//
//  VCPrepare.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/15.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCPrepare.h"
#import "MBProgressHUD+MJ.h"
#import "NSObject+DBPart.h"
#import "VCPlayerSelect.h"
#import "NSObject+GameCharacter.h"
@interface VCPrepare ()
@property (weak, nonatomic) IBOutlet UIPickerView *Pick_gameUserNum;

@property (weak, nonatomic) IBOutlet UIButton *Btn_addCharactor;

@end

@implementation VCPrepare

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    gameUserNum= 6;
    civilianNum= 2;
    werwolfNum= 2;
    _isPressDone=[NSNumber numberWithBool:NO];
    
}
- (IBAction)pressAddCharactor:(id)sender {
     
}
- (IBAction)Btn_begainGame:(id)sender {
    DBPart* dbPart=[DBPart alloc];
    NSLog(@"op Source==%d",[dbPart openOrCreatDB:@"werwolf_killer_DB/werwolf_killer_DB.db"]);
    [dbPart openDB];
    
    NSLog(@"insert ret=%d   close ret=%d",[dbPart insertData:[NSString stringWithFormat: @"INSERT INTO history_info( player_num)VALUES ( %d)",gameUserNum]],[dbPart closeDB]);
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     //判断并接收返回的参数
//    if (!_nameArr)
//        return;
    if(!_characterArr)
        return ;
    if([_isPressDone boolValue])
    {
        _isPressDone=[NSNumber numberWithBool:NO];
        [self judgeIsTrueNum];
    }
}
//判断 游戏 人数 身份数 是否符合
-(void)judgeIsTrueNum
{
    _TextView_charactor.text = @"游戏身份:\n";
    _TextView_charactor.text = [_TextView_charactor.text stringByAppendingString:[NSString stringWithFormat: @"总人数X%d 平民X%d 普通狼人X%d\n特殊身份：\n",gameUserNum, civilianNum ,werwolfNum]];
    for(int i=0;i<_characterArr.count;++i)
    {
        if(i!=0)
            _TextView_charactor.text = [_TextView_charactor.text stringByAppendingString:@"   "];
        _TextView_charactor.text = [_TextView_charactor.text stringByAppendingString:[[_characterArr objectAtIndex:i] character]];
    }
    if([_isHaveBobber boolValue])
    {
        if(_characterArr.count+civilianNum+werwolfNum !=gameUserNum+2)
        {
            if( _isPressDone)
                [MBProgressHUD showError:@"游戏身份配置有误 请重新计算 人数!!!"];
            return ;
        }
    }
    else
        if(_characterArr.count+civilianNum+werwolfNum !=gameUserNum)
        {
            if( _isPressDone)
                [MBProgressHUD showError:@"游戏身份配置有误 请重新计算 人数!!!"];
            return ;
        }
    _Btn_begainGame.enabled=YES;
}
//pickview 选中某行数据
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     if(component==0){
          gameUserNum= row +6 ;
     }
     else if(component==1){
          civilianNum= row +2 ;
     }
     else{
          werwolfNum= row +2 ;
     }
    if (!_characterArr)
        return;
    [self judgeIsTrueNum];
     
}
//pickerview 组数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
     return 3;
}
//pickview 行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
     if(component==0)
          return 15;
     else
          return 7;
}
//pickview 每行显示
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
     NSString* str;
     if(component==0){
          str=[NSString stringWithFormat:@"%ld个玩家",row+6];
     }
     else if(component==1)
     {
          str=[NSString stringWithFormat:@"%ld个村民",row+2];
     }
     else
     {
          str=[NSString stringWithFormat:@"%ld个狼人",row+2];
     }
     return str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqual: @"VCPlayerSelect"]) {
        VCPlayerSelect* playerSelect = segue.destinationViewController ;
        NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:gameUserNum],@"userNum", [NSNumber numberWithInt:civilianNum],@"civilianNum" ,[NSNumber numberWithInt:werwolfNum],@"werwolfNum",nil];
        playerSelect.characterInfo=dic;
        playerSelect.isHaveBobber=_isHaveBobber;
        playerSelect.characterArr=_characterArr;
        //[self.view addSubview:userInfo.view];
    }

}


@end
