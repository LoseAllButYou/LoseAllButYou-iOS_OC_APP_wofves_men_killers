//
//  VCLogin.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCLogin.h"
#import "VCMain.h"
#import "MBProgressHUD+MJ.h"


//#import "VCMain.m"
@interface VCLogin ()

@property (weak, nonatomic) IBOutlet UITextField *Text_CAPTCHA;
@property (weak, nonatomic) IBOutlet UIImageView *Img_CAPTCHA;
@property (weak, nonatomic) IBOutlet UISwitch *Swch_saveInfo;
@property (weak, nonatomic) IBOutlet UIButton *Btn_login;
@property (weak, nonatomic) IBOutlet UILabel *Text_imgCAPTCHA;
@property (weak, nonatomic) IBOutlet UIImageView *Img_warning;
@property (weak, nonatomic) IBOutlet UILabel *Text_waring;


@end

@implementation VCLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pswdChange) name:UITextFieldTextDidBeginEditingNotification object:_Text_passWord];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidBeginEditingNotification object:_Text_loginName];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textCAPTCHAEChangeEnd) name:UITextFieldTextDidEndEditingNotification object:_Text_CAPTCHA];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textCAPTCHAEChange) name:UITextFieldTextDidChangeNotification object:_Text_CAPTCHA];
     isCAPTCHAEqual=NO;
     isFirst=YES;
    _app=[[UIApplication sharedApplication] delegate];
   
      _socket=_app.socket;
    //[NSThread sleepForTimeInterval:2.0];
     srand((unsigned)time(NULL));
     int num1=rand()%10;
     int num2=rand()%10;
     int num3=rand()%10;
     int num4=rand()%10;
//    if([[NSUserDefaults standardUserDefaults]boolForKey:@"save" ])
//    {
//        _Text_loginName.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"userName" ];
//        _Text_passWord.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"passWord" ];
//    }
     _Text_imgCAPTCHA.text=[NSString stringWithFormat:@"%d%d%d%d",num1,num2,num3,num4];
     _Text_imgCAPTCHA.tag=num1*1000+num2*100+num3*10+num4;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
     
}
-(void)autoLogin
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isAutoLogin"])
    {
        
        [MBProgressHUD showMessage:@"自动登录中！请大爷耐心等待！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //移除提示框遮盖
            [MBProgressHUD hideHUD];
            [self loginCheck];
        });
        
    }

}

- (IBAction)pressRegist:(id)sender {
    NSLog(@"123123123");
     [self performSegueWithIdentifier:@"regist" sender:nil];
    
}
//获取网络数据库验证
-(void)loginCheck
{
    if(![_app.socket isConnected])
    {
        if(![_app.socket connectToHost:_app.socketHost onPort:_app.socketPort error:Nil])
        {
            return ;
        }
    }
    NSString *s = @"";
    s=[s stringByAppendingString:[NSString stringWithFormat:@"%@\n%@",_Text_loginName.text,_Text_passWord.text]];
    int cmd=1,len=0;
    NSMutableData *data =[NSMutableData dataWithBytes:&len length:4];
     [data appendData:[NSData dataWithBytes:&cmd length:4]];
      [data appendData:[s dataUsingEncoding:NSUTF8StringEncoding]];
    len=(int)data.length;
    [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:&len length:4];
    // 开始发送
    [_app.socket setDelegate:self];
    [_app.socket setDelegateQueue:dispatch_get_main_queue()];
    // 发送消息 这里不需要知道对象的ip地址和端口
    [_socket writeData:data withTimeout:5 tag:100];
    [_socket readDataWithTimeout:5  tag:200];

}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"消息发送成功");
}

