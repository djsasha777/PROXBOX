
en 

conf t

hostname CustA2

interface FastEthernet0/0
 ip address 192.168.2.2 255.255.255.0
 no shutdown

interface FastEthernet1/0
 ip address 192.168.20.1 255.255.255.0
 no shutdown

router ospf 1
 network 0.0.0.0 255.255.255.255 area 0

end

wr