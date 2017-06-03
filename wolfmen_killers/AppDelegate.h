//
//  AppDelegate.h
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/8.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)GCDAsyncSocket  *socket;//socket
@property (strong, nonatomic)NSString* userName;//全局的用户账号
@property (strong, nonatomic)NSNumber* userId;//全局的用户id
@property (nonatomic, strong  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot//

- (void) createClientTcpSocket ;

@end

