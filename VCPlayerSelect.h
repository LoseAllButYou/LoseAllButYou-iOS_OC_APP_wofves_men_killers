//
//  VCPlayerSelect.h
//  wolfmen_killers
//
//  Created by wrongmean on 2017/4/25.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCPlayerSelect : UIViewController
{
    int curCharacterNum;
    
}
@property (strong, nonatomic) NSDictionary* characterInfo;
@property (strong, nonatomic) NSMutableArray* freedomArr;
@property (strong, nonatomic) NSMutableArray* mutArr_characterName;
@property (strong, nonatomic) NSMutableArray* mutArr_characterImg;
@end
