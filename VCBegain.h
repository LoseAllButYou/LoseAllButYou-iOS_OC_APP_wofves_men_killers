//
//  VCBegain.h
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface VCBegain : UIViewController
{
    int deityNum;
    int civilianNum;
    int werwolfNum;
    int thirdPartNum;//第三方人数
    int neutralityPart;//中立人数
    int winPart;//获胜阵营
    int curActUserNum;
    int beActedUserNum;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *Title_Info;
@property (weak, nonatomic) IBOutlet UICollectionView *Coll_ShowUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Btn_changDayNight;
@property (strong, nonatomic)NSNumber* isHaveBobber;//是否有盗贼
@property (strong, nonatomic)NSNumber* robberSelect;//是否有盗贼
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *Tap_RobberSelect;
@property (strong, nonatomic) NSMutableArray* characterArr;
@end
