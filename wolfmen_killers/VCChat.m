
//
//  VCChat.m
//  wolfmen_killers
//
//  Created by wrongmean on 2017/6/5.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCChat.h"
#import "VChatCell.h"
#import "MBProgressHUD+MJ.h"
#import <AVFoundation/AVFoundation.h>
@implementation UIImage (Extension)

+ (UIImage *) resizableImage:(NSString *) imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    // 取图片中部的1 x 1进行拉伸
    UIEdgeInsets insets = UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2 + 1, image.size.width/2 + 1);
    return [image resizableImageWithCapInsets:insets];
}
@end
@interface VCChat ()
@property (strong,nonatomic)NSMutableArray* historyMsg;
@property (weak, nonatomic) IBOutlet UIToolbar *ToolBar_tool;
@property (weak, nonatomic) IBOutlet UINavigationItem *Title_name;
@property (weak, nonatomic) IBOutlet UITableView *Table_chat;
@property (weak, nonatomic) IBOutlet UITextField *Text_input;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Item_input;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Btn_emotionIcon;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Btn_add;
@property(strong,nonatomic)NSMutableArray* cellArr;
@property(strong,nonatomic)AVAudioRecorder* recoder;
@property(strong,nonatomic) AVAudioSession *session;
@property(strong,nonatomic)AVAudioPlayer* player;
@property (weak, nonatomic) IBOutlet UIButton *Btn_voice;
@property (strong, nonatomic)NSString *filePath;
@property (strong, nonatomic)NSMutableData *recvData;
@end

@implementation VCChat

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _Title_name.title=_friendName;
    msgType=text;
    _app=[[UIApplication sharedApplication] delegate];
    [_app.socket setDelegate:self];
    //[_app.socket set]
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"msg"])
    {
        _historyMsg=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"msg"]];
    }
    msgLen=-1;
    [_Table_chat setAllowsSelection:NO]; if(![self initRecoder])
        return;
    if(_historyMsg==nil)
        _historyMsg=[NSMutableArray arrayWithCapacity:1];
    [_app.socket readDataWithTimeout:-1 tag:200];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:_historyMsg forKey:@"msg"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)sendMsg:(messageFrame*)msg
{
    if(![_app.socket isConnected])
    {
        if(![_app.socket connectToHost:_app.socketHost onPort:_app.socketPort error:Nil])
        {
            return ;
        }
    }
    int cmd=7,len=0;//7 聊天
    NSMutableData *data =[NSMutableData dataWithBytes:&len length:4];
    [data appendData:[NSData dataWithBytes:&cmd length:4]];
    int userID=[_app.userId intValue];
    [data appendBytes:&userID length:4];
    [data appendBytes:&friendID length:4];
    [data appendBytes:&msgType length:4];
    if([msg.msgType intValue]==text)
        [data appendData:[_Text_input.text dataUsingEncoding:NSUTF8StringEncoding]];
    else if([msg.msgType intValue]==voice)
        [data appendData:msg.recorder];
    len=(int)data.length;
    [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:&len length:4];
    _Text_input.text=nil;
    [_app.socket writeData:data withTimeout:-1 tag:100];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_app.socket readDataWithTimeout:-1 tag:200];

}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [MBProgressHUD hideHUDForView:self.view];
    NSLog(@"消息发送成功");
}

