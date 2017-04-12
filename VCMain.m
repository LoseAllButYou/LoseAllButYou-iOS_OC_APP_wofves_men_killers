//
//  VCMain.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/9.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCMain.h"

@interface VCMain ()
@property (weak, nonatomic) IBOutlet UIButton *crearButton;
@property (weak, nonatomic) IBOutlet UIImageView *Img_headImg;
@property (assign, nonatomic) IBOutlet UILabel *Label_userName;
@property (weak, nonatomic) IBOutlet UIView *View_userInfo;
@property (weak, nonatomic) IBOutlet UIImageView *Img_userInfoBackground;

@end

@implementation VCMain

- (void)viewDidLoad {
    [super viewDidLoad];

    self.crearButton.titleLabel.numberOfLines = 0;
     self.loginName=nil;
     //_Label_userName.text=self.loginName;
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
