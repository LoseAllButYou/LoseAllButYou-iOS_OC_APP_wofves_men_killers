//
//  VCPrepare.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/15.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCPrepare.h"

@interface VCPrepare ()
@property (weak, nonatomic) IBOutlet UIPickerView *Pick_gameUserNum;


@property (weak, nonatomic) NSNumber* gameUserNum;
@property (weak, nonatomic) NSNumber* civilianNum;
@property (weak, nonatomic) NSNumber* werwolfNum;
@property (weak, nonatomic) IBOutlet UIButton *Btn_addCharactor;

@end

@implementation VCPrepare

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _gameUserNum= [NSNumber numberWithInteger: 6 ];
     _civilianNum= [NSNumber numberWithInteger: 2 ];
     _werwolfNum= [NSNumber numberWithInteger: 2 ];
}
- (IBAction)pressAddCharactor:(id)sender {
     
}
//pickview 选中某行数据
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     if(component==0){
          _gameUserNum= [NSNumber numberWithInteger: row +6 ];
          NSLog(@"user num==%@",_gameUserNum);
     }
     else if(component==1){
          _civilianNum= [NSNumber numberWithInteger: row +2 ];
          NSLog(@"civilan num==%@",_civilianNum);
     }
     else{
          _werwolfNum= [NSNumber numberWithInteger: row +2 ];
          NSLog(@"wolf num==%@",_werwolfNum);
     }
     
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
