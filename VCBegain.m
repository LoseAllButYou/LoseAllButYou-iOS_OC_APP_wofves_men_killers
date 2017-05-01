//
//  VCBegain.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCBegain.h"
#import "VBeginCell.h"
#import "NSObject+DBPart.h"
#import "VRShowAct.h"
#import "NSObject+GameCharacter.h"
#import <math.h>
#import "VCRobberSelect.h"
@interface VCBegain ()

@property (strong, nonatomic) NSNumber* gameTime;
@property (strong, nonatomic) NSNumber* dayOrNight;

@property (strong, nonatomic) NSMutableArray* cellArr;
@property (strong ,nonatomic) NSMutableArray* actOrder;
@property (strong, nonatomic) VRShowAct *RCell_showAction;

@property (strong, nonatomic) NSMutableAttributedString *attributedStr;//富文本 字符串
@property (strong, nonatomic) NSString* actList;
@end

@implementation VCBegain

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    curActUserNum=0;
    beActedUserNum=0;
    _gameTime=[NSNumber numberWithInt:1];
    _dayOrNight=[NSNumber numberWithBool:NO];//NO夜晚 YES白天
    _cellArr=[NSMutableArray arrayWithCapacity:1];
    _actOrder=[NSMutableArray arrayWithCapacity:1];
    for(int i=0;i<_characterArr.count;++i)
        [_actOrder addObject:[GameCharacter allocWithZone:(__bridge struct _NSZone *)([_characterArr objectAtIndex:i]) ]];
    _actOrder=[_characterArr mutableCopy];
    werwolfNum=0;
    civilianNum=0;
    thirdPartNum=0;
    deityNum=0;
    neutralityPart=0;
    [self sortArray:_actOrder orderWithKey:@"gamePriority" ascending:(YES)];
     [self sortArray:_characterArr orderWithKey:@"userNum" ascending:(YES)];
    _Title_Info.title=[NSString stringWithFormat:@"第-%3d  -天夜晚\n",[_gameTime intValue]];
    _actList=[NSString stringWithFormat:@"%@", _Title_Info.title];
    DBPart* db=[DBPart alloc];
    [db openDB];
    for(int i=0;i<_characterArr.count;++i){
        
        [db insertData:[NSString stringWithFormat: @"insert into user_info(user_name,game_identity) values (player%d,%@)",i, [_characterArr objectAtIndex:i]]];
    }
    [self outputDateOnView ];

    
   
}
-(void)viewDidAppear:(BOOL)animated
{
    [self gameAction:curActUserNum];
}
-(void)gameAction:(int)index
{
    
    if([self didEndGame]){
        if(![_dayOrNight boolValue])
        {
            if([[[_actOrder objectAtIndex:index]gameState] intValue]>=SURVIVE&&[[[_actOrder objectAtIndex:index]gamePriority] intValue]<=7)
            {
                [self outputActOnView:index];
                [self changeCardState:[[[_actOrder objectAtIndex:index]userNum] intValue]];
                [self userAction:[[[_actOrder objectAtIndex:index]userNum] intValue]];
            }
        }
        else
        {
            [self outputDateOnView];
        }
    }
}
-(void)changeCardState:(int)index
{
    if([[[_characterArr objectAtIndex:index] gameState] intValue]>=SURVIVE)
    {
        [[_cellArr objectAtIndex:index] Img_headImg].hidden=YES;
    }
}
-(void)outputDateOnView
{
    [self makeActList:_actList Type:1 Num:0];

    [_RCell_showAction.Text_showAct setAttributedText:_attributedStr];
    
}
-(void)outputActOnView:(int)index
{
    
    NSString* str=[NSString stringWithFormat:@"%2d 号玩家[%@]开始行动",[[[_actOrder objectAtIndex:index]userNum] intValue]+1,[[_actOrder objectAtIndex:index]character] ];
    [self makeActList:str Type:2 Num:1];
    [_RCell_showAction.Text_showAct setAttributedText:_attributedStr];
    
}
-(void)userAction:(int)index
{
    switch ([[[_characterArr objectAtIndex:index]gameIdentity] intValue]) {
        case 5:
        {
           // [self performSegueWithIdentifier:@"ribborSelectCard" sender:nil];
           // [[[_cellArr objectAtIndex:index] Tap_RobberSelect] a]
        }
            break;
            
        default:
            break;
    }
    return ;
}
-(void)makeActList:(NSString*)str Type:(int)type Num:(int)num
{
    if(type==1)
    {
        //创建 NSMutableAttributedString
        if(_attributedStr==nil)
            _attributedStr = [[NSMutableAttributedString alloc] initWithString: str];
        else
            [_attributedStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString: str]];
        //添加属性
        
        //给所有字符设置字体为Zapfino，字体高度为15像素
        [_attributedStr addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"AmericanTypewriter-Bold" size: 24]
                               range: NSMakeRange(0, str.length)];
        //分段控制，最开始4个字符颜色设置成蓝色
        [_attributedStr  addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(2,5)];
        //分段控制，第5个字符开始的3个字符，即第5、6、7字符设置为红色
        [_attributedStr  addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(str.length-2,2)];
        
    }
    else
    {
        //创建 NSMutableAttributedString
        _attributedStr = [[NSMutableAttributedString alloc] initWithString: str];
        
        //添加属性
        
        //给所有字符设置字体为Zapfino，字体高度为15像素
        [_attributedStr addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"AmericanTypewriter-Bold" size: 24]
                               range: NSMakeRange(0, str.length)];
        //分段控制，最开始4个字符颜色设置成蓝色
        [_attributedStr  addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(3,2 )];
        //分段控制，第5个字符开始的3个字符，即第5、6、7字符设置为红色
        [_attributedStr  addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(str.length-3,2)];
        
    }
}

//判断游戏是否结束
-(bool)didEndGame
{
    if(thirdPartNum!=0)
    {
        if(civilianNum+deityNum>=werwolfNum)
            return NO;
        else if(civilianNum+deityNum<werwolfNum)
        {
            winPart=-1;
            return YES;
        }
        else if(civilianNum+deityNum+werwolfNum==0)
        {
            winPart=3;
            return YES;
        }
    }
    else
    {
        if(werwolfNum>civilianNum+deityNum||deityNum==0||civilianNum==0)
        {
            winPart=-1;
            return YES;
        }
        else if(werwolfNum==0)
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
        //[self.view addSubview:userInfo.view];
    }

}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}


@end
