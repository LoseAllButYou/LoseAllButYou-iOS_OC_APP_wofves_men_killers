//
//  VCHistory.h
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/16.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCHistory : UIViewController
{
    int historyNum;
    int selectedNum;
    
}
@property(strong,nonatomic) NSUserDefaults* ud;
@property(strong,nonatomic) NSMutableArray* historyArr;
@property(strong,nonatomic) NSMutableArray* historyDate;
@property(strong,nonatomic) NSMutableArray* cellArr;
@end
