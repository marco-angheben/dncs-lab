export DEBIAN_FRONTEND=noninteractive

sudo ip link set dev enp0s8 up
sudo ip add add 192.168.7.4/24 dev enp0s8
sudo ip route add 10.1.1.0/30 via 192.168.7.1
sudo ip route add 192.168.0.0/21 via 192.168.7.1

#install docker
apt-get update
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io

# Pulling and running the nginx image
docker pull dustnic82/nginx-test
docker run -d -p 80:80 dustnic82/nginx-test
