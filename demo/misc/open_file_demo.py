"""
'r', 'w','a'  读 写 增加
'b'  二进制形式打开
'+'  允许同时读写 

全部模式
r rb r+ rb+ 
w wb w+ wb+
a ab a+ ab+
"""

#需要进行显示关闭
f=open("/root/ansible-2.7.4.zip","rb")
f.read()
f.close()


#结束模块时自动关闭 不必显式关闭
with open("/root/ansible-2.7.4.zip","rb") as f:
    f.read()
    
