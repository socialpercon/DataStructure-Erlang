#!/usr/bin/python
# -*- coding: <UTF-8> -*-
import sys
from struct import *
import urllib2
def read_cmd():
     L = sys.stdin.read(4)
    if L == “”:
        return None
    (Len,) = unpack(‘>i’, L)
    Buf = sys.stdin.read(Len)
    if Buf == “”:
        return None
    return Buf
def write_cmd(Res):
    p1 = pack(‘>i’, 4)
    p2 = pack(‘>i’, Res)
    sys.stdout.write(p1)
    sys.stdout.write(p2)
    sys.stdout.flush()
def write_string(Str):
    l = len(Str)
    p1 = pack(‘>i’, l)
    p2 = pack(“>” + str(l) + “s”, Str)
    sys.stdout.write(p1)
    sys.stdout.write(p2)
    sys.stdout.flush()
#0
def sum(X, Y):
    return X + Y
#1
def double(X):
    return 2 * X
#2
def gethtml(url):
    urlf = urllib2.urlopen(url)
    return urlf.read()
if __name__ == “__main__”:
    Buf = read_cmd()    
    while Buf != None:
        (F,) = unpack(‘>B’, Buf[0])
        if F == 0:
            (X, Y) = unpack(‘>2i’, Buf[1:])
            write_cmd(sum(X, Y))
        elif F == 1:
            (X, ) = unpack(‘>i’, Buf[1:5])
            write_cmd(double(X))
        elif F == 2:
            l = len(Buf[1:])
            (X, ) = unpack(“>” + str(l) + “s”, Buf[1:])
            write_string(gethtml(X))
        else:
            sys.stdin.write(“some error occur!\n”)
        Buf = read_cmd()
