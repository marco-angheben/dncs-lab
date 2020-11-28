export DEBIAN_FRONTEND=noninteractive

# Startup commands go here

sudo ip link set dev enp0s8 up
sudo ip add add 192.168.3.4/25 dev enp0s8
sudo ip route add 10.1.1.0/30 via 192.168.3.1
sudo ip route add 192.168.0.0/21 via 192.168.3.1
