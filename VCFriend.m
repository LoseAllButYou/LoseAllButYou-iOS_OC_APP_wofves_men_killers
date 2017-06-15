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
#import "VCChat.h"
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
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getFriendList];
}
-(void)getFriendList
{
    [_app.socket setDelegate:self];
    if(![_app.socket isConnected])
    {
        if(![_app.socket connectToHost:_app.socketHost onPort:_app.socketPort error:Nil])
        {
            return ;
        }
    }

    
    if(_friendName.count!=0)
    {
        [_cellArr removeAllObjects];
        [_friendName removeAllObjects];
        curCellNum=0;
    }
    int cmd=3,len=0;//3 获取有好友列表
    NSMutableData *data =[NSMutableData dataWithBytes:&len length:4];
    [data appendData:[NSData dataWithBytes:&cmd length:4]];
    [data appendData:[_app.userName dataUsingEncoding:NSUTF8StringEncoding]];
    len=(int)data.length;
    [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:&len length:4];

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
                printf("%d\n",friendId[index]);
                ++index;
                friendNum++;
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
    if(data.length<8)
    {
        //好友消息
        return;
    }
    if(tag==200){
        int cmd=-1;
        [[data subdataWithRange:NSMakeRange(8, 4)] getBytes:&cmd length:4];
        if(cmd==0)
        {
             [_app.socket readDataWithTimeout:2  tag:400];
        }
        else{
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data subdataWithRange:NSMakeRange(8, data.length-8)]]toView:self.view ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
            });
            
        }
    }
    else if(tag==300){
        int cmd=-1;
        [[data subdataWithRange:NSMakeRange(8, 4)] getBytes:&cmd length:4];
        if(cmd==0)
        {
            [MBProgressHUD showMessage:@"删除成功"toView:self.view ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
        }
        else{
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data subdataWithRange:NSMakeRange(8, data.length-8)]]toView:self.view ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
            });
            
        }

    }
    else{
        [MBProgressHUD showMessage:@"正在刷新好友列表"toView:self.view ];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //            _name=[[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(4, data.length-4)] encoding:NSUTF8StringEncoding];
            [self saveFriendInfo:[data subdataWithRange:NSMakeRange(0,data.length)]];
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
    selectNum=(int)indexPath.row;
    [self performSegueWithIdentifier:@"chat" sender:nil];
}
//编辑状态
-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)deleteFriend:(int)index
{
    int cmd=6,len=0;//6 删除好友
    NSMutableData *data =[NSMutableData dataWithBytes:&len length:4];
    [data appendData:[NSData dataWithBytes:&cmd length:4]];
    [data appendData:[[NSString stringWithFormat:@"%d\n%d",[_app.userId intValue],friendId[index] ]dataUsingEncoding: NSUTF8StringEncoding]];
    len=(int)data.length;
    [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:&len length:4];
    // 发送消息 这里不需要知道对象的ip地址和端口
    [_app.socket writeData:data withTimeout:2 tag:100];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_app.socket readDataWithTimeout:2  tag:300];
}

//编辑状态 操作
-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [_cellArr removeObjectAtIndex:indexPath.row];

    int i=0;
    for(i=(int)indexPath.row;i<friendNum;++i)
    {
        if(friendId[i]==-1)
            ++i;
        else{
            break;
        }
    }
    [_friendName removeObjectAtIndex:indexPath.row];
    [self deleteFriend:i];
    friendId[i]=-1;
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqual:@"chat"])
    {
        VCChat* chat =[segue destinationViewController];
        chat->friendID=friendId[selectNum];
        chat.friendName=[_friendName objectAtIndex:selectNum];
    }
}


- (IBAction)pressStop:(id)sender {
}
@end
