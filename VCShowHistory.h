//
//  VCShowHistory.h
//  wolfmen_killers
//
//  Created by wrongmean on 2017/5/14.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCShowHistory : UIViewController
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSString* history;
@property (strong, nonatomic) IBOutlet UILabel *label_date;

@property (strong, nonatomic) IBOutlet UITextView *Text_history;

@end
