#!/usr/bin/python
# -*- coding: UTF-8 -*-
# socket使用方法 https://blog.csdn.net/damotiansheng/article/details/44338411
import socket

server = socket.socket()         # 创建 socket 对象
host = socket.gethostname() # 获取本地主机名
port = 5389                # 设置端口
server.bind((host, port))        # 绑定端口
server.listen(5)
#print('Connecting by : %s ' % addr)
while True:
    conn,addr = server.accept()
    print(conn,addr)
    while True:
        data = conn.recv(1024).decode()
        print (data)
        user_input = input('>>>')
        conn.send(user_input.encode('utf8'))
    # conn.close()
server.close()