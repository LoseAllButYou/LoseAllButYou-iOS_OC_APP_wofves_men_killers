//
//  VBeginCell.h
//  wolfmen_killers
//
//  Created by wrongmean on 2017/4/26.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VBeginCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *Img_selected;
@property (strong, nonatomic) IBOutlet UILabel *Label_num;
@property (strong, nonatomic) IBOutlet UIImageView *Img_numBack;
@property (strong, nonatomic) IBOutlet UIImageView *Img_headImg;
@property (strong, readwrite) IBOutlet UIImageView *Img_charactor;
@property (weak, nonatomic) IBOutlet UIImageView *Img_sheriff;

@end
