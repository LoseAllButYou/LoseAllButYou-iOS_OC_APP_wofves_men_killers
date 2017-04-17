//
//  VCHelp.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/16.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCHelp.h"

@interface VCHelp ()
@property (weak, nonatomic) IBOutlet UIWebView *Web_helpPage;
@property (weak, nonatomic) IBOutlet UITextField *Text_url;

@end

@implementation VCHelp

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pressUrl) name:UITextFieldTextDidBeginEditingNotification object:_Text_url];
}
- (IBAction)press:(id)sender {
    NSLog(@"wojinlaile   !\n");
     //NSURL *url = [NSURL URLWithString:_Text_url.text];
     NSURL *url = [NSURL URLWithString:@"www.baidu.com"];
     NSURLRequest *req = [NSURLRequest requestWithURL:url];
     [_Web_helpPage loadRequest:req];

}

-(void)pressUrl
{
    _Text_url.text=nil;
    _Text_url.text=self.Text_url.text;
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
