//
//  VChatCell.m
//  wolfmen_killers
//
//  Created by wrongmean on 2017/6/5.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VChatCell.h"

@implementation NSString (Extension)

/** 测量文本的尺寸 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName: font};
    CGSize size =  [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    return size;
}

@end
@implementation VChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 构造方法
// 自定义构造方法
+ (instancetype) cellWithTableView:(UITableView *) tableView {
    static NSString *ID = @"cell";
    
    // 使用缓存池
    VChatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 创建一个新的cell
    if (nil == cell) {
        cell = [[VChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}
-(CGSize)getMsgSize :(messageFrame*)msg
{
    TEXT_INSET=20;//行间距
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize textMaxSize = CGSizeMake(screenWidth - 120 , MAXFLOAT);
    // 3.2 计算文本真实尺寸

    CGSize textSize= [msg.msg sizeWithFont:[UIFont systemFontOfSize:18]maxSize:textMaxSize];
    // 3.3 按钮尺寸
   
    CGSize btnSize= CGSizeMake(textSize.width + TEXT_INSET*2+10, textSize.height + TEXT_INSET*2);
    msg->BtnSize=btnSize;
    msg->msgSize=textSize;
    return textSize;
}
-(VChatCell*)veiwController
{
    return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
