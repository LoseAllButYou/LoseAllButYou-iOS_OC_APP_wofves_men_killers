
//
//  VCRegist.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCRegist.h"
#import "MBProgressHUD+MJ.h"
#import "VCLogin.h"

@interface VCRegist ()
@property (weak, nonatomic) IBOutlet UITextField *Text_userName;
@property (weak, nonatomic) IBOutlet UITextField *Text_pswd;
@property (weak, nonatomic) IBOutlet UITextField *Text_confirmPswd;
@property (weak, nonatomic) IBOutlet UITextField *Text_name;
@property (weak, nonatomic) NSString* name;
@end

@implementation VCRegist

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _app=[[UIApplication sharedApplication] delegate];
    [_app.socket setDelegate:self];
    [_app.socket setDelegateQueue:dispatch_get_main_queue()];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressRegister:(id)sender {
    if(![_Text_pswd.text isEqualToString:_Text_confirmPswd.text])
    {
        [MBProgressHUD showError:@"两次密码不一样请重新输入"];
        _Text_pswd.text=nil;
        _Text_confirmPswd.text=nil;
        return;
    }
    if([_Text_name.text isEqualToString:@""]||[[_Text_pswd text] isEqualToString:@""]||[[_Text_confirmPswd text] isEqualToString:@""]||[_Text_userName.text isEqualToString:@""])
    {
        [MBProgressHUD showError:@"所填项目不能为空"];

        return;
    }
    [self registCheck];
 
}
-(void)registCheck
{
    if(![_app.socket isConnected])
    {
        if(![_app.socket connectToHost:_app.socketHost onPort:_app.socketPort error:Nil])
        {
            return ;
        }
    }

    NSString *s = @"";
    s=[NSString stringWithFormat:@"%@\n%@\n%@",_Text_userName.text,_Text_pswd.text,_Text_name.text];
    int cmd=2,len=0;
    NSMutableData *data =[NSMutableData dataWithBytes:&len length:4];
    [data appendData:[NSData dataWithBytes:&cmd length:4]];
    [data appendData:[s dataUsingEncoding:NSUTF8StringEncoding]];
    len=(int)data.length;
    [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:&len length:4];

    // 发送消息 这里不需要知道对象的ip地址和端口
    [_app.socket writeData:data withTimeout:5 tag:100];
     [_app.socket readDataWithTimeout:-1  tag:200];
}

#pragma mark - 消息发送成功 代理函数
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"消息发送成功");
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    int cmd=-1;
    [[data subdataWithRange:NSMakeRange(8,4)] getBytes:&cmd length:4];
    if(cmd==0)
    {
        [MBProgressHUD showMessage:@"用户名已存在" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
    }
    else if(cmd==1)
    {
        [MBProgressHUD showMessage:@"注册成功" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view];
            [self performSegueWithIdentifier:@"login" sender:nil];
        });
        
    }
    else{
        [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@",[data subdataWithRange:NSMakeRange(8, data.length-8)]] toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
        
    }

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"login"])
    {
        
        VCLogin* nextVC = (VCLogin *)segue.destinationViewController;
        nextVC.Text_loginName.text=[NSString stringWithFormat:@"%@",_Text_name.text];
        nextVC.Text_passWord.text=[NSString stringWithFormat:@"%@",_Text_pswd.text];
        nextVC.name=[NSString stringWithFormat:@"%@",_Text_name.text];
    }

}


@end
