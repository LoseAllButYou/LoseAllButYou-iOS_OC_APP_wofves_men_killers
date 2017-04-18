//
//  NSObject+DBPart.h
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/17.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface DBPart:NSObject
{
    FMDatabase* db;
    NSString* strPath;
}
//数据库操作定义
-(BOOL)openOrCreatDB:(NSString*)path;
-(BOOL)openDB;
-(BOOL)insertData:(NSString*)sqlQuery;
-(BOOL)deleteData:(NSString*)sqlQuery ;
-(BOOL)closeDB;

-(FMResultSet*)selectAllFromDB:(NSString*)sqlQuery;

@end
