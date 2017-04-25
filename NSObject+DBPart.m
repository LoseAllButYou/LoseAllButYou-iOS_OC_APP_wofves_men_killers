//
//  NSObject+DBPart.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/17.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "NSObject+DBPart.h"
#import "sqlite3.h"
#import "FMDatabase.h"
@implementation DBPart:NSObject

-(BOOL)openOrCreatDB:(NSString*)path
{
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"wolfmen_killer_DB" ofType:@"db"];
    //strPath=[NSHomeDirectory() stringByAppendingString:path];
    NSLog(@"resourcepath==%@",resourcePath);
    db=[FMDatabase databaseWithPath:resourcePath];
    if(db)
        return YES ;
    return NO;
}
-(BOOL)openDB
{
    if([db open])
        return YES;
    else if([db lastErrorCode]==14)
    {
        return [db open];
    }
    else
        return NO;
}

-(BOOL)insertData:(NSString*)sqlQuery
{
    if([db executeUpdate:sqlQuery])
        return YES;
    else
        return NO;
}
-(BOOL)deleteData:(NSString*)sqlQuery
{
    if([db executeUpdate:sqlQuery])
        return YES;
    else
        return NO;
}
-(BOOL)closeDB
{
    return [db close];
}

-(FMResultSet*)selectAllFromDB:(NSString*)sqlQuery
{
     FMResultSet* ret=[db executeQuery:sqlQuery];
     NSLog(@"%@",ret);
     NSLog(@"ret num=%d",ret.columnCount);
    return ret;
}

@end
