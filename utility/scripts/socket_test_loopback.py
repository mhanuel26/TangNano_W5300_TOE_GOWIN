
import socket

UDP_IP = "192.168.0.7"
UDP_PORT = 5000
# MESSAGE = "Hello World"
# MESSAGE = "Hello 123 123 123 "
MESSAGE = "Hello 123 12"
# MESSAGE = b'\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b'

localIP     = "192.168.0.5"
localPort   = 5000
BUFF_SIZE  = 1024

if type(MESSAGE) == str:
    data = bytes(MESSAGE, "utf-8")
elif type(MESSAGE) == bytes:
    data = MESSAGE
print("data to send: ", data)

UDPServerSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
# Bind to address and ip
UDPServerSocket.bind((localIP, localPort))
print("UDP server up and listening")
print("Send initial message")
UDPServerSocket.sendto(data, (UDP_IP, UDP_PORT))
while(True):
    bytesAddressPair = UDPServerSocket.recvfrom(BUFF_SIZE)
    message = bytesAddressPair[0]
    address = bytesAddressPair[1]
    clientMsg = "Message from Client:{}".format(message)
    clientIP  = "Client IP Address:{}".format(address)
    print(clientMsg)
    print(clientIP)
    break
    