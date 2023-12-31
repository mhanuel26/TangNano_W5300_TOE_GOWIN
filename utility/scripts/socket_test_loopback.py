
import socket

UDP_IP = "192.168.0.7"
UDP_PORT = 5000
# MESSAGE = "Hello World"
# MESSAGE = "Hello 123 123 123 "
MESSAGE = "Hello 123 14 "
# MESSAGE = b'\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b'

TX_PACKETS_SEND = 10

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
tx_count = TX_PACKETS_SEND
rx_count = 0
UDPServerSocket.sendto(data, (UDP_IP, UDP_PORT))
while(True):
    bytesAddressPair = UDPServerSocket.recvfrom(BUFF_SIZE)
    message = bytesAddressPair[0]
    address = bytesAddressPair[1]
    # clientMsg = "Message from Client:{}".format(message)
    # clientIP  = "Client IP Address:{}".format(address)
    # print(clientMsg)
    # print(clientIP)
    if data == message:
        rx_count += 1
        # print('loppback received data match!')
    else:
        print('loppback received error in packet number: %d' % rx_count)
        break

    tx_count -= 1
    if tx_count == 0:
        if(rx_count == TX_PACKETS_SEND):
            print("sucessfully received %d packets. Test done!" % rx_count)
        break
    else:
        # send until all transmitted
        UDPServerSocket.sendto(data, (UDP_IP, UDP_PORT))
    