//
//  VCBegain.h
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCBegain : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *Title_Info;
@property (weak, nonatomic) IBOutlet UICollectionView *Coll_ShowUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Btn_changDayNight;
@property (weak, nonatomic) IBOutlet UITextView *Text_showAction;

@property (strong, nonatomic) NSMutableDictionary* mutDic_userSelect;
@end
