//
//  VCHistory.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/16.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCHistory.h"
#import "VHistoryCell.h"
#import "VCShowHistory.h"

@interface VCHistory ()
@property (weak, nonatomic) IBOutlet UITableView *Table_history;

@end

@implementation VCHistory

- (void)viewDidLoad {
    [super viewDidLoad];
    _ud=[NSUserDefaults standardUserDefaults];
    _historyArr=[[_ud objectForKey:@"historyArr"] mutableCopy];
    _historyDate=[[_ud objectForKey:@"historyDate"] mutableCopy];
    _cellArr=[NSMutableArray arrayWithCapacity:1];
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_historyDate==nil)
        return 1;
    return _historyDate.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"Cell";
  
    VHistoryCell *cell;
    if(_cellArr.count<_historyDate.count||_historyDate==nil){
        cell=(VHistoryCell*)[tableView dequeueReusableCellWithIdentifier:ident];
        [_cellArr addObject:cell];
        if(_historyDate==nil)
        {

            cell.Lable_historyInfo.text=[NSString stringWithFormat:@"还没有历史记录，快点去体验吧！"];
            cell.userInteractionEnabled=NO;
        }
        else
            cell.Lable_historyInfo.text=[NSString stringWithFormat:@"%@",[_historyDate objectAtIndex:(int)indexPath.row]];
        
        return cell;
    }
    else
        return [_cellArr objectAtIndex:(int)indexPath.row];
  
}

//选中某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedNum=(int)indexPath.row;
    [self performSegueWithIdentifier:@"showHistory" sender:nil];
}
//编辑状态
-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//编辑状态 操作
-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [_cellArr removeObjectAtIndex:(int)indexPath.row];
    [_historyArr removeObjectAtIndex:(int)indexPath.row];
    [_historyDate removeObjectAtIndex:(int)indexPath.row];
    [_ud setObject:_historyDate forKey:@"historyDate"];
    [_ud setObject:_historyArr forKey:@"historyArr"];
    [_ud synchronize ];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
    [self reloadInputViews];
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
    if([segue.identifier isEqualToString:@"showHistory"]){
        VCShowHistory* show=segue.destinationViewController;
        
        show.history= [_historyArr objectAtIndex:selectedNum];
        show.date=[NSString stringWithFormat:@"%@",[_historyDate objectAtIndex:selectedNum]];
    }
}


@end
