//
//  VCFriend.h
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/15.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface VCFriend : UIViewController
{
    int friendId[1024];
    int curCellNum;
    int friendNum;
    int selectNum;
}
@property (weak, nonatomic) IBOutlet UITableView *table_friendList;
@property(strong,nonatomic)AppDelegate* app;
@property(strong,nonatomic)GCDAsyncSocket* socket;
@end
