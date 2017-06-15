//
//  NSObject+messageFrame.m
//  wolfmen_killers
//
//  Created by wrongmean on 2017/6/5.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "NSObject+messageFrame.h"

@implementation messageFrame: NSObject
-(void)getDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    _date = [date  dateByAddingTimeInterval: interval];
}

@end
