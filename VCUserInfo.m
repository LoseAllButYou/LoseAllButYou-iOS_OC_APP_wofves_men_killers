//
//  VCUserInfo.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/13.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCUserInfo.h"

@interface VCUserInfo ()

@end

@implementation VCUserInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.frame=CGRectMake(40, 600, 300, 400);
     self.view.backgroundColor=[UIColor blueColor];
     
     UIView* v=[[UIView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
     v.backgroundColor=[UIColor redColor];
     [self.view addSubview:v];
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
