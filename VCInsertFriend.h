//
//  VCInsertFriend.h
//  wolfmen_killers
//
//  Created by wrongmean on 2017/6/3.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface VCInsertFriend : UIViewController
{
    int userId[1024];
    int curCellNum;
    int selectNum;
}
@property(strong,nonatomic)AppDelegate* app;
@end
