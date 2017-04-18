//
//  VCPrepare.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/15.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCPrepare.h"
#import "NSObject+DBPart.h"
@interface VCPrepare ()
@property (weak, nonatomic) IBOutlet UIPickerView *Pick_gameUserNum;

@property (weak, nonatomic) IBOutlet UICollectionView *Coll_charactorList;
@property (weak, nonatomic) NSNumber* gameUserNum;
@property (weak, nonatomic) NSNumber* civilianNum;
@property (weak, nonatomic) NSNumber* werwolfNum;
@property (weak, nonatomic) IBOutlet UIButton *Btn_addCharactor;
@property (weak, nonatomic) FMResultSet* charactor;
@end

@implementation VCPrepare

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _gameUserNum= [NSNumber numberWithInteger: 6 ];
     _civilianNum= [NSNumber numberWithInteger: 2 ];
     _werwolfNum= [NSNumber numberWithInteger: 2 ];
}
//点击add 按钮 添加collection试图 事件
- (IBAction)pressAddCharactor:(id)sender {
    DBPart* dbPart=[DBPart alloc];
    NSLog(@"op Source==%d",[dbPart openOrCreatDB:@"werwolf_killer_DB/werwolf_killer_DB.db"]);
    NSLog(@"openDB res ==%d",[dbPart openDB]);
    //_charactor=[dbPart selectAllFromDB:@"select * from history_info"];
    
    _charactor= [dbPart selectAllFromDB:@"select * from game_identity where image_name!=NULL"];
    int i=0;
    for(;[_charactor next ];)
    {
        i++;
    }
    NSLog(@"char NUM ==%d %@",_charactor.columnCount,[_charactor stringForColumn:@"image_name"]);
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
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _charactor.columnCount;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=0)
      [ _charactor next];
    UIImage* img=[UIImage imageNamed:[_charactor stringForColumn:@"image_name"]];
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:[_charactor stringForColumn:@"identity"] forIndexPath:indexPath];
    [cell addSubview:[[UIImageView alloc]initWithImage:img]];
    return cell;
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
