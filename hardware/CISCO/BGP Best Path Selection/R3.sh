enable

conf t

hostname R3

interface Loopback0
 ip address 10.0.0.3 255.255.255.255

interface Ethernet1/0
 ip address 192.168.3.2 255.255.255.0
 no shutdown

interface Ethernet1/1
 ip address 192.168.5.1 255.255.255.0
 no shutdown

router ospf 1
 network 10.0.0.0 0.0.0.255 area 0
 network 192.168.3.0 0.0.0.255 area 0

router bgp 65000
 bgp router-id 10.0.0.3
 bgp log-neighbor-changes
 neighbor 10.0.0.1 remote-as 65000
 neighbor 10.0.0.1 update-source Loopback0
 neighbor 10.0.0.1 next-hop-self
 neighbor 10.0.0.4 remote-as 65000
 neighbor 10.0.0.4 update-source Loopback0
 neighbor 10.0.0.4 next-hop-self
 neighbor 192.168.5.2 remote-as 65001

end

wr