-(void)recvMsg:(NSData*)data
{
    int _friendID;
    int type;
    [[data subdataWithRange:NSMakeRange(8, 4)] getBytes:&type length:4];
    [[data subdataWithRange:NSMakeRange(0, 4)] getBytes:&_friendID length:4];
    //非当前好友的信息
    if(_friendID!=friendID)
    {
        _app->ishaveMsg=YES;
        [_app.msgBuf addObject:data];
        return;
    }
    messageFrame* msg=[messageFrame alloc];
    msg.msgType=[NSNumber numberWithInt:type];
    msg.msgSender=[NSNumber numberWithInt:others];
    if(type==text){
        msg.msg=[[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(12, data.length-12)] encoding:NSUTF8StringEncoding];
    }
    else if(type==voice){
        msg.recorder=[NSData dataWithData:[data subdataWithRange:NSMakeRange(12, data.length-12)] ];
        msg.msg=@"语音";
    }
    [_historyMsg addObject:msg];
    [msg getDate];
    [_Table_chat reloadData];

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [_app.socket readDataWithTimeout:-1 tag:200];
    NSMutableData* tmp=nil;
    if(tag==200){
        int cmd=-1;
        if(msgLen!=-1)
        {
            [_recvData appendData:data];
            if(_recvData.length<msgLen)
            {
                return;
            }
            if(_recvData.length==msgLen)
            {
                msgLen=-1;
            }
            else{
                tmp=[NSMutableData dataWithData:[_recvData subdataWithRange:NSMakeRange(msgLen,_recvData.length-msgLen)]];
                _recvData=[NSMutableData dataWithData: [_recvData subdataWithRange:NSMakeRange(0, msgLen) ]];
                msgLen=(int)_recvData.length-msgLen;
            }
        }
        else{
            [[data subdataWithRange:NSMakeRange(0, 4)] getBytes:&msgLen length:4];
            if(msgLen>(int)data.length)
            {
                _recvData=[NSMutableData dataWithData:[data subdataWithRange:NSMakeRange(0, data.length)]];
                return;
            }
            msgLen=-1;
            _recvData=[NSMutableData dataWithData:[data subdataWithRange:NSMakeRange(0, data.length)]];
        }
         [[_recvData subdataWithRange:NSMakeRange(4, 4)] getBytes:&cmd length:4];
        if(cmd==0)
        {
            [MBProgressHUD showMessage:@"用户不在线！"toView:self.view ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
            
        }
        else if(cmd==7)
        {
            [self recvMsg:[_recvData subdataWithRange:NSMakeRange(8, _recvData.length-8)]];
        }
        else{
                       
        }
        if(tmp!=nil)
        {
            _recvData=[NSMutableData dataWithData:tmp];
        }
    }
    else{
    }
    
}
- (IBAction)pressMsgBtn:(id)sender {
    VChatCell* chat;
    for (UIView* next = [sender superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[VChatCell class]]) {
            chat =(VChatCell*) nextResponder;
            break;
        }
    }
    [self playRecorder:[_historyMsg[chat->index] recorder]];
}
 /** 点击拖曳聊天区的时候，缩回键盘 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
     // 1.缩回键盘
     [self.view endEditing:YES];
 }
-(void)scollToNewMsg
{
    // 滚动到最新的消息
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_historyMsg.count - 1 inSection:0];
    [_Table_chat scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
#pragma mark - 监听事件
//键盘回车事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    messageFrame* msg=[messageFrame alloc];
    msg.msgType=[NSNumber numberWithInt:msgType];
    msg.msgSender=[NSNumber numberWithInt:self_side];
    msg.msg=_Text_input.text;
    [msg getDate];
    [_historyMsg addObject:msg];
    [_Table_chat reloadData];
    [self sendMsg:msg];
    return YES;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    messageFrame* msg=[_historyMsg objectAtIndex:indexPath.row];
    NSLog(@"height=%f",msg->BtnSize.height+50);
    return msg->BtnSize.height+50;

}

- (void) keyboardWillChangeFrame:(NSNotification *) note {
     // 1.取得弹出后的键盘frame
     CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

     // 2.键盘弹出的耗时时间
     CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
 
     // 3.键盘变化时，view的位移，包括了上移/恢复下移
     CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;

     [UIView animateWithDuration:duration animations:^{
         self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
     }];
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _historyMsg.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_historyMsg.count==0)
        return nil;
    messageFrame* msg=_historyMsg[indexPath.row];
    VChatCell* cell=[VChatCell cellWithTableView:tableView];
    cell.Label_date.text=[NSString stringWithFormat:@"%@",msg.date ];
    [cell getMsgSize:msg];
    CGSize size=[[UIScreen mainScreen] bounds].size;
    
    if([msg.msgSender intValue]==self_side){
        [cell.Btn_msg setTitle:msg.msg forState:UIControlStateNormal];
        [cell.Btn_msg setFrame:CGRectMake(size.width-52-msg->BtnSize.width , cell.Btn_msg.frame.origin.y, msg->BtnSize.width,msg->BtnSize.height)];
        cell.Btn_msg.titleEdgeInsets=UIEdgeInsetsMake(4, 25, 4, 25);
        [cell.Btn_msg setBackgroundImage:[UIImage resizableImage:@"selfMsg"] forState:UIControlStateNormal];
        [cell.Img_head setFrame:CGRectMake(size.width-50 , cell.Img_head.frame.origin.y, 40,40)];
    }
    else{
        [cell.Btn_msg setTitle:msg.msg forState:UIControlStateNormal];
        [cell.Btn_msg setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cell.Btn_msg setBackgroundImage:[UIImage resizableImage:@"otherMsg"] forState:UIControlStateNormal];
        cell.Btn_msg.titleEdgeInsets=UIEdgeInsetsMake(4, 25, 4, 25);
        [cell.Btn_msg setFrame:CGRectMake(52 , cell.Btn_msg.frame.origin.y, msg->BtnSize.width,msg->BtnSize.height)];
        [cell.Btn_msg.titleLabel setTextColor:[UIColor blueColor]];
        [cell.Img_head setFrame:CGRectMake(10, cell.Img_head.frame.origin.y, 40,40)];
    }
    cell->index=(int)indexPath.row;
    [self scollToNewMsg];
    return cell;
}
-(BOOL)initRecoder
{
    NSArray
    *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取资源路径
    NSString *tmpDir =paths[0];
    _filePath = [NSString stringWithString:[tmpDir stringByAppendingPathComponent:@"1.caf"]];
    NSURL *fileURL = [NSURL fileURLWithPath:_filePath];
    _session = [AVAudioSession sharedInstance];
    [_session setActive:YES error:nil];
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
    [NSNumber numberWithFloat: 44100],AVSampleRateKey, //采样率
    [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
    [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
    [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,//通道的数目
    [NSNumber numberWithInt: AVAudioQualityMax],AVEncoderAudioQualityKey,//音频编码质量
    nil];
    NSError *error;
    _recoder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settings error:&error];

    if (_recoder) {
        //是否允许刷新电平表，默认是off
        _recoder.meteringEnabled = YES;
        _recoder.delegate = self;
        _recoder.meteringEnabled = YES;
        [_recoder prepareToRecord];
        return YES;
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
        return NO;
    }

}
- (IBAction)pressVoice:(id)sender {
    //_ToolBar_tool.
 //if([_Btn_voice state]=UIControlEventTouchDown)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    msgType=voice;
    //开始录音
    [_recoder record];
}

- (IBAction)outVoice:(id)sender {
    //录音停止
    [_recoder stop];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    messageFrame* msg=[messageFrame alloc];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    msg.recorder = [[NSData alloc] init];
    msg.recorder = [fileManager contentsAtPath:_filePath];
    msg.msgType=[NSNumber numberWithInt:msgType];
    msg.msg=@"语音";
     msg.msgSender=[NSNumber numberWithInt:self_side];
    [msg getDate];
    [_historyMsg addObject:msg];
    [_Table_chat reloadData];
    [self sendMsg:msg];
}

-(void)playRecorder :(NSData*) data
{
   
//    NSArray
//    *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *tmpDir =  paths[0];    NSString *filePath = [tmpDir stringByAppendingPathComponent:@"1.caf"];
//    
//    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
//    {
//        NSLog(@"??????");
//        return;
//    }
//    NSURL *fileURL = [NSURL fileURLWithPath:_filePath];
    
//    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&playerError];
    NSError* playerError=[NSError alloc];
    _player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:@"caf" error:&playerError];
    if (_player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }else{
        self.player.delegate = self;
        self.player.volume = 20;
        [_player play];
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // [self performSegueWithIdentifier:@"showHistory" sender:nil];
}
//编辑状态
-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//编辑状态 操作
-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
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


