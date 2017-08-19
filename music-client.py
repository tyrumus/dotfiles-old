import socket
import sys

cmd = sys.argv[1]

HOST = '127.0.0.1'
PORT = 10000
s = socket.socket()
s.connect((HOST, PORT))
s.send(cmd)
s.close()
sys.exit(0)
