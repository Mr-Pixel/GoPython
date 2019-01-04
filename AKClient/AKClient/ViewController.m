//
//  ViewController.m
//  AFClient
//
//  Created by zqq张庆庆 on 2018/12/21.
//  Copyright © 2018 zqq张庆庆. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

UIButton* creatButton(NSString* title, CGRect frame, id target, SEL selector){
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:frame];
    [sendBtn setTitle:title forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [UIColor blackColor].CGColor;
    sendBtn.layer.cornerRadius = 5;
    [sendBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return sendBtn;
};

@interface ViewController ()<GCDAsyncSocketDelegate>
@property (strong,nonatomic) GCDAsyncSocket *socket;
@property (strong,nonatomic) UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    [self.view addSubview:creatButton(@"Connect", CGRectMake(20, 50, 100, 40), self, @selector(clickToConnect))];
    [self.view addSubview:creatButton(@"Disconnect", CGRectMake(20, 120, 100, 40), self, @selector(clickToDisConnect))];
    [self.view addSubview:creatButton(@"Send", CGRectMake(20, 180, 100, 40), self, @selector(clickToSendText))];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(140, 50, self.view.bounds.size.width-160, 200)];
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    _textView.layer.cornerRadius = 5;
    _textView.backgroundColor = [UIColor lightTextColor];
    _textView.text = @"Client Send Text:";
    [self.view addSubview:_textView];
}

- (void)clickToConnect{
    [self connectToServer];
}

- (void)clickToDisConnect{
    [_socket disconnect];
}

- (void)clickToSendText{
    [_socket writeData:[_textView.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:0 tag:0];
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
    NSLog(@"===============连接成功");
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
    
    NSLog(@"===============发送数据成功");
    
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
    
    NSLog(@"===============接收数据%@",receiverStr);
}



@end
