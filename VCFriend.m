//
//  VCFriend.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/15.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCFriend.h"
#import "VCMain.h"
#import "MBProgressHUD+MJ.h"
#import "VFriendCell.h"

@interface VCFriend ()

@property(strong,nonatomic)NSMutableArray* friendName;
@property(strong,nonatomic)NSMutableArray* cellArr;
@end

@implementation VCFriend

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _app=[[UIApplication sharedApplication] delegate];
    _cellArr=[NSMutableArray arrayWithCapacity:1];
    _friendName=[NSMutableArray arrayWithCapacity:1];
    _socket=_app.socket;
    [_app.socket setDelegate:self];
    [self getFriendList];
}
-(void)getFriendList
{
    int cmd=3;//3 获取有好友列表
    NSMutableData *data =[NSMutableData dataWithBytes:&cmd length:4];
    [data appendData:[_app.userName dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 发送消息 这里不需要知道对象的ip地址和端口
    [_app.socket writeData:data withTimeout:2 tag:100];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_app.socket readDataWithTimeout:2  tag:200];
}

//保存好友信息
-(void)saveFriendInfo :(NSData* )data
{
    NSString *s=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    int i=0,j=0;
    int k=0;
    int index=0;
    const char* str=[s UTF8String];
    char readBuf[128]={0};
    while(str[i])
    {
        if(str[i]=='\n'){
            readBuf[k]=0;
            k=0;
            if(j==0){
                friendId[index]= atoi(readBuf);
                ++index;
                printf("%d\n",friendId[index]);
            }
            else{
                [_friendName addObject:[NSString stringWithUTF8String:readBuf]];
            }
            ++j;
        }
        else{
            readBuf[k]=str[i];
            ++k;
        }
        j%=2;
        ++i;
    }
    readBuf[k]=0;
    [_friendName addObject:[NSString stringWithUTF8String:readBuf]];
    [_table_friendList reloadData];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"消息发送成功");
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [MBProgressHUD hideHUDForView:self.view];
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到服务器返回的数据 tcp [%@:%d] %@", ip, port, s);
    
    int cmd=-1;
    [[data subdataWithRange:NSMakeRange(0, 4)] getBytes:&cmd length:4];
    if(cmd==0)
    {
        [MBProgressHUD showMessage:@"正在刷新好友列表"toView:self.view ];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //            _name=[[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(4, data.length-4)] encoding:NSUTF8StringEncoding];
            [self saveFriendInfo:[data subdataWithRange:NSMakeRange(4,data.length-4)]];
        });

    }
    else if(cmd==1)
    {
        
    }
    else{
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data subdataWithRange:NSMakeRange(4, data.length-4)]]toView:self.view ];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _friendName.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"cell";
    if(_friendName.count==0)
        return nil;
    if(curCellNum==_cellArr.count&&curCellNum!=0)
    {
        return _cellArr[indexPath.row];
    }
    VFriendCell* cell=(VFriendCell*)[tableView dequeueReusableCellWithIdentifier:ident];
    cell.Text_friend.text=[NSString stringWithString:_friendName[indexPath.row]];
    [_cellArr addObject:cell];
    return cell;
}

//选中某行
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
       [self reloadInputViews];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pressStop:(id)sender {
}
@end
