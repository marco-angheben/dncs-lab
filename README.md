# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/fabrizio-granelli/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of your project

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 457 and 77 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 143 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/fabrizio-granelli/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner (fabrizio.granelli@unitn.it) that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design

### FIRST STEP:
I run _dcns-init_ script,which assigned me 3 values that need to be the number of scalable hosts in the subnets:
  * 457 for Host-A
  *  77 for Host-B
  * 143 for Host-C

 ### CREATE THE SUBNET
I establish to create 4 subnets:
1. The first is beetween router1 and router2. It has to cover only the 2 router and for this reson the subnet must be /30 (2<sup>32-30</sup> -2=2) I choose this slot of private adresses 198.168.1.0/30
2. The second is between between _router-1_ and _host-a_. in this case I have to cover 457 adresses so I need /23 as netmask (2<sup>32-24</sup> -2= 254(NOT ENOUGH) instead  2<sup>32-23</sup> -2= 510(OK)). I used subnet 192.168.4.0/23
3. The third  is between router-1 and host-b.it needs to accommodate up to 77 devices. In this case the subnet used is 192.168.3.0/25 (2<sup>32-25</sup> -2= 126)
The fourth is between router-2 and host-c. I chose here the subnet 192.168.7.0/24 in order to cover 143 adresses (the capacity would be 256)

### TRICKY POINT


### IMPLEMENTATION, COMMANDS and TEST
Following the instructions I made the routes as generic as possibl and for this reason I created only 1 route versus the 3 hosts. I used 192.168.0.0/21 as the destination of the route to cover all the IP from 192.168.0.0 to 192.168.7.255
Command for add a route:
+ `ip route add *IP-ADDRESS/NETMASK* via *INTERFACE* command`

In the image above I point out all the interfaces that I set to up with the relative IP adresses.
Here the commands I used:
+ enable the IP forwarding in the routers `sysctl -w net.ipv4.ip_forward=1 command´
+ add an IP address to a port  `ip add add *IP-ADDRESS/NETMASK* dev  *INTERFACE*`
+ set a port to up ip link set `dev  *INTERFACE* up command´

Regarding the switch it's important to build the vlans to keep host-a and host-b in separate subnets. I installed the openvswitch packages(the installing commands were already provided) and created to differnt vlan with tag 10 and 20.

About host-2-c was requested to run on it a docker image. I found the command for insallation,downloading nginx-image and running docker called 'web-server' using nginx on port 80:80.
All the commands were written down on file .sh 

FInally I try to `ping` all the possible connection between host-1-a, host-1-b and host-2-c.
furthermore (with curl) I was able to see the html page present in host-c docker webserver.

