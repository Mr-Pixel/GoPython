#!/usr/bin/python
# -*- coding: UTF-8 -*-

from tkinter import *
from tkinter import ttk # 导入ttk模块，因为下拉菜单控件在ttk中
import QzipManager
import os
import zlib

class Application(Frame):
    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.pack(fill = BOTH, expand = 1)
        self.createWidgets()

    def createWidgets(self):
        #Title
        self.titleLabel = Label(self, text = "压缩工具", foreground = "red")
        self.titleLabel.grid(row = 0, column = 0, pady = 20)

        #Combobox
        self.currentFile = StringVar()
        self.fileCombobox = ttk.Combobox(self, width=12, textvariable=self.currentFile)
        self.fileCombobox['values'] = self.fetchDeskTopFileList()     # 设置下拉列表的值
        self.fileCombobox.grid(row = 1, column = 0, padx = 20)
        self.fileCombobox.set(self.fetchDeskTopFileList()[0])

        #Compress
        self.compressButton = Button(self, text = "压缩", command = self.doCompress)
        self.compressButton.grid(row = 2, column = 0, padx = 20, pady = 20, stick = W)
        
        #Decompress
        self.decompressButton = Button(self, text = "解压", command = self.doDecompress)
        self.decompressButton.grid(row = 2, column = 0, padx = 20, pady = 20, stick = E)

    def fetchDeskTopFileList(self):
        path = os.path.expanduser('~') + "/DeskTop" #文件夹目录
        files= os.listdir(path) #得到文件夹下的所有文件名称

        vFiles = []
        for aFile in files:
            if not aFile.startswith('.'):
                vFiles.append(aFile)
        return vFiles
        
    def doCompress(self):
        inFilePath = os.path.expanduser('~') + "/DeskTop/" + self.fetchDeskTopFileList()[self.fileCombobox.current()]
        desFilePath = os.path.expanduser('~') + "/DeskTop/" + self.fetchDeskTopFileList()[self.fileCombobox.current()] + ".zip"
        infile = open(inFilePath, 'rb')
        dst = open(desFilePath, 'wb')
        compress = zlib.compressobj(9)
        data = infile.read(1024)
        while data:
            dst.write(compress.compress(data))
            data = infile.read(1024)
        dst.write(compress.flush())

        self.fileCombobox['values'] = self.fetchDeskTopFileList()     # 设置下拉列表的值
    
    def doDecompress(self):
        inFilePath = os.path.expanduser('~') + "/DeskTop/" + self.fetchDeskTopFileList()[self.fileCombobox.current()]
        desFilePath = os.path.expanduser('~') + "/DeskTop/" + "qzip_" + self.fetchDeskTopFileList()[self.fileCombobox.current()]
        desFilePath = desFilePath.replace(".zip", "")
        infile = open(inFilePath, 'rb')
        dst = open(desFilePath, 'wb')
        decompress = zlib.decompressobj()
        data = infile.read(1024)
        while data:
            dst.write(decompress.decompress(data))
            data = infile.read(1024)
        dst.write(decompress.flush())

        self.fileCombobox['values'] = self.fetchDeskTopFileList()     # 设置下拉列表的值

root = Tk()
root.title("QZip")
app = Application(master=root)
app.mainloop()
root.destroy()