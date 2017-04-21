//
//  VCPrepare.h
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/15.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCPrepare : UIViewController

{
    NSInteger gameUserNum;
    NSInteger civilianNum;
    NSInteger werwolfNum;
}
@property (strong,nonatomic)NSMutableArray* nameArr;

@property (strong, nonatomic) IBOutlet UITextView *TextView_charactor;
@property (weak, nonatomic) IBOutlet UIButton *Btn_begainGame;

@end
