import socket

UDP_IP = "192.168.0.7"
UDP_PORT = 5000
MESSAGE = "Hello World\x0d"

print("UDP target IP:", UDP_IP)
print("UDP target port:", UDP_PORT)
print("message:", MESSAGE)


data = bytes(MESSAGE, "utf-8")
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
sock.sendto(data, (UDP_IP, UDP_PORT))