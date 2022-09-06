enable

conf t

hostname R1

vrf definition VRF1
 
 address-family ipv4
 exit-address-family

vrf definition VRF2
 
 address-family ipv4
 exit-address-family

interface FastEthernet0/0.10
 encapsulation dot1Q 10
 vrf forwarding VRF1
 ip address 192.168.10.1 255.255.255.0
 no shutdown

interface FastEthernet0/0.20
 encapsulation dot1Q 20
 vrf forwarding VRF2
 ip address 192.168.20.1 255.255.255.0
 no shutdown

interface FastEthernet0/0.30
 encapsulation dot1Q 30
 ip address 192.168.30.1 255.255.255.0
 no shutdown

interface FastEthernet1/0
 vrf forwarding VRF1
 ip address 192.168.1.1 255.255.255.0
 no shutdown

interface FastEthernet2/0
 vrf forwarding VRF2
 ip address 192.168.2.1 255.255.255.0
 no shutdown

interface FastEthernet3/0
 ip address 192.168.3.1 255.255.255.0
 no shutdown

end

wr