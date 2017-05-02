//
//  VCRobberSelect.m
//  wolfmen_killers
//
//  Created by wrongmean on 2017/5/1.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCRobberSelect.h"
#import "MBProgressHUD+MJ.h"
#import "VBeginCell.h"
@interface VCRobberSelect ()

@end

@implementation VCRobberSelect

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _Img_character1.image=[UIImage imageNamed:_name1 ];
     _Img_character2.image=[UIImage imageNamed:_name2 ];
}
- (IBAction)TapImg1:(id)sender {
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择角色" message:@"确认选择吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self retSelect:1];
   
        [_begain. characterArr setObject:_begain. character1 atIndexedSubscript:[_begain.robberNum intValue]];
    
        [[[_begain.cellArr objectAtIndex:[_begain.robberNum intValue]]Img_charactor] setImage:_begain.img1];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (IBAction)TapImg2:(id)sender {
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择角色" message:@"确认选择吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [_begain. characterArr setObject:_begain. character2 atIndexedSubscript:[_begain.robberNum intValue]];

        [[[_begain.cellArr objectAtIndex:[_begain.robberNum intValue]]Img_charactor] setImage:_begain.img2];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
-(void)retSelect:(int)select
{
    _begain.robberSelect=[NSNumber numberWithInt:select];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
