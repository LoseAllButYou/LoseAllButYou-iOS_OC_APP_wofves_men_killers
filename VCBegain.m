//
//  VCBegain.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCBegain.h"
#import "VBeginCell.h"

enum DEAD_OUT_TYPE{
    DEAD_BY_WERWOLF=0,
    DEAD_BY_WITCH=1,
    DEAD_BY_HUNTER=2,
    DEAD_BY_WERWOLF_KING=3,
    OUT_BY_CIVILIAN=4,
    DEAD_NOT_DEFINE=5,
};

@interface VCBegain ()
@property (weak, nonatomic) NSNumber* curActUserNum;
@property (weak, nonatomic) NSNumber* beActedUserNum;
@end

@implementation VCBegain

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---UICollectionView DataSource
//选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

////取消选中cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  
    
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
    return [[_mutDic_userSelect valueForKey:@"characterImg"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"cell";
    NSString* imgName;
    [[_mutDic_userSelect valueForKey:@"characterImg"] objectAtIndex:indexPath.row];
    UIImage* img=[UIImage imageNamed:imgName];
    
    VBeginCell* cell = (VBeginCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    cell.Label_num.text=[NSString stringWithFormat:@"%d", indexPath.row ];
    cell.Img_charactor.image=img;
    return cell;
}



//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    CGFloat x=[[UIScreen mainScreen]bounds].size.width;
    CGFloat y=[[UIScreen mainScreen]bounds].size.height;
    return CGSizeMake(x/2-10,x/2-10);
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
