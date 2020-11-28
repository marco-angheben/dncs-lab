xport DEBIAN_FRONTEND=noninteractive

# Startup commands go here

sudo ip link set dev enp0s8 up                             #attivo la porta
sudo ip add add 192.168.0.4/23 dev enp0s8                  #assegno indirizzo ip alla porta
sudo ip route add 10.1.1.0/30 via 192.168.0.1              #assegno la rotta verso la subnet1 con router1
sudo ip route add 192.168.0.0/21 via 192.168.0.1           #rotta verso tutti gli altri host

