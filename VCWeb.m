//
//  VCWeb.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/17.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCWeb.h"

@interface VCWeb ()
@property (weak, nonatomic) IBOutlet UIWebView *Web_helpPage;
@property (weak, nonatomic) IBOutlet UITextField *Text_url;
@end

@implementation VCWeb

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pressUrl) name:UITextFieldTextDidBeginEditingNotification object:_Text_url];
}
- (IBAction)press:(id)sender {
     if(![_Text_url.text hasPrefix:@"https://"] )
     {
          _Text_url.text=[NSString stringWithFormat:@"https://%@",_Text_url.text];
     }
     NSLog(@"%@",_Text_url.text);
     NSURL *url = [NSURL URLWithString:_Text_url.text];
     //NSURL *url = [NSURL URLWithString:@"www.baidu.com"];
     NSURLRequest *req = [NSURLRequest requestWithURL:url];
     [_Web_helpPage loadRequest:req];
     
}

-(void)pressUrl
{
     _Text_url.text=nil;
     //_Text_url.text=self.Text_url.text;
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
