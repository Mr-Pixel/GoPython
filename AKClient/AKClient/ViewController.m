//
//  ViewController.m
//  AFClient
//
//  Created by zqq张庆庆 on 2018/12/21.
//  Copyright © 2018 zqq张庆庆. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<GCDAsyncSocketDelegate>
@property (strong,nonatomic) GCDAsyncSocket *socket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}

- (void)initView{
    UIButton *connectBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 100, 40)];
    [connectBtn setTitle:@"Connect" forState:UIControlStateNormal];
    [connectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    connectBtn.layer.borderWidth = 1;
    connectBtn.layer.borderColor = [UIColor blackColor].CGColor;
    connectBtn.layer.cornerRadius = 5;
    [connectBtn addTarget:self action:@selector(clickToConnect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectBtn];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(connectBtn.frame)+20, 50, 100, 40)];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [UIColor blackColor].CGColor;
    sendBtn.layer.cornerRadius = 5;
    [sendBtn addTarget:self action:@selector(clickToSendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
}

- (void)clickToConnect{
    [self connectToServer];
}

- (void)clickToSendText{
    [_socket writeData:[@"ssss" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:0 tag:0];
}

#pragma socket

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
