//
//  VCLogin.h
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCLogin : UIViewController
{
     BOOL isCAPTCHAEqual;
     BOOL isFirst;
}
@property (weak, nonatomic) IBOutlet UISwitch *Swch_isAutoLogin;
@end
