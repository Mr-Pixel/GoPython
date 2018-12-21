//
//  ViewController.m
//  AFClient
//
//  Created by zqq张庆庆 on 2018/12/21.
//  Copyright © 2018 zqq张庆庆. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()
@property (strong,nonatomic) GCDAsyncSocket *socket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self connectToServer];
}

- (void)connectToServer{
    // 1.与服务器通过三次握手建立连接
    NSString *host = @"10.32.24.23";
    int port = 5389;
    
    //创建一个socket对象
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                         delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    // 开始连接
    NSError *error = nil;
    [_socket connectToHost:host
                    onPort:port
                     error:&error];
    if (error) {
        NSLog(@"===============%@",error);
    }
}


#pragma mark - Socket代理方法
// 连接成功
- (void)socket:(GCDAsyncSocket *)sock
didConnectToHost:(NSString *)host
          port:(uint16_t)port {
    NSLog(@"===============%s",__func__);
}


// 断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock
                  withError:(NSError *)err {
    if (err) {
        NSLog(@"===============连接失败");
    } else {
        NSLog(@"===============正常断开");
    }
}


// 发送数据
- (void)socket:(GCDAsyncSocket *)sock
didWriteDataWithTag:(long)tag {
    
    NSLog(@"===============%s",__func__);
    
    //发送完数据手动读取，-1不设置超时
    [sock readDataWithTimeout:-1
                          tag:tag];
}

// 读取数据
-(void)socket:(GCDAsyncSocket *)sock
  didReadData:(NSData *)data
      withTag:(long)tag {
    
    NSString *receiverStr = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
    
    NSLog(@"===============%s %@",__func__,receiverStr);
}



@end
