#!/usr/bin/env python
import socket
s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.setsockopt(socket.SOL_SOCKET,socket.SO_BROADCAST,True)
s.sendto('\xff'*6+'\x00\x0d\x93\x7e\x3b\xa3'*16, ('255.255.255.255', 80))
