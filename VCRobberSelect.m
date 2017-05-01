//
//  VCRobberSelect.m
//  wolfmen_killers
//
//  Created by wrongmean on 2017/5/1.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCRobberSelect.h"
#import "MBProgressHUD+MJ.h"

@interface VCRobberSelect ()

@end

@implementation VCRobberSelect

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)TapImg1:(id)sender {
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择角色" message:@"确认选择吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self retSelect:1];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}
- (IBAction)TapImg2:(id)sender {
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择角色" message:@"确认选择吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self retSelect:2];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
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
