//
//  VCRobberSelect.h
//  wolfmen_killers
//
//  Created by wrongmean on 2017/5/1.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCBegain.h"
@class VCBegain;
@interface VCRobberSelect : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *Img_character1;
@property (strong, nonatomic) IBOutlet UIImageView *Img_character2;
@property (strong, nonatomic) NSString* name1;
@property (strong, nonatomic) NSString* name2;
@property (weak, nonatomic) VCBegain* begain;

@end
