//
//  VCInsertFriend.m
//  wolfmen_killers
//
//  Created by wrongmean on 2017/6/3.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCInsertFriend.h"
#import "VFriendCell.h"
#import "MBProgressHUD+MJ.h"

@interface VCInsertFriend ()
@property (weak, nonatomic) IBOutlet UITableView *Table_search;
@property (weak, nonatomic) IBOutlet UISearchBar *Search_name;
@property(strong,nonatomic)NSMutableArray* userName;
@property(strong,nonatomic)NSMutableArray* cellArr;
@end

@implementation VCInsertFriend

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _app=[[UIApplication sharedApplication] delegate];
    _cellArr=[NSMutableArray arrayWithCapacity:1];
    _userName=[NSMutableArray arrayWithCapacity:1];
    [_app.socket setDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//已经结束编辑的回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;  
{
    if(![_app.socket isConnected])
    {
        if(![_app.socket connectToHost:_app.socketHost onPort:_app.socketPort error:Nil])
        {
            return ;
        }
    }
    curCellNum=0;
    [_userName removeAllObjects];
    [_Table_search reloadData];
    NSLog(@"send msg");
    int cmd=4,len=0;//4 搜索好友列表
    NSMutableData *data =[NSMutableData dataWithBytes:&len length:4];
    [data appendData:[NSData dataWithBytes:&cmd length:4]];
    [data appendData:[searchBar.text  dataUsingEncoding:NSUTF8StringEncoding]];
    len=(int)data.length;
    [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:&len length:4];

    // 发送消息 这里不需要知道对象的ip地址和端口
    [_app.socket writeData:data withTimeout:2 tag:100];
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
                userId[index]= atoi(readBuf);
                printf("readbuf=%s\n",readBuf);
                ++index;
            }
            else{
                [_userName addObject:[NSString stringWithUTF8String:readBuf]];
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
    [_userName addObject:[NSString stringWithUTF8String:readBuf]];
    [_Table_search reloadData];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [MBProgressHUD hideHUDForView:self.view];
    NSLog(@"消息发送成功");
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if(tag==200){
        int cmd=-1;
        [[data subdataWithRange:NSMakeRange(8, 4)] getBytes:&cmd length:4];
        if(cmd==0)
        {
            [MBProgressHUD showMessage:@"未找到该用户"toView:self.view ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
               
            });
            
        }
        else if(cmd==1)
        {
            [_app.socket readDataWithTimeout:2  tag:400];
            
        }
        else{
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"未知错误"]toView:self.view ];
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
            [MBProgressHUD showMessage:@"添加成功"toView:self.view ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
        }
        else
        {
            [MBProgressHUD showMessage:@"添加失败"toView:self.view ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });

        }

    }
    else
        [self saveFriendInfo:data];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _userName.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"cell";
    if(_userName.count==0)
        return nil;
    if(curCellNum==_cellArr.count&&curCellNum!=0)
    {
        return _cellArr[indexPath.row];
    }
    VFriendCell* cell=(VFriendCell*)[tableView dequeueReusableCellWithIdentifier:ident];
    cell.Text_friend.text=[NSString stringWithString:_userName[indexPath.row]];
    [_cellArr addObject:cell];
    return cell;
}
- (IBAction)pressInsert:(id)sender {
    //发送添加好友
    int cmd=5;//5 添加好友
    NSMutableData *data =[NSMutableData dataWithBytes:&cmd length:4];
    [data appendData:[[NSString stringWithFormat:@"%d\n%d",[_app.userId intValue],userId[selectNum] ]dataUsingEncoding: NSUTF8StringEncoding]];
    
    // 发送消息 这里不需要知道对象的ip地址和端口
    [_app.socket writeData:data withTimeout:2 tag:100];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_app.socket readDataWithTimeout:2  tag:300];

}

//选中某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[_cellArr[indexPath.row] Btn_insertFriend] setHidden:NO];
    selectNum=(int)indexPath.row;
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

@end
