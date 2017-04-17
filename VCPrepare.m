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

@property (weak, nonatomic) IBOutlet UICollectionView *Coll_charactorList;
@property (weak, nonatomic) NSNumber* gameUserNum;
@property (weak, nonatomic) NSNumber* civilianNum;
@property (weak, nonatomic) NSNumber* werwolfNum;

@end

@implementation VCPrepare

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _gameUserNum= [NSNumber numberWithInteger: 6 ];
     _civilianNum= [NSNumber numberWithInteger: 2 ];
     _werwolfNum= [NSNumber numberWithInteger: 2 ];
}
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
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
     return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
     if(component==0)
          return 15;
     else
          return 7;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
     NSString* str;
     if(component==0){
          str=[NSString stringWithFormat:@"%d个玩家",row+6];
     }
     else if(component==1)
     {
          str=[NSString stringWithFormat:@"%d个村民",row+2];
     }
     else
     {
          str=[NSString stringWithFormat:@"%d个狼人",row+2];
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
