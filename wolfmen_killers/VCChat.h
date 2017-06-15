//
//  VCChat.h
//  wolfmen_killers
//
//  Created by wrongmean on 2017/6/5.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NSObject+messageFrame.h"
@interface VCChat : UIViewController
{
    int msgType;
    @public
    int friendID;
    int msgID;
    int msgLen;
}
@property(strong,nonatomic)AppDelegate* app;
@property(strong,nonatomic)NSString*friendName;
@end
