//
//  NSObject+messageFrame.h
//  wolfmen_killers
//
//  Created by wrongmean on 2017/6/5.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#define self_side 0
#define others 1
typedef NS_ENUM(int,messageType)  {
    voice,
    text,
    icon,
    other,
};

@interface messageFrame:NSObject
{
    @public
    CGSize msgSize;
@public
    CGSize BtnSize;
}
@property(strong,nonatomic)NSString* msg;
@property(strong,nonatomic)NSData* recorder;
@property(strong,nonatomic)NSDate* date;
@property(strong,nonatomic)NSNumber* msgSender;
@property(strong,nonatomic)NSNumber* msgType;
-(void)getDate;
@end