-(void)saveInfo :(NSData* )data
{
    NSString *s=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    int i=0,j=0;
    const char* str=[s UTF8String];
    char readBuf[128]={0};
    while(str[i])
    {
        if(str[i]=='\n')
        {
            readBuf[j]=0;
            j=0;
            _app.userId=[NSNumber numberWithInt:atoi(readBuf)];
            ++i;
        }
        readBuf[j++]=str[i++];
    }
    readBuf[j]=0;
    _name=[NSString stringWithUTF8String:readBuf];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if(tag==200){
        int cmd=-1;
        [[data subdataWithRange:NSMakeRange(8, 4)] getBytes:&cmd length:4];
        if(cmd==0)
        {
            [MBProgressHUD showMessage:@"用户名或密码错误" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        else if(cmd==1)
        {
           [_socket readDataWithTimeout:5  tag:300];
        }
        else{
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data subdataWithRange:NSMakeRange(8, data.length-8)]]toView:self.view ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
            });
        }
    }
    else{
        _app.userName=[NSString stringWithString:_Text_loginName.text];
        [MBProgressHUD showMessage:@"登录成功"toView:self.view ];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self saveInfo:[data subdataWithRange:NSMakeRange(0, data.length) ]];
            
            [self performSegueWithIdentifier:@"mainVC" sender:nil];
        });

    }
}

- (IBAction)pressLogin:(id)sender {
    [self loginCheck ];
}
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.view endEditing:YES];
    
}
- (IBAction)selectSave:(id)sender {
    //存储用户数据到本地 暂时只存一个
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"save"];
    [ud setObject:[_Text_loginName text] forKey:@"userName"];
    [ud setObject:[_Text_passWord text] forKey:@"passWord"];
}
- (IBAction)selectAutoLogin:(id)sender {
        NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
        [ud setBool: _Swch_isAutoLogin.isOn forKey:@"isAutoLogin"];
        if(![_Swch_saveInfo isOn]){
            [_Swch_saveInfo setOn:YES];
            [self selectSave:nil];
        }
  
}
-(void)pswdChange
{
     _Text_passWord.text=nil;
     _Text_passWord.keyboardType=UIKeyboardTypeASCIICapable;
     
     _Text_passWord.secureTextEntry=YES;
     
}
-(void)textCAPTCHAEChange
{
     _Img_warning.image=nil;
     _Text_waring.text=nil;
     
}
-(void)textCAPTCHAEChangeEnd
{
     isCAPTCHAEqual=(_Text_CAPTCHA.text.intValue==_Text_imgCAPTCHA.tag) ;
     NSLog(@"\n\nisCa=%i\n",isCAPTCHAEqual);
     if(!isCAPTCHAEqual)
     {
          UIImage* warning=[UIImage imageNamed:@"warning.png"];
          //_Img_warning.frame=CGRectMake(134, 312, 40, 40);
          _Img_warning.image=warning;
          _Text_waring.text=@"验证码错误";
          srand((unsigned)time(NULL));
         
          int num1=rand()%10;
          int num2=rand()%10;
          int num3=rand()%10;
          int num4=rand()%10;
          _Text_imgCAPTCHA.text=[NSString stringWithFormat:@"%d%d%d%d",num1,num2,num3,num4];
          _Text_imgCAPTCHA.tag=num1*1000+num2*100+num3*10+num4;
     }
     else
          [self textChange];
}
-(void)textChange
{
     _Btn_login.enabled=(self.Text_passWord.text.length&&self.Text_loginName.text.length&&isCAPTCHAEqual);

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
    
    //多个按钮需要 判断 准备前 segue.identifier 值
     //nextVC.Label_userName.text=_Text_loginName.text;
//     if([segue.identifier compare:@"mainVC"]==YES)
    
        if ([segue.identifier isEqualToString:@"mainVC"])
     {
         UINavigationController *nav = segue.destinationViewController;
         VCMain* nextVC = (VCMain *)nav.topViewController;
         nextVC.loginName=[NSString stringWithFormat:@"%@",_name];
         
     }
    if ([segue.identifier isEqualToString:@"regist"]){}
     
}

-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    if([ud valueForKey:@"isAutoLogin"]&&[ud valueForKey:@"save"])
    {
        _Text_loginName.text=[ud    objectForKey:@"userName"];
        _Text_passWord.text=[ud objectForKey:@"passWord"];
        [_Swch_saveInfo setOn:YES];
        if([ud boolForKey: @"isAutoLogin"]){
            [self autoLogin ];
            [_Swch_isAutoLogin setOn:YES];
        }
        else{
            [_Swch_isAutoLogin setOn:NO];
        }
        return;
    }
    if([ud valueForKey:@"save"])
    {
        if([ud boolForKey: @"save"]){
            _Text_loginName.text=[ud    objectForKey:@"userName"];
            _Text_passWord.text=[ud objectForKey:@"passWord"];
        }
        return;
    }

}

@end
