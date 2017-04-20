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
@interface VCCharactor ()
@property (weak, nonatomic) IBOutlet UICollectionView *Coll_charactorList;
@property (strong,nonatomic)FMResultSet* charactor;
@property (weak, nonatomic) IBOutlet UICollectionView *Coll_list;

@property (strong,nonatomic)NSMutableArray* imageArr;
@property (strong,nonatomic)NSMutableArray* nameArr;
@property (nonatomic, strong) NSMutableIndexSet* selectedIndexSet;
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
     
     _charactor=[FMResultSet alloc];
     _charactor= [dbPart selectAllFromDB:@"select * from game_identity where identity!='123'"];
     _selectedIndexSet=[NSMutableIndexSet alloc];
     _imageArr=[NSMutableArray arrayWithCapacity:10 ];
     _nameArr=[NSMutableArray arrayWithCapacity:10];
     for(;[_charactor next];)
     {
          ++count;
          [_imageArr  addObject:[_charactor stringForColumn:@"image_name"]];
          [_nameArr  addObject:[_charactor stringForColumn:@"identity"]];
     }
     //设置允许多选
     _Coll_list.allowsMultipleSelection = YES;
}

- (IBAction)pressDone:(id)sender {
     
     //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
     VCPrepare * up= [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-1];
     up.nameArr=[NSMutableArray alloc];
     up.nameArr=_nameArr;
     
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
  
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
     ((Vcell*)[collectionView cellForItemAtIndexPath:indexPath]).Img_isSelect.image=[UIImage imageNamed:@"notSelect.png"];
    
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

     UIImage* img=[UIImage imageNamed:_imageArr[indexPath.row]];
     Vcell* cell = (Vcell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
     if(!cell)
          cell=(Vcell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
     cell.Cell_img.image= img;
     cell.Cell_label.text=_nameArr[indexPath.row];
    // cell.Img_isSelect.image=[UIImage imageNamed:@"notSelect.png"];
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
