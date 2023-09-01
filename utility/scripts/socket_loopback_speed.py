
import socket
import time

UDP_IP = "192.168.0.7"
UDP_PORT = 5000
localIP     = "192.168.0.5"
localPort   = 5000
BUFF_SIZE  = 2048
PAYLOAD_SIZE = 1024
TX_PACKETS_SEND = 1024

data = bytearray()

for i in range(PAYLOAD_SIZE):
    value = i & 0x00ff
    data.extend(value.to_bytes(1, 'little'))

print("data len to send: %d" % len(data))
# print("data to send: ", data)

UDPServerSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
# Bind to address and ip
UDPServerSocket.bind((localIP, localPort))
print("UDP server up and listening")
print("Send initial message")
tx_count = TX_PACKETS_SEND
rx_count = 0
initial_tm = time.monotonic()
# send first packet
UDPServerSocket.sendto(data, (UDP_IP, UDP_PORT))
# loop thru all packets to send for speed test
while(True):
    bytesAddressPair = UDPServerSocket.recvfrom(BUFF_SIZE)
    message = bytesAddressPair[0]
    if data == message:
        rx_count += 1
    else:
        print('loppback received error in packet number: %d' % rx_count)
        break
    tx_count -= 1
    if tx_count == 0:
        end_tm = time.monotonic()
        if(rx_count == TX_PACKETS_SEND):
            print("sucessfully received %d packets. Test done!" % rx_count)
        break
    else:
        # send until all transmitted
        UDPServerSocket.sendto(data, (UDP_IP, UDP_PORT))

loopback_time = end_tm-initial_tm
loopback_data_ = PAYLOAD_SIZE*TX_PACKETS_SEND
print("Test Took %f ms" % (1000*loopback_time))
print(f'{loopback_data_} loopback rate is {loopback_data_ / (loopback_time*(1000 * 1000)):3.1f} MB/s')
