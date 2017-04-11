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
@interface VCLogin ()
@property (weak, nonatomic) IBOutlet UITextField *Text_loginName;
@property (weak, nonatomic) IBOutlet UITextField *Text_passWord;
@property (weak, nonatomic) IBOutlet UITextField *Text_CAPTCHA;
@property (weak, nonatomic) IBOutlet UIImageView *Img_CAPTCHA;
@property (weak, nonatomic) IBOutlet UISwitch *Swch_saveInfo;
@property (weak, nonatomic) IBOutlet UIButton *Btn_login;
@property (weak, nonatomic) IBOutlet UIButton *Btn_regist;
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
     //连接数据库  未定义
     [_Btn_login addTarget:self action:@selector(pressLogin) forControlEvents:UIControlEventTouchUpInside];
     [_Btn_regist addTarget:self action:@selector(pressRegist) forControlEvents:UIControlEventTouchUpInside];
     srand((unsigned)time(NULL));
     int num1=rand()%10;
     int num2=rand()%10;
     int num3=rand()%10;
     int num4=rand()%10;
     _Text_imgCAPTCHA.text=[NSString stringWithFormat:@"%d%d%d%d",num1,num2,num3,num4];
     _Text_imgCAPTCHA.tag=num1*1000+num2*100+num3*10+num4;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
     
}
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.view endEditing:YES];
    
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
     if(isFirst)
     {
          _Text_loginName.text=nil;
          isFirst=NO;
     }
    // _Btn_login.enabled=YES;
}
-(void)pressLogin
{
     if([self.Text_passWord.text isEqualToString: @"123" ] &&[self.Text_loginName.text isEqualToString: @"123"])
     {
          //下载开源MBProgressHUD 库 便捷提示框
          NSLog(@"\nlogin success!!!\n");
          //获取网络数据库验证
          [MBProgressHUD showMessage:@"努力加载中！请大爷耐心等待！"];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               //移除提示框遮盖
               [MBProgressHUD hideHUD];
               [self performSegueWithIdentifier:@"mainVC" sender:nil];
          });
     }
     else
     {
          [MBProgressHUD showError:@"用户名或密码错误！请重新输出!!!"];
          return ;
     }
}
-(void)pressRegist
{
    // [self performSegueWithIdentifier:@"registVC" sender:nil];
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
     VCMain* nextVC=segue.destinationViewController;
     
     //nextVC.loginName=_Text_loginName.text;
}


@end
