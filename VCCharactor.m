//
//  VCCharactor.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/18.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCCharactor.h"
#import "NSObject+DBPart.h"
#import "Vcell.h"
#import "VCPrepare.h"
#import "NSObject+GameCharacter.h"
@interface VCCharactor ()
//@property (weak, nonatomic) IBOutlet UICollectionView *Coll_charactorList;
@property (strong,nonatomic)FMResultSet* charactor;
@property (weak, nonatomic) IBOutlet UICollectionView *Coll_list;

@property (weak, nonatomic) IBOutlet UILabel *Label_selectedNum;
@property (nonatomic, strong)NSMutableArray* characterArr;
@property (nonatomic, strong)NSMutableArray* selectedcharacterArr;
@property (nonatomic, strong)NSMutableArray* boolArr;
@end

@implementation VCCharactor

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     DBPart* dbPart=[DBPart alloc];
     NSLog(@"op Source==%d",[dbPart openOrCreatDB:@"werwolf_killer_DB/werwolf_killer_DB.db"]);
     NSLog(@"openDB res ==%d",[dbPart openDB]);
     //_charactor=[dbPart selectAllFromDB:@"select * from history_info"];
     selectedNum=0;
    _Label_selectedNum.text=[NSString stringWithFormat:@"以选择角色数:%d",selectedNum];
     _charactor=[FMResultSet alloc];
     _charactor= [dbPart selectAllFromDB:@"select * from game_identity where identity!='123' order by action_priority"];

    _characterArr=[NSMutableArray arrayWithCapacity:10];
    _selectedcharacterArr=[NSMutableArray arrayWithCapacity:( 10)];
     _isHaveBobber=[NSNumber numberWithBool:NO];
     for(;[_charactor next];)
     {
          ++count;
//          [_imageArr  addObject:[_charactor stringForColumn:@"image_name"]];
//          [_nameArr  addObject:[_charactor stringForColumn:@"identity"]];
         GameCharacter* gc=[GameCharacter alloc];
         [gc alloc];
         gc.character=[_charactor stringForColumn:@"identity"];
         gc.imgName=[_charactor stringForColumn:@"image_name"];
         gc.gamePriority=[NSNumber numberWithInt: [_charactor intForColumn:@"action_priority"] ];
         gc.gameIdentity=[NSNumber numberWithInt:[_charactor intForColumn:@"id"]];
         [gc autoSet];
         [_characterArr addObject:gc];
         
     }
    _boolArr=[NSMutableArray arrayWithCapacity:12];
 
     //设置允许多选
     _Coll_list.allowsMultipleSelection = YES;
    [dbPart closeDB];
}

- (IBAction)pressDone:(id)sender {
     
     //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
     VCPrepare * up= [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    up.characterArr=[NSMutableArray arrayWithCapacity:1];
    up.characterArr= _selectedcharacterArr;
    up.isPressDone=[NSNumber numberWithBool:YES];
    up.isHaveBobber=_isHaveBobber;
          [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---UICollectionView DataSource
//选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     
     ((Vcell*)[collectionView cellForItemAtIndexPath:indexPath]).Img_isSelect.image=[UIImage imageNamed:@"didSelect.png"];
    [_boolArr setObject:@"didSelect" atIndexedSubscript:indexPath.row];
    [_selectedcharacterArr addObject:_characterArr[indexPath.row]];
    ++selectedNum;
    if([[_characterArr [indexPath.row]gameIdentity] intValue]==5)
        _isHaveBobber=[NSNumber numberWithBool:YES];
    _Label_selectedNum.text=[NSString stringWithFormat:@"以选择角色数:%d",selectedNum];
}

//取消选中cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
     ((Vcell*)[collectionView cellForItemAtIndexPath:indexPath]).Img_isSelect.image=[UIImage imageNamed:@"notSelect.png"];
    [_boolArr setObject:@"notSelect" atIndexedSubscript:indexPath.row];
     [_selectedcharacterArr removeObject:_characterArr[indexPath.row]];
    --selectedNum;
    if([[_characterArr [indexPath.row]gameIdentity] intValue]==5)
        _isHaveBobber=[NSNumber numberWithBool:NO];
    _Label_selectedNum.text=[NSString stringWithFormat:@"以选择角色数:%d",selectedNum];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
     return 1;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; // called when the user taps on an already-selected item in multi-select mode
//定义展示的UICollectionViewCell的个数
{
     return YES;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *identify = @"c1";

//     UIImage* img=[UIImage imageNamed:_imageArr[indexPath.row]];
    UIImage* img=[UIImage imageNamed:[[_characterArr objectAtIndex:indexPath.row] imgName]];
    
    Vcell* cell = (Vcell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
   
     cell.Cell_img.image= img;
    // cell.Cell_label.text=_nameArr[indexPath.row];
    cell.Cell_label.text=[[_characterArr objectAtIndex:indexPath.row ] character];
    if(_boolArr.count>indexPath.row)
    {
        cell.Img_isSelect.image=[UIImage imageNamed:[_boolArr objectAtIndex:indexPath.row]];    }
    else{
        cell.Img_isSelect.image=[UIImage imageNamed:@"notSelect"];
        [_boolArr addObject:@"notSelect"];
    }
  
     return cell;
}
//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
     CGFloat x=[[UIScreen mainScreen]bounds].size.width;
    
     return CGSizeMake(x/2-10,x/2+20);
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
@end
