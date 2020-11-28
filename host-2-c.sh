export DEBIAN_FRONTEND=noninteractive

sudo ip link set dev enp0s8 up
sudo ip add add 192.168.7.4/24 dev enp0s8
sudo ip route add 10.1.1.0/30 via 192.168.7.1
sudo ip route add 192.168.0.0/21 via 192.168.7.1


sudo apt-get update                                     #update and upgrade of applications
sudo apt-get upgrade
sudo apt-get install -y docker.io                       #installation of docker engine
sudo docker pull nginx                                  #downloading nginx image
sudo docker run --name web-server -p 80:80 -d nginx     #running docker called 'web-server' using nginx on port 80:80


# Startup commands go here


