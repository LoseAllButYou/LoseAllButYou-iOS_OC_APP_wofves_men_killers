//
//  VCMain.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/9.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCMain.h"
#import "VCUserInfo.h"
@interface VCMain ()

@property (weak, nonatomic) IBOutlet UIButton *crearButton;
@property (weak, nonatomic) IBOutlet UIImageView *Img_headImg;
@property (assign, nonatomic) IBOutlet UILabel *Label_userName;

@end

@implementation VCMain

- (void)viewDidLoad {
    [super viewDidLoad];

    self.crearButton.titleLabel.numberOfLines = 0;
    //界面载入时 通过上层界面传入的loginName值 读数据库取用户名
    //未shixian
     _Label_userName.text=self.loginName;
}
- (IBAction)tapHeadImg:(id)sender {
    
    [self showInfo:(_Label_userName.text)];
     
}
- (IBAction)tapMainBackground:(id)sender {
    
}
//查询 玩家信息
-(void)showInfo:(NSString*)userName
{
    //查询服务器数据库
    //UIPopoverPresentationController* userInfo=[[UIPopoverPresentationController alloc]initWithPresentedViewController: presentingViewController:self];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     if ([segue.identifier  isEqual: @"userInfoWin"]) {
          VCUserInfo* userInfo = segue.destinationViewController ;
          userInfo .modalPresentationStyle = UIModalPresentationPopover;
          userInfo .popoverPresentationController.delegate = self;
          //[self.view addSubview:userInfo.view];
     }
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
     return UIModalPresentationNone;
}

@end
