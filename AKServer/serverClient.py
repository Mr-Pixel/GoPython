#!/usr/bin/python
# -*- coding: UTF-8 -*-
# socket使用方法 https://blog.csdn.net/damotiansheng/article/details/44338411
import socket
import tkinter          # 导入 Tkinter 库
import threading

# 创建 socket 对象
server = socket.socket()        

# UI
window = tkinter.Tk()
window.title('Socket Server')
window.geometry('500x500')
receivedStr = tkinter.StringVar()
receivedStr.set("sdfasdfasd")


def setupUI():
    tkinter.Message(window, text="Received Msg", textvariable=receivedStr, width=500, aspect=1).pack()
    tkinter.Button(window, text="Start Server", command=startServer_newThread).pack()
    tkinter.Button(window, text="stop Server", command=stopServer).pack()
    window.mainloop()

def startServer_newThread():
    threading.Thread(target=startServer, args=()).start()

def startServer():
    host = socket.gethostname()     # 获取本地主机名
    port = 5389                     # 设置端口
    server.bind((host, port))       # 绑定端口
    server.listen(5)
    #print('Connecting by : %s ' % addr)
    while True:
        conn,addr = server.accept()
        print("链接成功：",addr)
        while True:
            data = conn.recv(1024).decode()
            receivedStr.set(data)
            conn.send("Server received".encode('utf8'))
        # conn.close()

def stopServer():
    server.close()

if __name__ == "__main__":
    setupUI()