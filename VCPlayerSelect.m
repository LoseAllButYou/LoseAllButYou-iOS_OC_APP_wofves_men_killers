//
//  VCPlayerSelect.m
//  wolfmen_killers
//
//  Created by wrongmean on 2017/4/25.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCPlayerSelect.h"
#import "VSelectCell.h"
#import "VCBegain.h"
#import "NSObject+DBPart.h"
#import "NSObject+GameCharacter.h"
@interface VCPlayerSelect ()
@property (weak, nonatomic) IBOutlet UICollectionView *Coll_character;

@end

@implementation VCPlayerSelect

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    curCharacterNum=[[_characterInfo valueForKey:@"userNum"]intValue];
    _freedomArr=[NSMutableArray arrayWithCapacity:curCharacterNum];
    _mutDic_userSelect=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray arrayWithCapacity:curCharacterNum],@"characterName",[NSMutableArray arrayWithCapacity:curCharacterNum] , @"characterImg" ,nil];
        _isFirst=[NSNumber numberWithBool:YES];
    for(int i=0;i<[[_characterInfo valueForKey:@"userNum"]intValue];++i)
    {
        [_freedomArr addObject:[NSNumber numberWithInt:i]];
    }

    //_mutArr_characterName=[_characterInfo valueForKey:@"specialCharactor"];
    //_mutArr_characterImg=[_characterInfo valueForKey:@"imgName"];
    if(_characterArr.count<curCharacterNum){
        for(int i=0;i<[[_characterInfo valueForKey:@"civilianNum"]intValue];++i)
        {
            //[_mutArr_characterName addObject:@"平民"];
            //[_mutArr_characterImg addObject:@"civilian.jpg"];
            GameCharacter* gc=[GameCharacter alloc];
            [gc alloc];
            gc.character=@"平民";
            gc.imgName=@"civilian.jpg";
            gc.gamePriority=[NSNumber numberWithInt: 10];
            [gc setGameIdentity:[NSNumber numberWithInt:10]];
            [gc autoSet];
            [_characterArr addObject:gc];
        }
        for(int i=0;i<[[_characterInfo valueForKey:@"werwolfNum"] intValue];++i)
        {
            GameCharacter* gc=[GameCharacter alloc];
            [gc alloc];
            gc.character=@"狼人";
            gc.imgName=@"wolf.jpg";
            gc.gamePriority=[NSNumber numberWithInt: 4];
            [gc setGameIdentity:[NSNumber numberWithInt:0]];
            [gc autoSet];
            [_characterArr addObject:gc];
        }
    }
    if([_isHaveBobber boolValue]){
        int i=0;
        do{
            srand((unsigned int)time(NULL));
            int num=rand()%curCharacterNum;
            if([[[_characterArr objectAtIndex:num] gameIdentity] intValue]==5)
                continue;
                [_characterArr exchangeObjectAtIndex:curCharacterNum+i withObjectAtIndex:num];
            i=1;
            num=rand()%curCharacterNum;
            if([[[_characterArr objectAtIndex:num] gameIdentity] intValue]==5)
                continue;
            [_characterArr exchangeObjectAtIndex:curCharacterNum +i withObjectAtIndex:num];
            if(([[[_characterArr objectAtIndex:curCharacterNum] part] intValue]!=-1||[[[_characterArr objectAtIndex:curCharacterNum+1] part] intValue]!=-1))
            {
                 break;
            }
        }while(1);
    }
    [self randCellView];
    //设置允许多选
    _Coll_character.allowsMultipleSelection = YES;
}
-(void)randCellView
{
    for(int i=0;curCharacterNum>0;++i,--curCharacterNum){

        srand((unsigned)time(NULL));
        int num1=rand()%curCharacterNum;
        
        
        [[_characterArr objectAtIndex: [[_freedomArr objectAtIndex: num1 ] intValue]] setUserNum:[NSNumber numberWithInt:i]];
        NSLog(@"index =%d %@ = %d,",num1,[[_characterArr objectAtIndex: [[_freedomArr objectAtIndex: num1 ]intValue]] character],[[[_characterArr objectAtIndex: [[_freedomArr objectAtIndex: num1 ]intValue]] userNum] intValue]);
        
        [(NSMutableArray*)[_mutDic_userSelect valueForKey:@"characterImg"] addObject:[[_characterArr objectAtIndex: [[_freedomArr objectAtIndex: num1 ] intValue]] imgName]];
        [(NSMutableArray*)[_mutDic_userSelect valueForKey:@"characterName"] addObject:[[_characterArr objectAtIndex: [[_freedomArr objectAtIndex: num1 ] intValue]] character]];
         [_freedomArr removeObjectAtIndex:num1];
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---UICollectionView DataSource
//选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VSelectCell* cell=(VSelectCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //cell.Img_back.hidden=!cell.Img_back.hidden;
    cell.Img_back.hidden=YES;

}

////取消选中cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    VSelectCell* cell=(VSelectCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.Img_back.hidden=NO;
    
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
//定义展示的UICollectionViewCell的个数
{
    return YES;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_characterInfo valueForKey:@"userNum"] intValue];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"cell";
    UIImage* img=[UIImage imageNamed:[(NSMutableArray*)[_mutDic_userSelect valueForKey:@"characterImg"]objectAtIndex:indexPath.row]];
    
    VSelectCell* cell = (VSelectCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

    cell.Img_character.image= img;
    cell.Label_character.text=[(NSMutableArray*)[_mutDic_userSelect valueForKey:@"characterName"] objectAtIndex:indexPath.row];
    cell.Label_userNum.text=[NSString stringWithFormat:@"%d",(int)indexPath.row+1];
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"begainVC"])
    {
        UINavigationController *nav = segue.destinationViewController;
        VCBegain* nextVC = (VCBegain*)nav;
        nextVC.characterArr=_characterArr;
        nextVC.isHaveBobber=_isHaveBobber;
    }

}


@end
