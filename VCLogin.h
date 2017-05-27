//
//  VCLogin.h
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface VCLogin : UIViewController
{
     BOOL isCAPTCHAEqual;
     BOOL isFirst;
  
}
@property (weak, nonatomic) IBOutlet UISwitch *Swch_isAutoLogin;
@property (weak, nonatomic)  AppDelegate* app;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) IBOutlet UITextField *Text_loginName;
@property (strong, nonatomic) IBOutlet UITextField *Text_passWord;
@property (weak, nonatomic) GCDAsyncSocket* socket;
@end
