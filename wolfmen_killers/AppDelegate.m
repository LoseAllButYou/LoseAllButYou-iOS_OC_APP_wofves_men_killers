//
//  AppDelegate.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     // Override point for customization after application launch.
    _msgBuf=[NSMutableArray arrayWithCapacity:1];
    ishaveMsg=NO;
    // _socketHost=@"192.168.2.104";
    _socketHost=@"123.207.58.25";
    _socketPort=8080;
     [NSThread sleepForTimeInterval:2.0];
    [self createClientTcpSocket];
    
    return YES;
}
- (void) createClientTcpSocket {

    // 1. 创建一个 socket用来和服务端进行通讯
     dispatch_queue_t dQueue = dispatch_queue_create("socket", NULL);
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue() socketQueue:dQueue ];
    // 2. 连接服务器端. 只有连接成功后才能相互通讯 如果60s连接不上就出错
    if(![_socket connectToHost:_socketHost onPort:_socketPort error:nil])
    {
        NSLog(@"lianjie失败");
    }
    // 连接必须服务器在线
}

- (void)applicationWillResignActive:(UIApplication *)application {
     // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
     // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
     // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
     // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
     // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
