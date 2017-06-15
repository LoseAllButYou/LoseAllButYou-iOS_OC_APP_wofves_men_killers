//
//  VChatCell.h
//  wolfmen_killers
//
//  Created by wrongmean on 2017/6/5.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+messageFrame.h"
@interface VChatCell : UITableViewCell
{
    float TEXT_INSET;
    @public
    int index;
}
@property (weak, nonatomic) IBOutlet UILabel *Label_date;
@property (weak, nonatomic) IBOutlet UIImageView *Img_head;
@property (weak, nonatomic) IBOutlet UIButton *Btn_msg;

@property (weak, nonatomic)messageFrame* msg;
- (CGSize)getMsgSize :(messageFrame*)msg;
+ (instancetype) cellWithTableView:(UITableView *) tableView;
-(VChatCell*)veiwController;
@end
